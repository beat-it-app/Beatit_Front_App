import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';
import 'package:flutter/material.dart';

/// SliverPersistentHeader 안에 넣을 제목과 팀 선택 영역. 배경은 불투명해야
/// 아래 곡 목록이 위로 통과하더라도 글자가 겹쳐 보이지 않는다.
class PerformanceSetlistHeader extends StatelessWidget {
  const PerformanceSetlistHeader({
    super.key,
    required this.teams,
    required this.selectedIndex,
    required this.onTeamSelected,
  });

  final List<PerformanceSetlistTeam> teams;
  final int selectedIndex;
  final ValueChanged<int> onTeamSelected;

  @override
  Widget build(BuildContext context) {
    final surface = context.colors.surface;
    final onSurface = context.colors.onSurface;

    return ColoredBox(
      color: surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x16,
          AppSpacing.x12,
          AppSpacing.x16,
          AppSpacing.x8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '공연 셋리스트',
              style: FontStyles.bold18.copyWith(color: onSurface),
            ),
            const SizedBox(height: AppSpacing.x10),
            if (teams.isEmpty)
              Text(
                '등록된 셋리스트 없음',
                style: FontStyles.reg12.copyWith(color: context.grays.gray4),
              )
            else
              SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: teams.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.x8),
                  itemBuilder: (context, index) {
                    final selected = index == selectedIndex;
                    return Semantics(
                      button: true,
                      selected: selected,
                      child: Material(
                        color: selected ? context.colors.primary : surface,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          onTap: () => onTeamSelected(index),
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 54),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.x12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selected
                                    ? context.colors.primary
                                    : context.grays.gray4,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                            child: Text(
                              teams[index].teamName.trim().isNotEmpty
                                  ? teams[index].teamName
                                  : '${index + 1}팀',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FontStyles.med12.copyWith(
                                color: selected
                                    ? context.colors.onPrimary
                                    : onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PerformanceSetlistSongItem extends StatelessWidget {
  const PerformanceSetlistSongItem({
    super.key,
    required this.number,
    required this.song,
  });

  final int number;
  final PerformanceSetlistSong song;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 19,
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.x12),
              child: Text(
                '$number',
                style: FontStyles.reg12.copyWith(
                  color: context.grays.gray4,
                ),
              ),
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: context.grays.gray1,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.music_note_rounded,
              size: 23,
              color: context.grays.gray5,
            ),
          ),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.musicTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.semi14.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  song.musicArtist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyles.reg12.copyWith(
                    color: context.grays.gray5,
                  ),
                ),
                if (song.description.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x8),
                  Text(
                    song.description,
                    style: FontStyles.reg12.copyWith(
                      color: context.grays.gray4,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PerformanceSetlistEmpty extends StatelessWidget {
  const PerformanceSetlistEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x50,
      ),
      child: Center(
        child: Text(
          '아직 공개된 공연 곡 목록이 없습니다.',
          style: FontStyles.reg14.copyWith(color: context.grays.gray4),
        ),
      ),
    );
  }
}

class PerformanceSetlistHeaderDelegate extends SliverPersistentHeaderDelegate {
  const PerformanceSetlistHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 99;

  @override
  double get maxExtent => 99;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  bool shouldRebuild(covariant PerformanceSetlistHeaderDelegate oldDelegate) =>
      true;
}
