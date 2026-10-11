import 'dart:io';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/domain/team/view/team_select_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 💡 1. riverpod 임포트
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/widgets/buttons/app_button.dart';

// 💡 2. currentTeamProvider 임포트 경로 확인
import 'package:beatit_front_app/src/domain/team/provider/current_team_provider.dart';

// 💡 3. StatelessWidget -> ConsumerWidget으로 변경
class TeamCreateSuccessPage extends ConsumerWidget {
  const TeamCreateSuccessPage({
    super.key,
    required this.teamName,
    this.establishedOn,
    this.teamImageFile,
    this.teamImageUrl,
  });

  final String teamName;
  final String? establishedOn;
  final File? teamImageFile;
  final String? teamImageUrl;

  @override
  // 💡 4. WidgetRef ref 추가
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    String formattedDate;
    if (establishedOn != null && establishedOn!.trim().isNotEmpty) {
      formattedDate = establishedOn!.trim().replaceAll('-', '.');
    } else {
      final now = DateTime.now();
      formattedDate =
          '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      backgroundColor: AppColor.black,
      body: Stack(
        children: [
          // 1. 상단 배경 그래디언트
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/team/team_success_bg.png',
              fit: BoxFit.fitWidth,
            ),
          ),

          // 2. 본문 컨텐츠 (하단 SafeArea를 끄고 바닥까지 확장)
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: Column(
                children: [
                  // 상단 뒤로가기
                  SizedBox(
                    height: kToolbarHeight,
                    child: Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          icon: SvgPicture.asset(
                            'assets/icons/appbar/back.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              AppColor.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).maybePop();
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.x16),

                  // 아이콘 & 생성일
                  Center(
                    child: SvgPicture.asset(
                      'assets/icons/profile/profile1.svg',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x12),
                  Text(
                    '$formattedDate 생성된 팀',
                    style: FontStyles.med16.copyWith(
                      color: AppColor.beatOrange1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    teamName,
                    style: FontStyles.bold34.copyWith(color: AppColor.white),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // 비율 (aspectRatio: 1.35, horizontal: 10)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: AspectRatio(
                      aspectRatio: 1.35,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          child: _buildTeamImage(colors),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 70),

                  // 하단 축하 안내 텍스트
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '“$teamName”의 생성을 환영합니다.',
                          style: FontStyles.semi14.copyWith(
                            color: AppColor.beatOrange1,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x8),
                        Text(
                          '팀 생성이 완료되었어요!\n팀 페이지에서 멤버를 초대해보세요.',
                          style: FontStyles.semi20.copyWith(
                            color: AppColor.white,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // 하단 완료 버튼
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: bottomInset > 0
                          ? bottomInset + 4
                          : AppSpacing.x16,
                    ),
                    child: Theme(
                      data: theme.copyWith(
                        colorScheme: colors.copyWith(
                          primary: AppColor.beatOrange1,
                          onPrimary: AppColor.white,
                        ),
                      ),
                      child: AppButton(
                        text: '팀 개설 완료',
                        variant: ButtonVariant.primary,
                        width: ButtonWidth.expand,
                        height: ButtonHeight.normal,
                        onPressed: () {
                          // 💡 ConsumerWidget의 ref를 통해 currentTeamProvider를 확실하게 무효화!
                          ref.invalidate(currentTeamProvider);
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamImage(ColorScheme colors) {
    if (teamImageFile != null) {
      return Image.file(teamImageFile!, fit: BoxFit.cover);
    }

    if (teamImageUrl != null && teamImageUrl!.trim().isNotEmpty) {
      return Image.network(
        teamImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(colors),
      );
    }
    return _buildPlaceholder(colors);
  }

  Widget _buildPlaceholder(ColorScheme colors) {
    return Container(
      color: colors.surfaceContainerHighest,
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/profile/profile1.svg',
          width: 64,
          height: 64,
          colorFilter: ColorFilter.mode(
            colors.onSurfaceVariant.withValues(alpha: 0.4),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
