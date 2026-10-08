import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';

import '../../team/model/my_team_model.dart';
import '../../team/provider/team_select_provider.dart';
import '../provider/mypage_provider.dart';
import '../view/mypage/team_add_option_page.dart';

class TeamSwitchBottomSheet extends ConsumerStatefulWidget {
  const TeamSwitchBottomSheet({super.key, this.currentTeamPublicId});

  final String? currentTeamPublicId;

  static Future<void> show(
    BuildContext context, {
    String? currentTeamPublicId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          TeamSwitchBottomSheet(currentTeamPublicId: currentTeamPublicId),
    );
  }

  @override
  ConsumerState<TeamSwitchBottomSheet> createState() =>
      _TeamSwitchBottomSheetState();
}

class _TeamSwitchBottomSheetState extends ConsumerState<TeamSwitchBottomSheet> {
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamSelectProvider.notifier).fetchMyTeams();
    });
  }

  Future<void> _handleTeamSelected(MyTeamModel team) async {
    if (_isSelecting) return;

    setState(() {
      _isSelecting = true;
    });

    final success = await ref
        .read(teamSelectProvider.notifier)
        .selectTeam(team.teamPublicId);

    if (!mounted) return;

    if (success) {
      // 서버에서 현재 팀이 변경되었으므로 MyPage 정보도 다시 조회
      await ref.read(myPageProvider.notifier).fetchMyPage();

      if (!mounted) return;

      setState(() {
        _isSelecting = false;
      });

      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSelecting = false;
    });

    final errorMessage = ref.read(teamSelectProvider).errorMessage;

    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void _openTeamAddOptionPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const TeamAddOptionPage()));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(teamSelectProvider);
    final List<MyTeamModel> teams = state.teams;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x20,
        vertical: AppSpacing.x16,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                Text(
                  '팀 전환하기',
                  style: FontStyles.bold20.copyWith(color: colors.onSurface),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.close, color: colors.onSurface, size: 24),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.x20),

            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.x40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (teams.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x40),
                child: Text(
                  '참여 중인 팀이 없습니다.',
                  style: FontStyles.med14.copyWith(color: context.grays.gray5),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.55,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: teams.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.x12),
                  itemBuilder: (context, index) {
                    final team = teams[index];

                    return _buildTeamCard(context, team);
                  },
                ),
              ),

            const SizedBox(height: AppSpacing.x16),

            GestureDetector(
              onTap: _openTeamAddOptionPage,
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.grays.gray8,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/plus/plus.svg',
                      width: 14,
                      height: 14,
                      colorFilter: ColorFilter.mode(
                        context.grays.gray6,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(BuildContext context, MyTeamModel team) {
    final rawDate = team.createdAt;

    final formattedDate = rawDate.length >= 10
        ? rawDate.substring(0, 10).replaceAll('-', '.')
        : rawDate;

    final String? imageUrl = team.teamImageUrl;

    final bool hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;

    final bool isCurrent = widget.currentTeamPublicId == team.teamPublicId;

    if (!hasImage) {
      return GestureDetector(
        onTap: _isSelecting ? null : () => _handleTeamSelected(team),
        child: Container(
          height: 158,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          padding: const EdgeInsets.all(AppSpacing.x20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.teamType,
                    style: FontStyles.med14.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    team.teamName,
                    style: FontStyles.bold28.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    '$formattedDate 개설',
                    style: FontStyles.med14.copyWith(color: Colors.white70),
                  ),
                ],
              ),

              if (!isCurrent)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/auth/back.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _isSelecting ? null : () => _handleTeamSelected(team),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          height: 158,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: const Color(0xFF1C1C1E));
                  },
                ),
              ),

              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.45)),
              ),

              Padding(
                padding: const EdgeInsets.all(AppSpacing.x20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.teamType,
                      style: FontStyles.med14.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      team.teamName,
                      style: FontStyles.bold28.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      '$formattedDate 개설',
                      style: FontStyles.med14.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              if (!isCurrent)
                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/auth/back.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
