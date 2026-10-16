import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/core/widgets/toggles/app_toggle.dart';
import 'package:beatit_front_app/src/domain/etc/widget/search_input_widget.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_information_page.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_detail_page.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_item_widget.dart';
import 'package:flutter/material.dart';

enum _PerformanceFilter { all, upcoming, past }

class PerformanceMainPage extends StatefulWidget {
  const PerformanceMainPage({
    super.key,
    this.performances,
    this.onPerformanceTap,
    this.previewDraft,
    this.onSubmit,
  });

  /// API 연결 전에는 예시 카드가 보인다. API 연결 후에는 실제 목록을 전달한다.
  final List<PerformanceSummary>? performances;
  final ValueChanged<PerformanceSummary>? onPerformanceTap;
  /// 마이페이지 UI 테스트 시에만 더미 입력값을 전달한다.
  final PerformanceCreateData? previewDraft;
  final ValueChanged<PerformanceCreateData>? onSubmit;

  @override
  State<PerformanceMainPage> createState() => _PerformanceMainPageState();
}

class _PerformanceMainPageState extends State<PerformanceMainPage> {
  final _searchController = TextEditingController();
  _PerformanceFilter _filter = _PerformanceFilter.all;
  String _query = '';

  // 실제 공연이 아닌 UI 확인용 임시 항목이다.
  late final List<PerformanceSummary> _previewPerformances = [
    PerformanceSummary(
      title: '첫 번째 공연 예시',
      startsAt: DateTime.now().add(const Duration(days: 14)),
    ),
    PerformanceSummary(
      title: '두 번째 공연 예시',
      startsAt: DateTime.now().add(const Duration(days: 30)),
    ),
    PerformanceSummary(
      title: '지난 공연 예시',
      startsAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
    PerformanceSummary(
      title: '작은 공연 예시',
      startsAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  List<PerformanceSummary> get _filteredPerformances {
    final now = DateTime.now();
    final query = _query.trim().toLowerCase();
    return (widget.performances ?? _previewPerformances)
        .where((item) {
          final isPast = item.startsAt.isBefore(now);
          final matchesFilter = switch (_filter) {
            _PerformanceFilter.all => true,
            _PerformanceFilter.upcoming => !isPast,
            _PerformanceFilter.past => isPast,
          };
          return matchesFilter && item.title.toLowerCase().contains(query);
        })
        .toList(growable: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCreatePage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PerformanceInformationPage(
          initialDraft: widget.previewDraft,
          onSubmit: widget.onSubmit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredPerformances;
    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: SearchInputWidget(
                controller: _searchController,
                onSearchPressed: () => FocusScope.of(context).unfocus(),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            const SizedBox(height: AppSpacing.x10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                spacing: AppSpacing.x8,
                children: [
                  _filterToggle('전체 보기', _PerformanceFilter.all),
                  _filterToggle('진행 예정 공연', _PerformanceFilter.upcoming),
                  _filterToggle('지난 공연', _PerformanceFilter.past),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x16),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        '조건에 맞는 공연이 없습니다.',
                        style: FontStyles.med14.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    )
                  : PerformanceGrid(
                      performances: items,
                      onTap: (item) {
                        if (widget.onPerformanceTap != null) {
                          widget.onPerformanceTap!(item);
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => PerformanceDetailPage(
                              performance: PerformanceDetailData.fromSummary(item),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 155,
        height: 50,
        child: OutlinedButton(
          onPressed: _openCreatePage,
          style: OutlinedButton.styleFrom(
            backgroundColor: context.grays.white,
            foregroundColor: context.colors.onSurface,
            side: BorderSide(color: context.grays.gray7),
            shape: const StadiumBorder(),
            textStyle: FontStyles.med16.copyWith(color: context.grays.gray3),
          ),
          child: const Text('공연 등록하기'),
        ),
      ),
    );
  }

  Widget _filterToggle(String label, _PerformanceFilter filter) => AppToggle(
    text: label,
    isSelected: _filter == filter,
    onChanged: (_) => setState(() => _filter = filter),
  );
}
