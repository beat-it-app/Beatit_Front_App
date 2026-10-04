import 'package:beatit_front_app/src/domain/team/view/team_archive_page.dart';
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

class TeamArchiveListPage extends ConsumerStatefulWidget {
  const TeamArchiveListPage({super.key});

  @override
  ConsumerState<TeamArchiveListPage> createState() =>
      _TeamArchiveListPageState();
}

class _TeamArchiveListPageState extends ConsumerState<TeamArchiveListPage> {
  int _currentBottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(teamArchiveProvider.notifier).fetchArchives();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final state = ref.watch(teamArchiveProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // 💡 보내주신 AppTopAppBar.backMore 사용 규칙 그대로 적용
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
          child: state.isLoading && state.items.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '기록된 장소가 없습니다.',
                        style: FontStyles.bold22.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '+ 버튼을 눌러 장소를 추가해보세요.',
                        style: FontStyles.med16.copyWith(
                          color: context.grays.gray5,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.x16,
                    bottom: AppSpacing.x16,
                  ),
                  itemCount: state.items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.x16),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeamArchiveDetailPage(),
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
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: context.grays.gray8,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
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
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.title,
                                    style: FontStyles.med20.copyWith(
                                      color: colors.onSurface,
                                    ),
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
                                          item.placeName ?? '장소 정보 없음',
                                          style: FontStyles.med16.copyWith(
                                            color: context.grays.gray5,
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
                                        borderRadius: BorderRadius.circular(5),
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
                                            '${item.likeCount}',
                                            style: FontStyles.med12.copyWith(
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
                                            style: FontStyles.med12.copyWith(
                                              color: context.grays.gray2,
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
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
      ),
    );
  }
}
