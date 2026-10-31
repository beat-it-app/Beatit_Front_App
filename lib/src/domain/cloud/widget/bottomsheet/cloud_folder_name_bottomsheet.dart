import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:flutter/material.dart';

Future<String?> showCloudFolderNameBottomSheet({
  required BuildContext context,
  String? initialName,
  bool isItemName = false,
  String itemLabel = '파일',
  bool preserveExtension = false,
}) {
  return showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.grays.white.withValues(alpha: 0.0),
    builder: (_) => CloudFolderNameBottomSheet(
      initialName: initialName,
      isItemName: isItemName,
      itemLabel: itemLabel,
      preserveExtension: preserveExtension,
    ),
  );
}

class CloudFolderNameBottomSheet extends StatefulWidget {
  const CloudFolderNameBottomSheet({
    super.key,
    this.initialName,
    this.isItemName = false,
    this.itemLabel = '파일',
    this.preserveExtension = false,
  });

  final String? initialName;
  final bool isItemName;
  final String itemLabel;
  final bool preserveExtension;

  @override
  State<CloudFolderNameBottomSheet> createState() =>
      _CloudFolderNameBottomSheetState();
}

class _CloudFolderNameBottomSheetState
    extends State<CloudFolderNameBottomSheet> {
  // 파일의 확장자는 실제 저장된 파일 유형과 혼동되지 않도록 보존합니다.
  late final String _extension = _fileExtension;
  String get _fileExtension {
    if (!widget.preserveExtension || widget.initialName == null) return '';
    final name = widget.initialName!;
    final dot = name.lastIndexOf('.');
    return dot > 0 && dot < name.length - 1 ? name.substring(dot) : '';
  }

  late final TextEditingController _controller = TextEditingController(
    text: _extension.isEmpty
        ? widget.initialName ?? ''
        : widget.initialName!.substring(0, widget.initialName!.length - _extension.length),
  );

  bool get _isEditing => widget.initialName != null;
  bool get _canSubmit => _controller.text.trim().isNotEmpty;
  String get _submittedName => '${_controller.text.trim()}$_extension';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.x20,
          AppSpacing.x30,
          AppSpacing.x20,
          AppSpacing.x20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.isItemName ? '${widget.itemLabel} 이름 수정하기' :
                  _isEditing ? '폴더 이름 수정하기' : '새 폴더 만들기',
              textAlign: TextAlign.center,
              style: FontStyles.bold26.copyWith(color: context.grays.black),
            ),
            const SizedBox(height: AppSpacing.x24),
            AppTextField(
              controller: _controller,
              label: widget.isItemName ? '${widget.itemLabel} 이름' : '폴더 이름',
              hintText: widget.isItemName ? '${widget.itemLabel} 이름을 입력해주세요.' : '폴더 이름을 입력해주세요.',
              suffixIcon: _extension.isEmpty
                  ? null
                  : Text(
                      _extension,
                      style: FontStyles.reg18.copyWith(color: context.grays.black),
                    ),
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.x24),
            AppButton(
              text: _isEditing ? '수정하기' : '만들기',
              isDisabled: !_canSubmit,
              onPressed: _canSubmit
                  ? () => Navigator.of(context).pop(_submittedName)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
