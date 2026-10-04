import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/post/api/post_api.dart';
import 'package:beatit_front_app/src/domain/post/model/post_main_models.dart';
import 'package:beatit_front_app/src/domain/post/provider/post_api_provider.dart';

final postMainProvider =
    NotifierProvider.autoDispose<PostMainNotifier, PostMainState>(
      PostMainNotifier.new,
    );

class PostMainState {
  const PostMainState({
    this.notices = const <NoticeListItem>[],
    this.pollsInProgress = const <PollListItem>[],
    this.pollsClosed = const <PollListItem>[],
    this.meetits = const <MeetitListItem>[],
    this.isNoticeLoading = false,
    this.isPollLoading = false,
    this.isMeetitLoading = false,
    this.noticeError,
    this.pollError,
    this.meetitError,
    this.noticeKeyword = '',
    this.pollKeyword = '',
    this.meetitKeyword = '',
  });

  final List<NoticeListItem> notices;
  final List<PollListItem> pollsInProgress;
  final List<PollListItem> pollsClosed;
  final List<MeetitListItem> meetits;

  final bool isNoticeLoading;
  final bool isPollLoading;
  final bool isMeetitLoading;

  final String? noticeError;
  final String? pollError;
  final String? meetitError;

  final String noticeKeyword;
  final String pollKeyword;
  final String meetitKeyword;

  PostMainState copyWith({
    List<NoticeListItem>? notices,
    List<PollListItem>? pollsInProgress,
    List<PollListItem>? pollsClosed,
    List<MeetitListItem>? meetits,
    bool? isNoticeLoading,
    bool? isPollLoading,
    bool? isMeetitLoading,
    String? noticeError,
    String? pollError,
    String? meetitError,
    bool clearNoticeError = false,
    bool clearPollError = false,
    bool clearMeetitError = false,
    String? noticeKeyword,
    String? pollKeyword,
    String? meetitKeyword,
  }) {
    return PostMainState(
      notices: notices ?? this.notices,
      pollsInProgress: pollsInProgress ?? this.pollsInProgress,
      pollsClosed: pollsClosed ?? this.pollsClosed,
      meetits: meetits ?? this.meetits,
      isNoticeLoading: isNoticeLoading ?? this.isNoticeLoading,
      isPollLoading: isPollLoading ?? this.isPollLoading,
      isMeetitLoading: isMeetitLoading ?? this.isMeetitLoading,
      noticeError: clearNoticeError ? null : noticeError ?? this.noticeError,
      pollError: clearPollError ? null : pollError ?? this.pollError,
      meetitError: clearMeetitError ? null : meetitError ?? this.meetitError,
      noticeKeyword: noticeKeyword ?? this.noticeKeyword,
      pollKeyword: pollKeyword ?? this.pollKeyword,
      meetitKeyword: meetitKeyword ?? this.meetitKeyword,
    );
  }
}

class PostMainNotifier extends Notifier<PostMainState> {
  int _noticeRequestId = 0;
  int _pollRequestId = 0;
  int _meetitRequestId = 0;

  @override
  PostMainState build() => const PostMainState();

  Future<void> loadNotices({String keyword = ''}) async {
    final requestId = ++_noticeRequestId;
    final normalizedKeyword = keyword.trim();

    state = state.copyWith(
      isNoticeLoading: true,
      noticeKeyword: normalizedKeyword,
      clearNoticeError: true,
    );

    try {
      final response = await ref.read(postApiProvider).getNotices(
            keyword: normalizedKeyword,
          );

      if (!ref.mounted || requestId != _noticeRequestId) {
        return;
      }

      state = state.copyWith(
        notices: response.data.noticeListResponse,
        isNoticeLoading: false,
        clearNoticeError: true,
      );
    } catch (error) {
      if (!ref.mounted || requestId != _noticeRequestId) {
        return;
      }

      state = state.copyWith(
        isNoticeLoading: false,
        noticeError: _getErrorMessage(error, fallback: '공지 목록을 불러오지 못했습니다.'),
      );
    }
  }

  Future<void> loadPolls({String keyword = ''}) async {
    final requestId = ++_pollRequestId;
    final normalizedKeyword = keyword.trim();

    state = state.copyWith(
      isPollLoading: true,
      pollKeyword: normalizedKeyword,
      clearPollError: true,
    );

    try {
      final response = await ref.read(postApiProvider).getPolls(
            keyword: normalizedKeyword,
          );

      if (!ref.mounted || requestId != _pollRequestId) {
        return;
      }

      state = state.copyWith(
        pollsInProgress: response.data.pollListInProgress,
        pollsClosed: response.data.pollListClosed,
        isPollLoading: false,
        clearPollError: true,
      );
    } catch (error) {
      if (!ref.mounted || requestId != _pollRequestId) {
        return;
      }

      state = state.copyWith(
        isPollLoading: false,
        pollError: _getErrorMessage(error, fallback: '투표 목록을 불러오지 못했습니다.'),
      );
    }
  }

  Future<void> loadMeetits({String keyword = ''}) async {
    final requestId = ++_meetitRequestId;
    final normalizedKeyword = keyword.trim();

    state = state.copyWith(
      isMeetitLoading: true,
      meetitKeyword: normalizedKeyword,
      clearMeetitError: true,
    );

    try {
      final api = ref.read(postApiProvider);
      final allItems = <MeetitListItem>[];

      var page = 0;
      var response = await api.getMeetits(page: page);
      allItems.addAll(response.data.meetitList);

      // MeetitController에는 keyword 파라미터가 없으므로 검색할 때만
      // 모든 페이지를 조회한 뒤 제목을 클라이언트에서 필터링합니다.
      while (normalizedKeyword.isNotEmpty && response.data.hasNext) {
        page += 1;
        response = await api.getMeetits(page: page);
        allItems.addAll(response.data.meetitList);
      }

      if (!ref.mounted || requestId != _meetitRequestId) {
        return;
      }

      final filtered = normalizedKeyword.isEmpty
          ? allItems
          : allItems
              .where(
                (item) => item.title.toLowerCase().contains(
                      normalizedKeyword.toLowerCase(),
                    ),
              )
              .toList(growable: false);

      state = state.copyWith(
        meetits: filtered,
        isMeetitLoading: false,
        clearMeetitError: true,
      );
    } catch (error) {
      if (!ref.mounted || requestId != _meetitRequestId) {
        return;
      }

      state = state.copyWith(
        isMeetitLoading: false,
        meetitError: _getErrorMessage(error, fallback: '밋잇 목록을 불러오지 못했습니다.'),
      );
    }
  }

  String _getErrorMessage(Object error, {required String fallback}) {
    if (error is PostApiException) {
      return error.message;
    }
    return fallback;
  }
}
