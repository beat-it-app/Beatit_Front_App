import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_detail_page.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_item_widget.dart';
import 'package:flutter/material.dart';

/// 공연 메인과 동일한 카드 그리드. 검색과 필터가 없으며 소유한 공연만 전달받는다.
class PerformanceMinePage extends StatelessWidget {
  const PerformanceMinePage({
    super.key,
    this.performances = const [],
    this.onEdit,
    this.onDelete,
    this.onViewResponses,
  });

  final List<PerformanceSummary> performances;
  final ValueChanged<PerformanceSummary>? onEdit;
  final ValueChanged<PerformanceSummary>? onDelete;
  final ValueChanged<PerformanceSummary>? onViewResponses;

  void _openDetail(BuildContext context, PerformanceSummary item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PerformanceDetailPage(
          performance: PerformanceDetailData.fromSummary(item),
          isMine: true,
          onEdit: onEdit == null ? null : () => onEdit!(item),
          onDelete: onDelete == null ? null : () => onDelete!(item),
          onViewResponses: onViewResponses == null
              ? null : () => onViewResponses!(item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.grays.white,
    appBar: AppTopAppBar.backOnly(
      onBackPressed: () => Navigator.of(context).maybePop(),
    ),
    body: performances.isEmpty
        ? Center(
            child: Text('등록한 공연이 없습니다.',
              style: FontStyles.med14.copyWith(color: context.grays.gray5)),
          )
        : PerformanceGrid(
            performances: performances,
            showPastLabel: true,
            onTap: (item) => _openDetail(context, item),
          ),
  );
}
