import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  final FocusNode _focusNode = FocusNode();

  void _clearFileName() {
    _controller.clear();
    _focusNode.requestFocus();
    setState(() {});
  }

  bool get _canSubmit => _controller.text.trim().isNotEmpty;

  String get _resolvedFileName {
    final baseName = _controller.text.trim();

    if (_parsedFileName.extension.isEmpty) {
      return baseName;
    }

    return '$baseName.${_parsedFileName.extension}';
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      maxLines: 1,
      cursorColor: context.colors.primary,
      style: FontStyles.reg18.copyWith(color: context.colors.onSurface),
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
        // 파일명은 확인 버튼으로만 확정합니다.
        if (!widget.preserveExtension && _canSubmit) {
          Navigator.of(context).pop(_resolvedFileName);
        }
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
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
                      child: _parsedFileName.extension.isEmpty
                          ? _buildNameField(context)
                          : Row(
                              children: [
                                Flexible(
                                  // 입력창이 실제 파일명 폭(+커서 3px)만 차지하도록
                                  // 하여 확장자가 파일명 바로 뒤에 붙게 합니다.
                                  child: IntrinsicWidth(
                                    child: _buildNameField(context),
                                  ),
                                ),
                                // 커서 여백 3px과 합쳐 파일명과 4px 간격입니다.
                                const SizedBox(width: 1),
                                Text(
                                  '.${_parsedFileName.extension}',
                                  style: FontStyles.reg18.copyWith(
                                    color: context.grays.gray5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    if (widget.preserveExtension) ...[
                      const SizedBox(width: AppSpacing.x8),
                      TextFieldTapRegion(
                        child: IconButton(
                          tooltip: '파일 이름 지우기',
                          onPressed: _controller.text.isEmpty
                              ? null
                              : _clearFileName,
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            maxWidth: 20,
                            minHeight: 40,
                          ),
                          padding: EdgeInsets.zero,
                          // 기본 48px 터치 영역이 좌우 여백으로 보이지 않게 합니다.
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: SvgPicture.asset(
                            'assets/icons/etc/cancel.svg',
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              context.grays.gray6,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
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
  const CloudFileRenamePopup({super.key, required String initialFileName})
    : super(initialName: initialFileName, preserveExtension: true);
}
