import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_upload_button.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_field.dart';
import 'package:beatit_front_app/src/core/widgets/inputs/app_text_area.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/domain/team/view/team_detail_page.dart'; // 💡 TeamDetailPage 임포트 추가

class TeamArchivePage extends StatefulWidget {
  const TeamArchivePage({super.key});

  @override
  State<TeamArchivePage> createState() => _TeamArchivePageState();
}

class _TeamArchivePageState extends State<TeamArchivePage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool get _canSubmit {
    return _nameController.text.trim().isNotEmpty &&
        _locationController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;
  }

  void _navigateToTeamDetail() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TeamDetailPage()),
      (route) => route.isFirst,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      // 💡 X 버튼 클릭 -> 작성 중단 팝업 -> '확인' 클릭 시 TeamDetailPage로 이동
      appBar: AppTopAppBar.closeOnly(
        onClosePressed: () async {
          final confirmed = await AppPopup.show(
            context,
            title: '작성을 중단하시겠습니까?',
            content: '중단 시, 작성된 내용은\n저장되지 않습니다.',
            warningType: WarningType.circle,
            contentType: ContentType.small,
            buttonNum: ButtonNum.two,
            buttonSymmetric: ButtonSymmetric.horizontal,
            confirmText: '확인',
            cancelText: '취소',
          );

          if (!context.mounted) return;

          if (confirmed == true) {
            _navigateToTeamDetail();
          }
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
                      // 1. 합주실/연습실 이름 (필수)
                      AppTextField(
                        label: '합주실/연습실 이름',
                        requiredMark: true,
                        hintText: '합주실/연습실 이름',
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      // 2. 장소 (필수)
                      AppTextField(
                        label: '장소',
                        requiredMark: true,
                        hintText: '모임 장소를 검색하세요.',
                        controller: _locationController,
                        onChanged: (_) => setState(() {}),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            'assets/icons/cal/search.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              context.grays.gray5,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      // 3. 일정 설명 (필수, 500자 제한)
                      AppTextArea(
                        label: '일정 설명',
                        requiredMark: true,
                        hintText: '모임에 어울리는 일정 설명을 작성해주세요.',
                        controller: _descriptionController,
                        maxLength: 500,
                        fieldHeight: 220,
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: AppSpacing.x20),

                      // 4. 사진 등록
                      Text(
                        '사진 등록',
                        style: FontStyles.med14.copyWith(
                          color: colors.onSurface,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.x4),

                      AppUploadButton(
                        text: '연습실/합주실 사진 등록하기',
                        onPressed: () {},
                      ),

                      const SizedBox(height: AppSpacing.x24),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x24),

              // 5. 등록하기 버튼 (클릭 시 TeamDetailPage로 이동)
              AppButton(
                text: '등록하기',
                width: ButtonWidth.expand,
                height: ButtonHeight.normal,
                variant: _canSubmit
                    ? ButtonVariant.black
                    : ButtonVariant.primary,
                onPressed: _canSubmit ? _navigateToTeamDetail : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
