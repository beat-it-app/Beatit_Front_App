import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

Future<String?> showCloudFileRenamePopup(
  BuildContext context, {
  required String initialFileName,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => CloudFileRenamePopup(initialFileName: initialFileName),
  );
}

class CloudFileRenamePopup extends StatefulWidget {
  const CloudFileRenamePopup({super.key, required this.initialFileName});

  final String initialFileName;

  @override
  State<CloudFileRenamePopup> createState() => _CloudFileRenamePopupState();
}

class _CloudFileRenamePopupState extends State<CloudFileRenamePopup> {
  late final _ParsedFileName _parsedFileName = _ParsedFileName.from(
    widget.initialFileName,
  );
  late final TextEditingController _controller = TextEditingController(
    text: _parsedFileName.baseName,
  );

  String get _resolvedFileName {
    final baseName = _controller.text.trim().isEmpty
        ? _parsedFileName.baseName
        : _controller.text.trim();

    if (_parsedFileName.extension.isEmpty) {
      return baseName;
    }

    return '$baseName.${_parsedFileName.extension}';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: context.grays.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 310),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x16,
            AppSpacing.x16,
            AppSpacing.x16,
            AppSpacing.x16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x16),
                child: Text(
                  '이름 수정하기',
                  textAlign: TextAlign.center,
                  style: FontStyles.bold22.copyWith(color: context.grays.black),
                ),
              ),
              const SizedBox(height: AppSpacing.x8),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 45),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x10),
                decoration: BoxDecoration(
                  color: context.grays.gray8,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        maxLines: 1,
                        cursorColor: context.colors.primary,
                        style: FontStyles.reg18.copyWith(
                          color: context.colors.onSurface,
                        ),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        onFieldSubmitted: (_) {
                          Navigator.of(context).pop(_resolvedFileName);
                        },
                      ),
                    ),
                    if (_parsedFileName.extension.isNotEmpty)
                      Text(
                        '.${_parsedFileName.extension}',
                        style: FontStyles.reg18.copyWith(
                          color: context.colors.onSurface,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x40),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: '취소',
                      variant: ButtonVariant.gray,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  Expanded(
                    child: AppButton(
                      text: '확인',
                      onPressed: () {
                        Navigator.of(context).pop(_resolvedFileName);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParsedFileName {
  const _ParsedFileName({required this.baseName, required this.extension});

  final String baseName;
  final String extension;

  factory _ParsedFileName.from(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    final hasExtension = dotIndex > 0 && dotIndex < fileName.length - 1;

    return _ParsedFileName(
      baseName: hasExtension ? fileName.substring(0, dotIndex) : fileName,
      extension: hasExtension ? fileName.substring(dotIndex + 1) : '',
    );
  }
}
