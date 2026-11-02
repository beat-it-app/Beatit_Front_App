import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/navigation/app_navigation_bar.dart';
import 'package:beatit_front_app/src/domain/team/model/team_archive_model.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_archive_provider.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_detail_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_page.dart';

class TeamArchiveListPage extends ConsumerStatefulWidget {
  const TeamArchiveListPage({super.key});

  @override
  ConsumerState<TeamArchiveListPage> createState() =>
      _TeamArchiveListPageState();
}

class _TeamArchiveListPageState extends ConsumerState<TeamArchiveListPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  bool _isRatingSort = false; // 💡 별점순 정렬 활성화 여부
  int _currentBottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamArchiveProvider.notifier).fetchArchives();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = query.trim().toLowerCase();
        });
        ref
            .read(teamArchiveProvider.notifier)
            .fetchArchives(keyword: query.trim());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final state = ref.watch(teamArchiveProvider);

    // 1. 검색어 필터링
    List<TeamArchiveItemModel> displayItems = state.items.where((item) {
      if (_searchQuery.isEmpty) return true;
      final title = item.title.toLowerCase();
      final address = (item.roadAddress ?? '').toLowerCase();
      return title.contains(_searchQuery) || address.contains(_searchQuery);
    }).toList();

    // 2. 💡 별점순 정렬 적용 (높은 순서대로 정렬)
    if (_isRatingSort) {
      displayItems.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppTopAppBar.backMore(
        title: '',
        onBackPressed: () => Navigator.pop(context),
        onMorePressed: () {},
        moreMenuOffset: const Offset(-20, 56),
        moreMenuItems: [
          AppDropdownItem(
            label: '기록하기',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeamArchivePage(),
                ),
              );

              if (mounted) {
                ref.read(teamArchiveProvider.notifier).fetchArchives();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.x8),

              // 1. 검색창 영역
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: context.grays.gray8,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        style: FontStyles.reg18.copyWith(
                          color: colors.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: '검색어를 입력하세요.',
                          hintStyle: FontStyles.reg18.copyWith(
                            color: context.grays.gray5,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/icons/cal/search.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        context.grays.gray5,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.x10),

              // 2. 💡 '별점순' 정렬 버튼 (우측 정렬)
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isRatingSort = !_isRatingSort;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _isRatingSort
                          ? colors.primary.withOpacity(0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: _isRatingSort
                            ? colors.primary
                            : context.grays.gray4,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '별점순',
                      style: FontStyles.reg14.copyWith(
                        color: _isRatingSort
                            ? colors.primary
                            : context.grays.gray1,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.x12),

              // 3. 리스트 영역
              Expanded(
                child: state.isLoading && state.items.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : displayItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.items.isEmpty
                                  ? '기록된 장소가 없습니다.'
                                  : '검색된 장소가 없습니다.',
                              style: FontStyles.bold22.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              state.items.isEmpty
                                  ? '+ 버튼을 눌러 장소를 추가해보세요.'
                                  : '다른 검색어로 다시 검색해보세요.',
                              style: FontStyles.med16.copyWith(
                                color: context.grays.gray5,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: AppSpacing.x16),
                        itemCount: displayItems.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.x16),
                        itemBuilder: (context, index) {
                          final item = displayItems[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamArchiveDetailPage(
                                    archiveId: item.archiveId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 썸네일 이미지
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      color: context.grays.gray8,
                                      child:
                                          item.archiveImageUrl != null &&
                                              item.archiveImageUrl!
                                                  .trim()
                                                  .isNotEmpty
                                          ? Image.network(
                                              item.archiveImageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Center(
                                                child: SvgPicture.asset(
                                                  'assets/icons/team/archive.svg',
                                                  width: 28,
                                                  height: 28,
                                                  colorFilter: ColorFilter.mode(
                                                    context.grays.gray5,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: SvgPicture.asset(
                                                'assets/icons/team/archive.svg',
                                                width: 28,
                                                height: 28,
                                                colorFilter: ColorFilter.mode(
                                                  context.grays.gray5,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // 상세 정보
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item.title,
                                          style: FontStyles.med20.copyWith(
                                            color: colors.onSurface,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/cal/location.svg',
                                              width: 20,
                                              height: 20,
                                              colorFilter: ColorFilter.mode(
                                                context.grays.gray4,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                item.roadAddress ?? '장소 정보 없음',
                                                style: FontStyles.med16
                                                    .copyWith(
                                                      color:
                                                          context.grays.gray5,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: context.grays.gray8,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/team/filled_star.svg',
                                                  width: 14,
                                                  height: 14,
                                                  colorFilter: ColorFilter.mode(
                                                    colors.primary,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  item.averageRating
                                                      .toStringAsFixed(1),
                                                  style: FontStyles.med12
                                                      .copyWith(
                                                        color: colors.onSurface,
                                                      ),
                                                ),
                                                const SizedBox(width: 8),
                                                SvgPicture.asset(
                                                  'assets/icons/team/reply.svg',
                                                  width: 16,
                                                  height: 16,
                                                  colorFilter: ColorFilter.mode(
                                                    context.grays.gray2,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${item.commentCount}',
                                                  style: FontStyles.med12
                                                      .copyWith(
                                                        color:
                                                            context.grays.gray2,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
