import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:file_picker/file_picker.dart';
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

  PlatformFile? _selectedFile;
  int? _selectedFileSize;
  String? _errorText;
  bool _isPicking = false;

  bool get _canSubmit {
    final file = _selectedFile;
    final fileSize = _selectedFileSize;

    return file != null &&
        file.path != null &&
        file.path!.trim().isNotEmpty &&
        fileSize != null &&
        fileSize > 0 &&
        fileSize <= _maxFileSize &&
        _errorText == null;
  }

  Future<void> _pickFile() async {
    if (_isPicking) {
      return;
    }

    setState(() {
      _isPicking = true;
      _errorText = null;
    });

    try {
      // 현재 Beat It 프로젝트에서 사용 중인 file_picker API에 맞춘 방식이다.
      // 최신 FilePicker.platform API를 사용하지 않는다.
      final pickedFiles = await FilePicker.pickFiles();

      if (!mounted || pickedFiles.isEmpty) {
        return;
      }

      final file = pickedFiles.first;
      final path = file.path;
      final fileSize = await file.length() ?? 0;
      final extension = _extensionOf(file.name);

      String? errorText;

      if (path == null || path.trim().isEmpty) {
        errorText = '선택한 파일의 경로를 확인할 수 없습니다.';
      } else if (extension == null || !_allowedExtensions.contains(extension)) {
        errorText = '지원하지 않는 파일 형식입니다.';
      } else if (fileSize <= 0) {
        errorText = '빈 파일은 등록할 수 없습니다.';
      } else if (fileSize > _maxFileSize) {
        errorText = '파일은 최대 300MB까지 등록할 수 있습니다.';
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedFile = file;
        _selectedFileSize = fileSize;
        _errorText = errorText;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  void _submit() {
    final file = _selectedFile;
    final fileSize = _selectedFileSize;
    final path = file?.path;

    if (!_canSubmit || file == null || fileSize == null || path == null) {
      return;
    }

    Navigator.of(context).pop(
      CloudFileUploadSelection(
        path: path,
        name: file.name,
        size: fileSize,
      ),
    );
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
    final file = _selectedFile;
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
              style: FontStyles.bold26.copyWith(
                color: context.grays.black,
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
            Text(
              '팀원이 함께 사용할 파일을 선택해주세요. 최대 300MB까지 등록할 수 있어요.',
              textAlign: TextAlign.center,
              style: FontStyles.med14.copyWith(
                color: context.grays.gray4,
              ),
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
                  border: Border.all(
                    color: context.grays.gray7,
                  ),
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
                      _isPicking
                          ? '파일을 불러오는 중...'
                          : file?.name ?? '파일 선택하기',
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
                style: FontStyles.med12.copyWith(
                  color: colors.error,
                ),
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
