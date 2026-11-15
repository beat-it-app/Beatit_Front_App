import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

Future<String?> showCloudRenamePopup(
  BuildContext context, {
  required String initialName,
  bool preserveExtension = false,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => CloudRenamePopup(
      initialName: initialName,
      preserveExtension: preserveExtension,
    ),
  );
}

class CloudRenamePopup extends StatefulWidget {
  const CloudRenamePopup({
    super.key,
    required this.initialName,
    this.preserveExtension = false,
  });

  final String initialName;
  final bool preserveExtension;

  @override
  State<CloudRenamePopup> createState() => _CloudRenamePopupState();
}

class _CloudRenamePopupState extends State<CloudRenamePopup> {
  late final _ParsedFileName _parsedFileName = _ParsedFileName.from(
    widget.initialName,
    preserveExtension: widget.preserveExtension,
  );
  late final TextEditingController _controller = TextEditingController(
    text: _parsedFileName.baseName,
  );

  bool get _canSubmit => _controller.text.trim().isNotEmpty;

  String get _resolvedFileName {
    final baseName = _controller.text.trim();

    if (_parsedFileName.extension.isEmpty) {
      return baseName;
    }

    return '$baseName.${_parsedFileName.extension}';
  }

  double _fileNameTextWidth(BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(
        text: _controller.text.isEmpty ? ' ' : _controller.text,
        style: FontStyles.reg18,
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    // 편집 커서가 잘리지 않도록 여유를 두고 짧은 이름도 편하게 편집합니다.
    final width = painter.width + 4;
    painter.dispose();
    return width < 32 ? 32 : width;
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
                    Flexible(
                      fit: FlexFit.loose,
                      child: SizedBox(
                        // 파일명 길이만큼만 입력창을 차지하도록 하여 확장자가
                        // 남은 입력 영역의 오른쪽 끝으로 밀리지 않게 합니다.
                        width: _parsedFileName.extension.isEmpty
                            ? double.infinity
                            : _fileNameTextWidth(context),
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
                          onChanged: (_) => setState(() {}),
                          onFieldSubmitted: (_) {
                            if (_canSubmit) {
                              Navigator.of(context).pop(_resolvedFileName);
                            }
                          },
                        ),
                      ),
                    ),
                    if (_parsedFileName.extension.isNotEmpty)
                      Text(
                        '.${_parsedFileName.extension}',
                        style: FontStyles.reg18.copyWith(
                          color: context.grays.gray5,
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
                      isDisabled: !_canSubmit,
                      onPressed: _canSubmit
                          ? () => Navigator.of(context).pop(_resolvedFileName)
                          : null,
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

  factory _ParsedFileName.from(
    String fileName, {
    required bool preserveExtension,
  }) {
    final dotIndex = fileName.lastIndexOf('.');
    final hasExtension =
        preserveExtension && dotIndex > 0 && dotIndex < fileName.length - 1;

    return _ParsedFileName(
      baseName: hasExtension ? fileName.substring(0, dotIndex) : fileName,
      extension: hasExtension ? fileName.substring(dotIndex + 1) : '',
    );
  }
}

/// 기존 파일 이름 수정 호출부와의 호환성을 유지합니다.
Future<String?> showCloudFileRenamePopup(
  BuildContext context, {
  required String initialFileName,
}) => showCloudRenamePopup(
  context,
  initialName: initialFileName,
  preserveExtension: true,
);

/// 기존 이름 수정 팝업 타입과의 호환성을 유지합니다.
class CloudFileRenamePopup extends CloudRenamePopup {
  const CloudFileRenamePopup({
    super.key,
    required String initialFileName,
  }) : super(initialName: initialFileName, preserveExtension: true);
}
