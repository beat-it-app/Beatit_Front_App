import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_media_source_popup.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

// 파일 선택/검증을 먼저 마치고 나서 확인 바텀시트를 표시합니다.
// 선택을 취소하거나 지원하지 않는 파일이면 바텀시트는 생성되지 않습니다.
Future<CloudFileUploadSelection?> showCloudFileUploadBottomSheet({
  required BuildContext context,
}) async {
  final initialSelection = await _pickCloudFile(context);
  if (!context.mounted || initialSelection == null) return null;

  return showModalBottomSheet<CloudFileUploadSelection>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.grays.white.withValues(alpha: 0.0),
    builder: (_) =>
        CloudFileUploadBottomSheet(initialSelection: initialSelection),
  );
}

const int _maxCloudFileSize = 300 * 1024 * 1024;
const Set<String> _allowedCloudFileExtensions = {
  'jpg',
  'jpeg',
  'png',
  'gif',
  'webp',
  'heic',
  'mp3',
  'wav',
  'm4a',
  'aac',
  'ogg',
  'flac',
  'mp4',
  'mov',
  'avi',
  'pdf',
  'zip',
  'hwp',
  'docx',
};

Future<AppMediaSource?> _chooseCloudFileSource(BuildContext context) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return showCupertinoModalPopup<AppMediaSource>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () =>
                Navigator.pop(sheetContext, AppMediaSource.photoLibrary),
            child: const Text('사진 보관함'),
          ),
          CupertinoActionSheetAction(
            onPressed: () =>
                Navigator.pop(sheetContext, AppMediaSource.fileBrowser),
            child: const Text('파일 탐색기'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(sheetContext),
          child: const Text('취소'),
        ),
      ),
    );
  }

  return AppMediaSourcePopup.show(
    context,
    sources: const [AppMediaSource.photoLibrary, AppMediaSource.fileBrowser],
  );
}

Future<void> _showCloudFileBlockedPopup(
  BuildContext context,
  String message,
) async {
  if (!context.mounted) return;
  await AppPopup.show(
    context,
    title: '업로드할 수 없는 파일입니다.',
    content: message,
    warningType: WarningType.triangle,
    confirmText: '확인',
  );
}

Future<CloudFileUploadSelection?> _pickCloudFile(BuildContext context) async {
  final source = await _chooseCloudFileSource(context);
  if (!context.mounted || source == null) return null;

  try {
    String? path;
    String? name;
    int? size;
    if (source == AppMediaSource.fileBrowser) {
      final files = await FilePicker.pickFiles();
      if (files.isEmpty) return null;
      final file = files.first;
      path = file.path;
      name = file.name;
      size = await file.length();
    } else {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );
      if (image == null) return null;
      path = image.path;
      name = image.name;
      size = await image.length();
    }

    if (!context.mounted) return null;
    if (path == null ||
        path.trim().isEmpty ||
        name == null ||
        name.trim().isEmpty) {
      await _showCloudFileBlockedPopup(context, '선택한 파일의 경로를 확인할 수 없습니다.');
      return null;
    }
    final lastDot = name.lastIndexOf('.');
    final extension = lastDot < 0 || lastDot == name.length - 1
        ? ''
        : name.substring(lastDot + 1).toLowerCase();
    if (!_allowedCloudFileExtensions.contains(extension)) {
      await _showCloudFileBlockedPopup(context, '지원하지 않는 파일 형식입니다.');
      return null;
    }
    if (size == null || size <= 0) {
      await _showCloudFileBlockedPopup(context, '빈 파일은 등록할 수 없습니다.');
      return null;
    }
    if (size > _maxCloudFileSize) {
      await _showCloudFileBlockedPopup(context, '300MB를 초과하는 파일은 업로드할 수 없습니다.');
      return null;
    }
    return CloudFileUploadSelection(path: path, name: name, size: size);
  } catch (error) {
    debugPrint('[CloudFileUpload] pick failed: $error');
    if (context.mounted) {
      await _showCloudFileBlockedPopup(context, '파일을 가져오지 못했습니다. 다시 시도해주세요.');
    }
    return null;
  }
}

