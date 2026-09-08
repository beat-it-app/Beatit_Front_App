import 'package:beatit_front_app/src/domain/team/view/team_archive_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import '../../../core/widgets/navigation/app_navigation_bar.dart';

// 💡 TeamArchiveDetailPage 임포트 추가 (파일 경로에 맞춰 수정해 주세요)
// import 'team_archive_detail_page.dart';

class TeamArchiveListPage extends StatefulWidget {
  const TeamArchiveListPage({super.key});

  @override
  State<TeamArchiveListPage> createState() => _TeamArchiveListPageState();
}

class _TeamArchiveListPageState extends State<TeamArchiveListPage> {
  final TextEditingController _searchController = TextEditingController();
  int _currentBottomNavIndex = 0; // 하단 네비게이션 현재 인덱스

  // 임시 데이터 리스트
  final List<Map<String, dynamic>> _archiveList = [
    {
      'title': '그라운드합주실 본점 A3',
      'location': '서울특별시 마포구 양화로 147 지하 2층',
      'rating': 4.0,
      'comments': 55,
    },
    {
      'title': '그라운드합주실 본점 A3',
      'location': '서울특별시 마포구 양화로 147 지하 2층',
      'rating': 3.2,
      'comments': 55,
    },
    {
      'title': '그라운드합주실 본점 A3',
      'location': '서울특별시 마포구 양화로 147 지하 2층',
      'rating': 5.0,
      'comments': 55,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () {
          Navigator.pop(context);
        },
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
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
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

              // 2. 정렬 필터 버튼 (별점순 등)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.grays.gray4),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '별점순',
                          style: FontStyles.reg14.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.x16),

              // 3. 리스트 영역
              Expanded(
                child: ListView.separated(
                  itemCount: _archiveList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.x16),
                  itemBuilder: (context, index) {
                    final item = _archiveList[index];
                    return GestureDetector(
                      // 💡 리스트 아이템 클릭 시 상세 페이지(TeamArchiveDetailPage)로 이동
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
                            // 왼쪽 회색 이미지 박스
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: context.grays.gray8,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 오른쪽 정보 영역
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item['title'],
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
                                          item['location'],
                                          style: FontStyles.med16.copyWith(
                                            color: context.grays.gray5,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // 별점 및 댓글 정보 박스
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
                                            '${item['rating'].toStringAsFixed(1)}',
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
                                            '${item['comments']}',
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
            ],
          ),
        ),
      ),
      // 4. 하단 네비게이션 바 결합
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          // TODO: 탭 이동 로직 작성
        },
      ),
    );
  }
}
