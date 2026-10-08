import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/core/widgets/tabs/app_tab_bar.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_detail_sections.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_hero.dart';
import 'package:flutter/material.dart';

/// 공연 상세보기와 나의 공연 상세보기에 동일하게 사용한다.
/// 나의 공연 전용 액션은 isMine 일 때만 노출한다.
class PerformanceDetailPage extends StatefulWidget {
  const PerformanceDetailPage({
    super.key,
    required this.performance,
    this.isMine = false,
    this.onEdit,
    this.onDelete,
    this.onViewResponses,
  });

  final PerformanceDetailData performance;
  final bool isMine;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewResponses;

  @override
  State<PerformanceDetailPage> createState() => _PerformanceDetailPageState();
}

class _PerformanceDetailPageState extends State<PerformanceDetailPage> {
  int _selectedTab = 0;

  Future<void> _confirmDelete() async {
    final confirmed = await AppPopup.show(
      context,
      title: '공연을 삭제하시겠습니까?',
      content: '삭제된 공연은\n복구할 수 없습니다.',
      warningType: WarningType.triangle,
      contentType: ContentType.small,
      buttonNum: ButtonNum.two,
      buttonSymmetric: ButtonSymmetric.horizontal,
      confirmText: '확인',
      cancelText: '취소',
    );
    if (!mounted || confirmed != true) return;
    if (widget.onDelete != null) {
      widget.onDelete!();
    } else {
      _unavailable('공연 삭제 기능은 아직 연결되지 않았습니다.');
    }
  }

  void _unavailable(String message) => ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final performance = widget.performance;
    return Scaffold(
      backgroundColor: context.grays.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                PerformanceHero(performance: performance),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Theme(
                      // 헤더의 배경만 투명하게. 아이콘 색상은 optional parameter로
                      // 지정해서 드롭다운 글씨까지 흰색으로 바뀌지 않게 한다.
                      data: Theme.of(context).copyWith(
                        scaffoldBackgroundColor: Colors.transparent,
                      ),
                      child: widget.isMine
                          ? AppTopAppBar.backMore(
                              actionIconColor: AppColor.white,
                              onBackPressed: () => Navigator.of(context).maybePop(),
                              moreMenuOffset: const Offset(-16, 56),
                              moreMenuItems: [
                                AppDropdownItem(
                                  label: '수정하기',
                                  onPressed: widget.onEdit ?? () =>
                                      _unavailable('공연 수정 기능은 아직 연결되지 않았습니다.'),
                                ),
                                AppDropdownItem(
                                  label: '삭제하기',
                                  onPressed: _confirmDelete,
                                ),
                              ],
                            )
                          : AppTopAppBar.backOnly(
                              actionIconColor: AppColor.white,
                              onBackPressed: () => Navigator.of(context).maybePop(),
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (widget.isMine) _BookingDeadlineBand(performance: performance),
            AppTabBar(
              labels: const ['공연 정보', '상세 정보'],
              selectedIndex: _selectedTab,
              onChanged: (value) => setState(() => _selectedTab = value),
            ),
            if (_selectedTab == 0)
              PerformanceInfoSection(
                performance: performance,
                isMine: widget.isMine,
                onViewResponses: widget.onViewResponses,
              )
            else
              PerformanceDetailSection(performance: performance),
          ],
        ),
      ),
    );
  }
}

class _BookingDeadlineBand extends StatelessWidget {
  const _BookingDeadlineBand({required this.performance});

  final PerformanceDetailData performance;

  @override
  Widget build(BuildContext context) {
    final deadline = performance.bookingClosesAt;
    final remaining = DateUtils.dateOnly(deadline ?? performance.startsAt)
        .difference(DateUtils.dateOnly(DateTime.now())).inDays;
    final dayLabel = remaining == 0 ? 'D-Day'
        : remaining > 0 ? 'D-$remaining' : 'D+${-remaining}';
    final dateText = deadline == null
        ? '공연일 ${_formatDate(performance.startsAt)}'
        : '공연 예매 마감일 ${_formatDate(deadline)}';

    return Container(
      color: AppColor.black,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x12,
      ),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.beatOrange2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(dayLabel,
                style: FontStyles.med12.copyWith(color: AppColor.beatOrange2)),
            ),
          ),
          const SizedBox(width: AppSpacing.x10),
          Expanded(
            child: Text(dateText,
              maxLines: 2,
              style: FontStyles.med14.copyWith(color: AppColor.beatOrange2),
            ),
          ),
        ],
      ),
    );
  }

  static const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  String _formatDate(DateTime date) =>
    '${date.year}. ${date.month}. ${date.day}. '
    '(${_weekdays[date.weekday - 1]}) '
    '${date.hour.toString().padLeft(2, '0')}:'
    '${date.minute.toString().padLeft(2, '0')}';
}
