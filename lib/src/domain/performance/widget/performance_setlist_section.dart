import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final surface = AppColor.black;
    final onSurface = AppColor.white;

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '공연 셋리스트',
              style: FontStyles.bold22.copyWith(color: AppColor.white),
            ),
            const SizedBox(height: AppSpacing.x10),
            if (teams.isEmpty)
              Text(
                '등록된 셋리스트 없음',
                style: FontStyles.reg14.copyWith(color: AppColor.gray4),
              )
            else
              SizedBox(
                height: 32,
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (
                            var index = 0;
                            index < teams.length;
                            index++
                          ) ...[
                            if (index != 0)
                              const SizedBox(width: AppSpacing.x8),
                            _TeamChip(
                              teamName: teams[index].teamName.trim().isNotEmpty
                                  ? teams[index].teamName
                                  : '${index + 1}팀',
                              selected: index == selectedIndex,
                              onPressed: () => onTeamSelected(index),
                            ),
                          ],
                        ],
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
}

/// 팀이 적을 때는 중앙 정렬, 많을 때는 가로 스크롤로 전체 팀을 탐색한다.
class _TeamChip extends StatelessWidget {
  const _TeamChip({
    required this.teamName,
    required this.selected,
    required this.onPressed,
  });

  final String teamName;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColor.beatOrange1 : AppColor.black;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minWidth: 54),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
            decoration: BoxDecoration(
              color: selected ? context.colors.primary : AppColor.white,
              border: selected ? null : Border.all(color: AppColor.gray4),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              teamName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontStyles.semi15.copyWith(
                color: selected ? AppColor.white : AppColor.gray1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 곡이 11개 이상일 때만 노출되는 중앙 정렬 더보기/접기 버튼.
class PerformanceSetlistExpandButton extends StatelessWidget {
  const PerformanceSetlistExpandButton({
    super.key,
    required this.expanded,
    required this.onPressed,
  });

  final bool expanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.x12,
          bottom: AppSpacing.x16,
        ),
        child: Material(
          color: AppColor.black,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x14,
                vertical: AppSpacing.x8,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.gray5),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    expanded ? '접기' : '더보기',
                    style: FontStyles.med12.copyWith(color: AppColor.white),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColor.white,
                  ),
                ],
              ),
            ),
          ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$number',
                style: FontStyles.med14.copyWith(color: AppColor.white),
              ),
              SizedBox(width: AppSpacing.x12),
              _SetlistAlbumCover(imageUrl: song.musicImageUrl),
              const SizedBox(width: AppSpacing.x12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.musicTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.med18.copyWith(color: AppColor.white),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      song.musicArtist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles.med14.copyWith(color: AppColor.gray5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (song.description.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x8),
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Text(
                song.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: FontStyles.med14.copyWith(
                  color: AppColor.gray5,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 서버에 저장된 음원 커버 URL을 표시한다.
/// 커버 정보가 없거나 네트워크 로딩에 실패했을 때만 음표로 대체한다.
class _SetlistAlbumCover extends StatelessWidget {
  const _SetlistAlbumCover({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final value = imageUrl?.trim();
    final uri = value == null ? null : Uri.tryParse(value);
    final validUrl =
        uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        width: 60,
        height: 60,
        child: validUrl
            ? Image.network(
                value!,
                fit: BoxFit.cover,
                cacheWidth: 180,
                errorBuilder: (context, error, stackTrace) =>
                    const _SetlistAlbumFallback(),
              )
            : const _SetlistAlbumFallback(),
      ),
    );
  }
}

class _SetlistAlbumFallback extends StatelessWidget {
  const _SetlistAlbumFallback();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColor.gray1,
    child: Center(
      child: Opacity(
        opacity: 0.4,
        child: SvgPicture.asset(
          'assets/icons/performance/performance.svg',
          width: 15,
        ),
      ),
    ),
  );
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
          style: FontStyles.reg14.copyWith(color: AppColor.gray4),
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
