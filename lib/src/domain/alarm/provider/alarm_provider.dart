import 'package:beatit_front_app/src/domain/alarm/provider/alarm_api_provider.dart';
import 'package:beatit_front_app/src/domain/alarm/model/alarm_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmState {
  const AlarmState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isReadingAll = false,
    this.activeNotificationId,
    this.errorMessage,
    this.teamId,
    this.teamName,
    this.unreadCount = 0,
    this.page = 0,
    this.isLast = true,
    this.notifications = const [],
  });

  final bool isLoading;
  final bool isLoadingMore;
  final bool isReadingAll;
  final int? activeNotificationId;
  final String? errorMessage;
  final int? teamId;
  final String? teamName;
  final int unreadCount;
  final int page;
  final bool isLast;
  final List<AlarmNotification> notifications;

  AlarmState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isReadingAll,
    int? activeNotificationId,
    bool clearActiveNotificationId = false,
    String? errorMessage,
    bool clearError = false,
    int? teamId,
    String? teamName,
    int? unreadCount,
    int? page,
    bool? isLast,
    List<AlarmNotification>? notifications,
  }) => AlarmState(
    isLoading: isLoading ?? this.isLoading,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    isReadingAll: isReadingAll ?? this.isReadingAll,
    activeNotificationId: clearActiveNotificationId
        ? null
        : activeNotificationId ?? this.activeNotificationId,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    teamId: teamId ?? this.teamId,
    teamName: teamName ?? this.teamName,
    unreadCount: unreadCount ?? this.unreadCount,
    page: page ?? this.page,
    isLast: isLast ?? this.isLast,
    notifications: notifications ?? this.notifications,
  );
}

class AlarmNotifier extends Notifier<AlarmState> {
  int _listRequestVersion = 0;

  @override
  AlarmState build() => const AlarmState();

  Future<void> fetchFirstPage() async {
    if (state.isLoading || state.isReadingAll ||
        state.activeNotificationId != null) {
      return;
    }
    final requestVersion = ++_listRequestVersion;
    state = const AlarmState(isLoading: true);
    try {
      final page = await ref.read(alarmApiProvider).getNotifications();
      if (requestVersion != _listRequestVersion) return;
      state = AlarmState(
        teamId: page.teamId,
        teamName: page.teamName,
        unreadCount: page.unreadCount,
        page: page.page,
        isLast: page.isLast,
        notifications: page.notifications,
      );
    } catch (error) {
      if (requestVersion != _listRequestVersion) return;
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.isLoadingMore || state.isLast ||
        state.activeNotificationId != null || state.isReadingAll) return;
    final requestVersion = _listRequestVersion;
    final nextPage = state.page + 1;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final page = await ref.read(alarmApiProvider).getNotifications(
        page: nextPage,
      );
      if (requestVersion != _listRequestVersion) return;
      // 팀이 변경된 사이에 도착한 응답이라면 목록을 섞지 않는다.
      if (page.teamId != state.teamId) {
        state = state.copyWith(isLoadingMore: false);
        await fetchFirstPage();
        return;
      }
      final knownIds = state.notifications.map((item) => item.id).toSet();
      state = state.copyWith(
        isLoadingMore: false,
        unreadCount: page.unreadCount,
        page: page.page,
        isLast: page.isLast,
        notifications: [
          ...state.notifications,
          ...page.notifications.where((item) => !knownIds.contains(item.id)),
        ],
      );
    } catch (error) {
      if (requestVersion != _listRequestVersion) return;
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<AlarmClickResponse?> readNotification(int notificationId, {
    bool switchTeam = false,
  }) async {
    if (state.activeNotificationId != null || state.isReadingAll || state.isLoading) return null;
    state = state.copyWith(
      activeNotificationId: notificationId,
      clearError: true,
    );
    try {
      final api = ref.read(alarmApiProvider);
      final result = switchTeam
          ? await api.clickNotification(notificationId)
          : await api.markAsRead(notificationId);
      final current = state.notifications;
      state = state.copyWith(
        clearActiveNotificationId: true,
        notifications: [
          for (final item in current)
            item.id == notificationId ? item.copyWith(isRead: true) : item,
        ],
        unreadCount: current.any((item) => item.id == notificationId && !item.isRead)
            ? (state.unreadCount - 1).clamp(0, 1 << 30).toInt()
            : state.unreadCount,
      );
      return result;
    } catch (error) {
      state = state.copyWith(
        clearActiveNotificationId: true,
        errorMessage: error.toString(),
      );
      return null;
    }
  }

  Future<bool> markAllAsRead() async {
    if (state.isReadingAll || state.isLoading ||
        state.activeNotificationId != null) return false;
    state = state.copyWith(isReadingAll: true, clearError: true);
    try {
      await ref.read(alarmApiProvider).markAllAsRead();
      state = state.copyWith(
        isReadingAll: false,
        unreadCount: 0,
        notifications: [
          for (final item in state.notifications) item.copyWith(isRead: true),
        ],
      );
      return true;
    } catch (error) {
      state = state.copyWith(
        isReadingAll: false,
        errorMessage: error.toString(),
      );
      return false;
    }
  }
}

final alarmProvider = NotifierProvider<AlarmNotifier, AlarmState>(
  AlarmNotifier.new,
);
