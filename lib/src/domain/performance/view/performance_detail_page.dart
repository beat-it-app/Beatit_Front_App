// lib/src/domain/performance/view/performance_detail_page.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/network/dio_provider.dart';
import 'package:beatit_front_app/src/core/theme/app_colors.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/dropdowns/app_dropdown_list.dart';
import 'package:beatit_front_app/src/core/widgets/popups/app_popup.dart';
import 'package:beatit_front_app/src/core/widgets/tabs/app_tab_bar.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_detail_response_model.dart';
import 'package:beatit_front_app/src/domain/performance/provider/performance_detail_provider.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_information_page.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_detail_sections.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_hero.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_host_dialog.dart';
import 'package:beatit_front_app/src/domain/team/provider/team_upcoming_provider.dart';

class PerformanceDetailPage extends ConsumerStatefulWidget {
  const PerformanceDetailPage({
    super.key,
    required this.performancePublicId,
    this.initialPerformance,
    this.fromMyPage = false, // 💡 나의 공연 목록에서 들어올 때만 true 전달
    this.onEdit,
    this.onDelete,
    this.onViewResponses,
  });

  final String performancePublicId;
  final PerformanceDetailData? initialPerformance;
  final bool fromMyPage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewResponses;

  @override
  ConsumerState<PerformanceDetailPage> createState() =>
      _PerformanceDetailPageState();
}

