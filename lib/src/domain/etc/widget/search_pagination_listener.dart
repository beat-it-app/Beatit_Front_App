import 'package:flutter/material.dart';

/// 검색 목록의 아래쪽으로 실제 스크롤했을 때만 다음 페이지를 요청합니다.
/// 음악과 장소가 같은 트리거 규칙을 사용하도록 etc 기능 안에서 공유합니다.
class SearchPaginationListener extends StatefulWidget {
  const SearchPaginationListener({
    super.key,
    required this.canLoadMore,
    required this.onLoadMore,
    required this.child,
  });

  final bool canLoadMore;
  final VoidCallback onLoadMore;
  final Widget child;

  @override
  State<SearchPaginationListener> createState() =>
      _SearchPaginationListenerState();
}

class _SearchPaginationListenerState extends State<SearchPaginationListener> {
  static const double _loadMoreThreshold = 180;
  bool _isRequestScheduled = false;

  bool _handleScroll(ScrollNotification notification) {
    if (notification.depth != 0 ||
        !widget.canLoadMore ||
        _isRequestScheduled) {
      return false;
    }

    final isScrollingDown = notification is ScrollUpdateNotification &&
        (notification.scrollDelta ?? 0) > 0;
    final isOverscrollingDown = notification is OverscrollNotification &&
        notification.overscroll > 0;

    if ((isScrollingDown || isOverscrollingDown) &&
        notification.metrics.extentAfter < _loadMoreThreshold) {
      // 레이아웃 도중 provider를 갱신하지 않도록 다음 프레임에서 요청합니다.
      // 한 프레임에 여러 ScrollNotification이 와도 한 번만 예약합니다.
      _isRequestScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isRequestScheduled = false;
        if (mounted && widget.canLoadMore) {
          widget.onLoadMore();
        }
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => NotificationListener<ScrollNotification>(
        onNotification: _handleScroll,
        child: widget.child,
      );
}
