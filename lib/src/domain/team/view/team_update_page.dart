import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/domain/team/view/team_create_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import '../../../core/extensions/app_gray_colors.dart';
import '../../../core/widgets/buttons/app_upload_button.dart';
import '../../../core/widgets/inputs/app_text_area.dart';

class TeamUpdatePage extends StatefulWidget {
  const TeamUpdatePage({super.key});

  @override
  State<TeamUpdatePage> createState() => _TeamUpdatePageState();
}

class _TeamUpdatePageState extends State<TeamUpdatePage> {
  final teamNameController = TextEditingController();
  final teamDescriptionController = TextEditingController();
  final teamDateController = TextEditingController();
  final List<TextEditingController> _linkControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  bool get _isTeamNameValid {
    final text = teamNameController.text.trim();
    return text.isNotEmpty && text.length <= 10;
  }

  String? get _teamNameErrorText {
    if (teamNameController.text.isEmpty) return null;
    if (!_isTeamNameValid) return '팀 이름은 한 글자 이상 10글자 이하로 작성해주세요.';
    return null;
  }

  void _addLinkField() {
    setState(() {
      _linkControllers.add(TextEditingController());
    });
  }

  void _removeLinkField(int index) {
    setState(() {
      _linkControllers[index].dispose();
      _linkControllers.removeAt(index);
    });
  }

  bool get _canSubmit {
    return _isTeamNameValid && teamDescriptionController.text.isNotEmpty;
  }

  @override
  void dispose() {
    teamNameController.dispose();
    teamDescriptionController.dispose();
    teamDateController.dispose();
    for (var controller in _linkControllers) {
      controller.dispose();
    }
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
                      AppTextField(
                        hintText: '팀 이름 (10글자 이내)',
                        requiredMark: true,
                        label: '팀 이름',
                        controller: teamNameController,
                        errorText: _teamNameErrorText,
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      AppTextField(
                        label: '팀 개설일',
                        requiredMark: true,
                        hintText: '날짜를 선택해주세요',
                        controller: teamDateController,
                        readOnly: true,
                        suffixIcon: Image.asset(
                          'assets/icons/navigation/calendar_gray.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x20),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '사진 등록',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),

                      const SizedBox(height: AppSpacing.x8),
                      AppUploadButton(text: '팀 사진 등록하기', onPressed: () {}),

                      const SizedBox(height: AppSpacing.x20),

                      AppTextArea(
                        label: '팀 소개',
                        requiredMark: true,
                        hintText: '모임에 어울리는 팀 소개글을 작성해주세요.',
                        controller: teamDescriptionController,
                        maxLength: 200,
                        fieldHeight: 196,
                        onChanged: (_) => setState(() {}),
                      ),

                      Text(
                        '링크 등록',
                        style: FontStyles.med14.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x8),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _linkControllers.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.x8),
                        itemBuilder: (context, index) {
                          return _LinkInputField(
                            controller: _linkControllers[index],
                            onDelete: () => _removeLinkField(index),
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.x12),

                      Center(
                        child: GestureDetector(
                          onTap: _addLinkField,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF8E8E93),
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.x24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x16),

              AppButton(
                text: '저장하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: ButtonVariant.primary,
                onPressed: _canSubmit
                    ? () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamCreateSuccessPage(
                              teamName: teamNameController.text,
                            ),
                          ),
                          (route) => route.isFirst,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkInputField extends StatelessWidget {
  const _LinkInputField({required this.controller, required this.onDelete});

  final TextEditingController controller;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: context.grays.gray8,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/team/instagram.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                context.grays.gray6,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: context.grays.gray8,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: TextField(
                controller: controller,
                style: FontStyles.reg18.copyWith(color: context.grays.gray5),
                decoration: InputDecoration(
                  hintText: '링크 붙여넣기',
                  border: InputBorder.none,
                  hintStyle: FontStyles.reg18.copyWith(
                    color: context.grays.gray5,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        GestureDetector(
          onTap: onDelete,
          child: SvgPicture.asset(
            'assets/icons/etc/cancel.svg',
            width: 16,
            height: 16,
          ),
        ),
      ],
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
    final style = FontStyles.semi14;
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: color),
          children: [
            TextSpan(text: text, style: style),
            TextSpan(
              text: ' *',
              style: style.copyWith(color: requiredColor),
            ),
          ],
        ),
      ),
    );
  }
}