class _PerformanceDetailPageState extends ConsumerState<PerformanceDetailPage> {
  int _selectedTab = 0;
  bool _isDeleting = false;

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
      return;
    }

    setState(() => _isDeleting = true);

    try {
      final dio = ref.read(dioProvider);
      await dio.delete('/performances/${widget.performancePublicId}');

      ref.invalidate(teamUpcomingPerformancesProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('공연이 삭제되었습니다.')));

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      String errorMessage = '공연 삭제에 실패했습니다.';
      if (e is DioException && e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          errorMessage =
              data['message']?.toString() ??
              data['error']?.toString() ??
              errorMessage;
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  void _unavailable(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  void _openHostDialog(PerformanceDetailData performance) {
    if (performance.hostContact.trim().isEmpty &&
        performance.hostName.trim().isEmpty) {
      _unavailable('등록된 호스트 연락처 정보가 없습니다.');
      return;
    }

    showPerformanceHostDialog(
      context: context,
      hostName: performance.hostName.isNotEmpty ? performance.hostName : '호스트',
      contactType:
          performance.hostContactType ?? PerformanceHostContactType.phone,
      contact: performance.hostContact.isNotEmpty
          ? performance.hostContact
          : '연락처 정보 없음',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleting) {
      return Scaffold(
        backgroundColor: context.grays.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final detailAsync = ref.watch(
      performanceDetailProvider(widget.performancePublicId),
    );

    return detailAsync.when(
      loading: () => Scaffold(
        backgroundColor: context.grays.white,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: context.grays.white,
        appBar: AppTopAppBar.backOnly(
          onBackPressed: () => Navigator.of(context).maybePop(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '공연 정보를 불러오지 못했습니다.',
                style: FontStyles.med16.copyWith(color: context.colors.error),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.refresh(
                  performanceDetailProvider(widget.performancePublicId),
                ),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
      data: (serverModel) {
        final performance = serverModel.toDetailData();

        // 💡 백엔드 isMine 필드 없이 오직 '나의 공연 목록' 진입 여부로만 제어
        final bool canEditOrDelete = widget.fromMyPage;

        return Scaffold(
          backgroundColor: context.grays.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    PerformanceHero(
                      performance: performance,
                      isMine: canEditOrDelete,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/appbar/back.svg',
                                  width: 20,
                                  height: 20,
                                  colorFilter: const ColorFilter.mode(
                                    AppColor.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 나의 공연 목록을 통해 들어온 것이 아닐 때: 공유(문의) 버튼만 노출
                                  if (!canEditOrDelete)
                                    IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/icons/team/share.svg',
                                        width: 22,
                                        height: 22,
                                        colorFilter: const ColorFilter.mode(
                                          AppColor.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      onPressed: () =>
                                          _openHostDialog(performance),
                                    ),

                                  // 나의 공연 목록을 통해 들어왔을 때만: 수정/삭제 드롭다운 메뉴 노출
                                  if (canEditOrDelete)
                                    AppDropdownList(
                                      items: [
                                        AppDropdownItem(
                                          label: '수정하기',
                                          onPressed: () {
                                            if (widget.onEdit != null) {
                                              widget.onEdit!();
                                              return;
                                            }
                                            Navigator.of(context)
                                                .push(
                                                  MaterialPageRoute<void>(
                                                    builder: (_) =>
                                                        PerformanceInformationPage(
                                                          editTarget:
                                                              serverModel,
                                                        ),
                                                  ),
                                                )
                                                .then((_) {
                                                  ref.refresh(
                                                    performanceDetailProvider(
                                                      widget
                                                          .performancePublicId,
                                                    ),
                                                  );
                                                });
                                          },
                                        ),
                                        AppDropdownItem(
                                          label: '삭제하기',
                                          onPressed: _confirmDelete,
                                        ),
                                      ],
                                      width: 170.0,
                                      anchorWidth: 48.0,
                                      itemHeight: 44.0,
                                      alignment: AppDropdownAlignment.right,
                                      alignmentOffset: const Offset(-16, 44),
                                      triggerBuilder: (context, controller) {
                                        return IconButton(
                                          icon: SvgPicture.asset(
                                            'assets/icons/appbar/menu.svg',
                                            width: 20,
                                            height: 20,
                                            colorFilter: const ColorFilter.mode(
                                              AppColor.white,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          onPressed: () {
                                            if (controller.isOpen) {
                                              controller.close();
                                            } else {
                                              controller.open();
                                            }
                                          },
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // 나의 공연 목록에서 들어왔을 때만 D-Day 밴드 노출
                if (canEditOrDelete)
                  _BookingDeadlineBand(performance: performance),
                AppTabBar(
                  labels: const ['공연 정보', '상세 정보'],
                  selectedIndex: _selectedTab,
                  onChanged: (value) => setState(() => _selectedTab = value),
                ),
                if (_selectedTab == 0)
                  PerformanceInfoSection(
                    performance: performance,
                    isMine: false,
                  )
                else
                  PerformanceDetailSection(performance: performance),
                if (canEditOrDelete) const SizedBox(height: 80),
              ],
            ),
          ),
          // 나의 공연 목록에서 들어왔을 때만 하단 초대장 보기 고정 버튼 노출
          bottomNavigationBar: canEditOrDelete
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x20,
                      vertical: AppSpacing.x12,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            widget.onViewResponses ??
                            () => _unavailable('초대장 보기 기능 준비 중입니다.'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: context.grays.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          '초대장 보기',
                          style: FontStyles.med16.copyWith(
                            color: context.grays.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _BookingDeadlineBand extends StatelessWidget {
  const _BookingDeadlineBand({required this.performance});

  final PerformanceDetailData performance;

  @override
  Widget build(BuildContext context) {
    final remaining = DateUtils.dateOnly(
      performance.startsAt,
    ).difference(DateUtils.dateOnly(DateTime.now())).inDays;

    final dayLabel = remaining == 0
        ? 'D-Day'
        : remaining > 0
        ? 'D-$remaining'
        : 'D+${-remaining}';

    final deadline = performance.bookingClosesAt;
    final dateText = deadline == null
        ? '공연일 ${_formatDate(performance.startsAt)}'
        : '공연 예매 마감일 ${_formatDate(deadline)}';

    return Container(
      color: AppColor.black,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x20,
        vertical: AppSpacing.x16,
      ),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.beatOrange2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Text(
                dayLabel,
                style: FontStyles.reg14.copyWith(color: AppColor.beatOrange2),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x10),
          Expanded(
            child: Text(
              dateText,
              maxLines: 2,
              style: FontStyles.med15.copyWith(color: AppColor.beatOrange2),
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
