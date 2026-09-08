import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_list_page.dart';
import 'package:beatit_front_app/src/domain/team/view/team_archive_update_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/widgets/popups/app_popup.dart';

class TeamArchiveDetailPage extends StatefulWidget {
  const TeamArchiveDetailPage({super.key});

  @override
  State<TeamArchiveDetailPage> createState() => _TeamArchiveDetailPageState();
}

class _TeamArchiveDetailPageState extends State<TeamArchiveDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isMapVisible = true;

  // 사용자가 입력한 내 별점 상태 (정수 단위, 예: 4)
  int? _myRating;

  void _toggleMapVisibility() {
    setState(() {
      _isMapVisible = !_isMapVisible;
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // 별점 남기기 팝업 함수
  void _showRatingDialog(BuildContext context) {
    int tempRating = _myRating ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.fromLTRB(14, 50, 14, 18),
              content: SizedBox(
                width: 280,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '그라운드합주실 본점 A3',
                      style: FontStyles.bold22.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '별점을 남기시겠습니까?',
                      style: FontStyles.reg22.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final isFilled = starIndex <= tempRating;

                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              tempRating = starIndex;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: SvgPicture.asset(
                              isFilled
                                  ? 'assets/icons/team/filled_star.svg'
                                  : 'assets/icons/team/star.svg',
                              width: 30,
                              height: 30,
                              colorFilter: ColorFilter.mode(
                                isFilled
                                    ? Theme.of(context).colorScheme.primary
                                    : context.grays.gray7,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '별점을 선택하세요',
                      style: FontStyles.semi16.copyWith(
                        color: context.grays.gray4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: context.grays.gray8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              '취소',
                              style: FontStyles.semi16.copyWith(
                                color: context.grays.gray4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              setState(() {
                                _myRating = tempRating > 0 ? tempRating : null;
                              });
                              Navigator.pop(context);
                              debugPrint('저장된 내 별점: $_myRating');
                            },
                            child: Text(
                              '확인',
                              style: FontStyles.semi16.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // 화면 너비에서 좌우 패딩(AppSpacing.x20 * 2 = 40)을 뺀 실제 컨텐츠 영역 너비 계산
    final double contentWidth =
        MediaQuery.of(context).size.width - (AppSpacing.x20 * 2);

    return Scaffold(
      appBar: AppTopAppBar.backMore(
        onMorePressed: () {},
        moreMenuOffset: const Offset(-20, 56),
        moreMenuItems: [
          AppDropdownItem(
            label: '수정하기',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeamArchiveUpdatePage(),
                ),
              );
            },
          ),
          AppDropdownItem(
            label: '삭제하기',
            onPressed: () async {
              final confirmed = await AppPopup.show(
                context,
                title: '정말 삭제하시겠습니까?',
                content: '삭제된 게시물은\n복구할 수 없습니다.',
                warningType: WarningType.triangle,
                contentType: ContentType.small,
                buttonNum: ButtonNum.two,
                buttonSymmetric: ButtonSymmetric.horizontal,
                confirmText: '확인',
                cancelText: '취소',
              );

              if (!mounted) return;

              if (confirmed == true) {
                debugPrint('삭제 기능이 실행되었습니다.');

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeamArchiveListPage(),
                  ),
                  (route) => route.isFirst,
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. 연습실 제목
                      Text(
                        '그라운드합주실 본점 A3',
                        style: FontStyles.bold34.copyWith(
                          color: colors.onSurface,
                          letterSpacing: -0.68,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),

                      // 2. 작성일 / 최종수정일
                      Row(
                        children: [
                          Text(
                            '2026.04.02 15:47',
                            style: FontStyles.reg14.copyWith(
                              color: context.grays.gray4,
                            ),
                          ),
                          Text(
                            ' ｜ 최종수정일 2026.04.03 15:00',
                            style: FontStyles.reg14.copyWith(
                              color: context.grays.gray5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x10),

                      // 3. 평점 & 뱃지
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.grays.gray8,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/team/filled_star.svg',
                                  width: 16,
                                  height: 16,
                                  colorFilter: ColorFilter.mode(
                                    colors.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '4.0',
                                  style: FontStyles.med12.copyWith(
                                    color: colors.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '(19)',
                                  style: FontStyles.med12.copyWith(
                                    color: context.grays.gray5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.brands.beatOrange5,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '밴드가 찾는 1순위',
                              style: FontStyles.med12.copyWith(
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x16),

                      // 4. 소개글
                      Text(
                        '홍대에 위치해서 합주하러 만나기 가장 편한 장소!\n악기 대여 잘 되고, 연습실도 깨끗해요. 관리자님도 친절함.\n항상 소모임에서 1순위로 선정되는 합주실이에요.',
                        style: FontStyles.reg14.copyWith(
                          color: context.grays.black,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x20),

                      // 5. 위치 정보 및 지도보기 토글
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.grays.gray8,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/cal/location.svg',
                                  width: 16,
                                  height: 16,
                                  colorFilter: ColorFilter.mode(
                                    context.grays.gray1,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '위치',
                                  style: FontStyles.semi12.copyWith(
                                    color: colors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '서울 마포구 양화로 147 지하 2층',
                              style: FontStyles.med16.copyWith(
                                color: colors.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: _toggleMapVisibility,
                            child: Row(
                              children: [
                                Text(
                                  '지도보기',
                                  style: FontStyles.med16.copyWith(
                                    color: context.brands.beatOrange2,
                                    decoration: TextDecoration.underline,
                                    decorationColor: context.brands.beatOrange2,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                RotatedBox(
                                  quarterTurns: _isMapVisible ? 2 : 0,
                                  child: SvgPicture.asset(
                                    'assets/icons/cal/toggle_down.svg',
                                    colorFilter: ColorFilter.mode(
                                      context.brands.beatOrange2,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x12),

                      // 6. 지도 영역 (토글형)
                      if (_isMapVisible) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/team/map_example.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x20),
                      ],

                      // 7. 연습실 대표 사진 리스트 (기존과 동일한 크기/높이 190 유지, 최대 5개 가로 스크롤)
                      SizedBox(
                        height: 190,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5, // 최대 5개
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            return Container(
                              // 기존 2열 배치의 한쪽 박스 크기와 동일하게 화면 너비 기반으로 설정
                              width: (contentWidth - 8) / 2,
                              decoration: BoxDecoration(
                                color: context.grays.gray8,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x20),

                      const Divider(height: 1),
                      const SizedBox(height: AppSpacing.x14),

                      // 8. 내 별점 또는 별점 남기기 & 댓글 개수
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showRatingDialog(context);
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  _myRating != null
                                      ? 'assets/icons/team/filled_star.svg'
                                      : 'assets/icons/team/star.svg',
                                  width: 18,
                                  height: 18,
                                  colorFilter: ColorFilter.mode(
                                    _myRating != null
                                        ? colors.primary
                                        : context.grays.gray4,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _myRating != null
                                      ? '내 별점 ${_myRating!.toStringAsFixed(1)}'
                                      : '별점 남기기',
                                  style: FontStyles.med14.copyWith(
                                    color: _myRating != null
                                        ? colors.primary
                                        : context.grays.gray4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/team/reply.svg',
                                width: 18,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                  context.grays.gray4,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '댓글 2',
                                style: FontStyles.med14.copyWith(
                                  color: context.grays.gray4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 9. 하단 댓글 입력창
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x16,
                vertical: AppSpacing.x12,
              ),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(color: context.grays.gray8, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: context.grays.gray8,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: '댓글을 입력해주세요.',
                            hintStyle: FontStyles.reg14.copyWith(
                              color: context.grays.gray5,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // TODO: 댓글 등록 로직
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.grays.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 20,
                        ),
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
  }
}