class CloudFileUploadSelection {
  const CloudFileUploadSelection({
    required this.path,
    required this.name,
    required this.size,
  });

  final String path;
  final String name;
  final int size;
}

class CloudFileUploadBottomSheet extends StatefulWidget {
  const CloudFileUploadBottomSheet({super.key, required this.initialSelection});

  final CloudFileUploadSelection initialSelection;

  @override
  State<CloudFileUploadBottomSheet> createState() =>
      _CloudFileUploadBottomSheetState();
}

class _CloudFileUploadBottomSheetState
    extends State<CloudFileUploadBottomSheet> {
  late String? _selectedPath;
  late String? _selectedName;
  late int? _selectedFileSize;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _selectedPath = widget.initialSelection.path;
    _selectedName = widget.initialSelection.name;
    _selectedFileSize = widget.initialSelection.size;
  }

  bool get _canSubmit {
    final fileSize = _selectedFileSize;

    return _selectedName != null &&
        _selectedPath != null &&
        _selectedPath!.trim().isNotEmpty &&
        fileSize != null &&
        fileSize > 0 &&
        fileSize <= _maxCloudFileSize;
  }

  Future<void> _pickFile() async {
    if (_isPicking) return;
    setState(() => _isPicking = true);
    try {
      final selection = await _pickCloudFile(context);
      if (!mounted || selection == null) return;
      setState(() {
        _selectedPath = selection.path;
        _selectedName = selection.name;
        _selectedFileSize = selection.size;
      });
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  void _submit() {
    final fileSize = _selectedFileSize;
    final path = _selectedPath;
    final name = _selectedName;

    if (!_canSubmit || name == null || fileSize == null || path == null) return;

    Navigator.of(
      context,
    ).pop(CloudFileUploadSelection(path: path, name: name, size: fileSize));
  }

  String _formatBytes(int bytes) {
    const kb = 1024;
    const mb = 1024 * 1024;

    if (bytes >= mb) {
      return '${(bytes / mb).toStringAsFixed(1)}MB';
    }

    if (bytes >= kb) {
      return '${(bytes / kb).toStringAsFixed(1)}KB';
    }

    return '${bytes}B';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final file = _selectedName;
    final fileSize = _selectedFileSize;

    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x20,
          AppSpacing.x30,
          AppSpacing.x20,
          AppSpacing.x20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '파일 등록하기',
              textAlign: TextAlign.center,
              style: FontStyles.bold26.copyWith(color: context.grays.black),
            ),
            const SizedBox(height: AppSpacing.x8),
            Text(
              '팀원이 함께 사용할 파일을 선택해주세요. 최대 300MB까지 등록할 수 있어요.',
              textAlign: TextAlign.center,
              style: FontStyles.med14.copyWith(color: context.grays.gray4),
            ),
            const SizedBox(height: AppSpacing.x24),
            InkWell(
              onTap: _isPicking ? null : _pickFile,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.x20),
                decoration: BoxDecoration(
                  color: context.grays.gray8,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: context.grays.gray7),
                ),
                child: Column(
                  children: [
                    if (_isPicking)
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: colors.primary,
                        ),
                      )
                    else
                      Icon(
                        file == null
                            ? Icons.upload_file_rounded
                            : Icons.insert_drive_file_rounded,
                        size: 36,
                        color: colors.primary,
                      ),
                    const SizedBox(height: AppSpacing.x12),
                    Text(
                      _isPicking ? '불러오는 중...' : file ?? '파일 선택하기',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: FontStyles.semi18.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                    if (!_isPicking && file != null && fileSize != null) ...[
                      const SizedBox(height: AppSpacing.x4),
                      Text(
                        _formatBytes(fileSize),
                        style: FontStyles.med14.copyWith(
                          color: context.grays.gray5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x24),
            AppButton(
              text: '등록하기',
              isDisabled: !_canSubmit || _isPicking,
              onPressed: _canSubmit && !_isPicking ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}
