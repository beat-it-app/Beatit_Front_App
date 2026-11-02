import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_model.dart';
import 'package:beatit_front_app/src/domain/performance/provider/my_performance_provider.dart';
import 'package:beatit_front_app/src/domain/performance/view/performance_detail_page.dart';
import 'package:beatit_front_app/src/domain/performance/widget/performance_item_widget.dart';

/// 나의 공연 목록 페이지 (GET /performances/my 연동)
class PerformanceMinePage extends ConsumerWidget {
  const PerformanceMinePage({
    super.key,
    this.onEdit,
    this.onDelete,
    this.onViewResponses,
  });

  final ValueChanged<PerformanceModel>? onEdit;
  final ValueChanged<PerformanceModel>? onDelete;
  final ValueChanged<PerformanceModel>? onViewResponses;

  void _openDetail(BuildContext context, WidgetRef ref, PerformanceModel item) {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => PerformanceDetailPage(
              performancePublicId: item.performancePublicId,
              isMine: true,
              onEdit: onEdit == null ? null : () => onEdit!(item),
              onDelete: onDelete == null ? null : () => onDelete!(item),
              onViewResponses: onViewResponses == null
                  ? null
                  : () => onViewResponses!(item),
            ),
          ),
        )
        .then((_) {
          // 상세 화면에서 수정/삭제 후 돌아왔을 때 목록 재조회
          ref.invalidate(myPerformanceListProvider);
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performanceAsync = ref.watch(myPerformanceListProvider);

    return Scaffold(
      backgroundColor: context.grays.white,
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).maybePop(),
      ),
      body: performanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '공연 목록을 불러오지 못했습니다.',
                style: FontStyles.med14.copyWith(color: context.colors.error),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.refresh(myPerformanceListProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (performances) {
          if (performances.isEmpty) {
            return Center(
              child: Text(
                '등록한 공연이 없습니다.',
                style: FontStyles.med14.copyWith(color: context.grays.gray5),
              ),
            );
          }

          return PerformanceGrid(
            performances: performances,
            showPastLabel: true,
            onTap: (item) => _openDetail(context, ref, item),
          );
        },
      ),
    );
  }
}
