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
}) {
  return showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.grays.white.withValues(alpha: 0.0),
    builder: (_) => CloudFolderNameBottomSheet(initialName: initialName),
  );
}

class CloudFolderNameBottomSheet extends StatefulWidget {
  const CloudFolderNameBottomSheet({super.key, this.initialName});

  final String? initialName;

  @override
  State<CloudFolderNameBottomSheet> createState() =>
      _CloudFolderNameBottomSheetState();
}

class _CloudFolderNameBottomSheetState
    extends State<CloudFolderNameBottomSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName ?? '',
  );

  bool get _isEditing => widget.initialName != null;
  bool get _canSubmit => _controller.text.trim().isNotEmpty;

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
              _isEditing ? '폴더 이름 수정하기' : '새 폴더 만들기',
              textAlign: TextAlign.center,
              style: FontStyles.bold26.copyWith(color: context.grays.black),
            ),
            const SizedBox(height: AppSpacing.x24),
            AppTextField(
              controller: _controller,
              label: '폴더 이름',
              hintText: '폴더 이름을 입력해주세요.',
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.x24),
            AppButton(
              text: _isEditing ? '수정하기' : '만들기',
              isDisabled: !_canSubmit,
              onPressed: _canSubmit
                  ? () => Navigator.of(context).pop(_controller.text.trim())
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
