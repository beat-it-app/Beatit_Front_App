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

Future<CloudFileUploadSelection?> showCloudFileUploadBottomSheet({
  required BuildContext context,
}) {
  return showModalBottomSheet<CloudFileUploadSelection>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.grays.white.withValues(alpha: 0.0),
    builder: (_) => const CloudFileUploadBottomSheet(),
  );
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
  const CloudFileUploadBottomSheet({super.key});

  @override
  State<CloudFileUploadBottomSheet> createState() =>
      _CloudFileUploadBottomSheetState();
}

class _CloudFileUploadBottomSheetState
    extends State<CloudFileUploadBottomSheet> {
  static const int _maxFileSize = 300 * 1024 * 1024;

  static const Set<String> _allowedExtensions = {
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

  String? _selectedPath;
  String? _selectedName;
  int? _selectedFileSize;
  final ImagePicker _imagePicker = ImagePicker();
  String? _errorText;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    // A single tap on Upload opens the OS-adapted source selector.
    // The existing confirmation sheet stays below it for validation/submission.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _pickFile();
    });
  }

  bool get _canSubmit {
    final fileSize = _selectedFileSize;

    return _selectedName != null &&
        _selectedPath != null &&
        _selectedPath!.trim().isNotEmpty &&
        fileSize != null &&
        fileSize > 0 &&
        fileSize <= _maxFileSize &&
        _errorText == null;
  }

  /// iOS는 기존 Cupertino 액션 시트, Android는 공통 작업 선택 팝업.
  Future<AppMediaSource?> _chooseSource() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return showCupertinoModalPopup<AppMediaSource>(
        context: context,
        builder: (sheetContext) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(
                sheetContext, AppMediaSource.photoLibrary),
              child: const Text('사진 보관함'),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(
                sheetContext, AppMediaSource.fileBrowser),
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

  Future<void> _pickFile() async {
    if (_isPicking) return;

    final source = await _chooseSource();
    if (!mounted || source == null) return;

    setState(() {
      _isPicking = true;
      _errorText = null;
    });
    try {
      String? path;
      String? name;
      int? fileSize;

      if (source == AppMediaSource.fileBrowser) {
        // Preserve the current file_picker API used in this codebase.
        final files = await FilePicker.pickFiles();
        if (files.isEmpty) return;
        final file = files.first;
        path = file.path;
        name = file.name;
        fileSize = await file.length();
      } else {
        final file = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          // Do not compress automatically. Keep the original file quality.
          requestFullMetadata: false,
        );
        if (file == null) return;
        path = file.path;
        name = file.name;
        fileSize = await file.length();
      }

      if (!mounted) return;
      if (path == null ||
          path.trim().isEmpty ||
          name == null ||
          name.trim().isEmpty) {
        setState(() {
          _selectedPath = null;
          _selectedName = null;
          _selectedFileSize = null;
          _errorText = '선택한 파일의 경로를 확인할 수 없습니다.';
        });
        return;
      }

      final extension = _extensionOf(name);
      if (extension == null || !_allowedExtensions.contains(extension)) {
        await _showBlockedPopup('지원하지 않는 파일 형식입니다.');
        return;
      }
      if (fileSize == null || fileSize <= 0) {
        setState(() {
          _selectedPath = null;
          _selectedName = null;
          _selectedFileSize = null;
          _errorText = '빈 파일은 등록할 수 없습니다.';
        });
        return;
      }
      if (fileSize > _maxFileSize) {
        await _showBlockedPopup('300MB를 초과하는 파일은 업로드할 수 없습니다.');
        return;
      }
      setState(() {
        _selectedPath = path;
        _selectedName = name;
        _selectedFileSize = fileSize;
        _errorText = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorText = '파일을 가져오지 못했습니다. 다시 시도해주세요.';
      });
      debugPrint('[CloudFileUploadBottomSheet] pick failed: $error');
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  Future<void> _showBlockedPopup(String content) async {
    if (!mounted) return;
    setState(() {
      _selectedPath = null;
      _selectedName = null;
      _selectedFileSize = null;
      _errorText = null;
    });
    await AppPopup.show(
      context,
      title: '업로드할 수 없는 파일입니다.',
      content: content,
      warningType: WarningType.triangle,
      confirmText: '확인',
    );
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

  String? _extensionOf(String fileName) {
    final lastDotIndex = fileName.lastIndexOf('.');

    if (lastDotIndex < 0 || lastDotIndex == fileName.length - 1) {
      return null;
    }

    return fileName.substring(lastDotIndex + 1).toLowerCase();
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
                      _isPicking ? '파일을 불러오는 중...' : file ?? '파일 선택하기',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: FontStyles.med16.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                    if (!_isPicking && file != null && fileSize != null) ...[
                      const SizedBox(height: AppSpacing.x4),
                      Text(
                        _formatBytes(fileSize),
                        style: FontStyles.med12.copyWith(
                          color: context.grays.gray5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (_errorText != null) ...[
              const SizedBox(height: AppSpacing.x8),
              Text(
                _errorText!,
                style: FontStyles.med12.copyWith(color: colors.error),
              ),
            ],
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
