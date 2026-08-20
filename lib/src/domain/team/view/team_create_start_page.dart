import 'package:flutter/material.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import '../../../core/widgets/buttons/app_upload_button.dart';
import '../../../core/widgets/inputs/app_text_area.dart';
import '../../../core/widgets/toggles/app_toggle.dart';
import 'team_create_success_page.dart';

class TeamCreatePage extends StatefulWidget {
  const TeamCreatePage({super.key});

  @override
  State<TeamCreatePage> createState() => _TeamCreatePageState();
}

class _TeamCreatePageState extends State<TeamCreatePage> {
  final teamNameController = TextEditingController();
  final teamDescriptionController = TextEditingController();
  final teamDateController = TextEditingController();

  String? selectedTeamType;

  final List<String> teamTypes = ['band', 'dance', 'vocal', 'team'];

  bool get _isTeamNameValid {
    final text = teamNameController.text.trim();
    return text.isNotEmpty && text.length <= 10;
  }

  String? get _teamNameErrorText {
    if (teamNameController.text.isEmpty) return null;
    if (!_isTeamNameValid) return '팀 이름은 한 글자 이상 10글자 이하로 작성해주세요.';
    return null;
  }

  bool get _canSubmit {
    return _isTeamNameValid &&
        teamDescriptionController.text.isNotEmpty &&
        selectedTeamType != null;
  }

  @override
  void dispose() {
    teamNameController.dispose();
    teamDescriptionController.dispose();
    teamDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

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

                      _RequiredLabel(
                        text: '팀 유형 선택',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      Wrap(
                        spacing: AppSpacing.x12,
                        runSpacing: AppSpacing.x8,
                        children: teamTypes.map((type) {
                          final isSelected = selectedTeamType == type;
                          return AppToggle(
                            text: type,
                            isSelected: isSelected,
                            onChanged: (bool selected) {
                              setState(() {
                                selectedTeamType = selected ? type : null;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      _RequiredLabel(
                        text: '사진 등록',
                        color: colors.onSurface,
                        requiredColor: colors.primary,
                      ),

                      const SizedBox(height: AppSpacing.x8),
                      AppUploadButton(
                        text: '팀 사진 등록하기',
                        onPressed: () {
                        },
                      ),

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
                      const SizedBox(height: AppSpacing.x24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x16),

              AppButton(
                text: '팀 생성하기',
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
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
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