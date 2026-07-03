import 'package:flutter/material.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/bottons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';

import 'preview_profile_page.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _nameController = TextEditingController();

  String get _profileName {
    return _nameController.text.trim();
  }

  bool get _canSubmit {
    return _profileName.isNotEmpty;
  }

  void _handleNextPressed() {
    if (!_canSubmit) {
      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PreviewProfilePage(userName: _profileName),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x24,
            horizontal: AppSpacing.x16,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '프로필\n생성하기',
                        style: FontStyles.bold46.copyWith(
                          color: colors.onSurface,
                          height: 1.2,
                          letterSpacing: -0.92,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x10),
                      Text(
                        '설정된 이름은 팀원들과 공유됩니다.',
                        style: FontStyles.med16.copyWith(
                          color: context.grays.gray5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x40),
                      _RequiredLabel(
                        text: '이름',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      AppTextField(
                        hintText: '이름을 입력하세요.',
                        controller: _nameController,
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              AppButton(
                text: '다음',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.black,
                onPressed: _canSubmit ? _handleNextPressed : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel({
    required this.text,
    required this.color,
    required this.requiredColor,
  });

  final String text;
  final Color color;
  final Color requiredColor;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: color);

    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: labelStyle,
          children: [
            TextSpan(text: text),
            TextSpan(
              text: ' *',
              style: labelStyle?.copyWith(color: requiredColor),
            ),
          ],
        ),
      ),
    );
  }
}
