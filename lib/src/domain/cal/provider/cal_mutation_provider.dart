import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/cal/api/cal_api.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_create_request.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_update_request.dart';
import 'package:beatit_front_app/src/domain/cal/model/schedule/schedule_write_data.dart';
import 'package:beatit_front_app/src/domain/cal/provider/cal_api_provider.dart';

final calMutationProvider =
    NotifierProvider.autoDispose<CalMutationNotifier, CalMutationState>(
      CalMutationNotifier.new,
    );

class CalMutationState {
  const CalMutationState({
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.errorMessage,
  });

  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;
  final String? errorMessage;

  bool get isLoading => isCreating || isUpdating || isDeleting;

  CalMutationState copyWith({
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CalMutationState(
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class CalMutationNotifier extends Notifier<CalMutationState> {
  @override
  CalMutationState build() => const CalMutationState();

  Future<ScheduleWriteData?> createSchedule({
    required ScheduleCreateRequest request,
    List<String> filePaths = const <String>[],
  }) async {
    state = state.copyWith(isCreating: true, clearError: true);

    try {
      final response = await ref.read(calApiProvider).createSchedule(
        request: request,
        filePaths: filePaths,
      );

      state = state.copyWith(isCreating: false, clearError: true);
      return response.data;
    } catch (error) {
      state = state.copyWith(
        isCreating: false,
        errorMessage: _getErrorMessage(error),
      );
      return null;
    }
  }

  Future<ScheduleWriteData?> updateSchedule({
    required int scheduleId,
    required ScheduleUpdateRequest request,
    List<String> newFilePaths = const <String>[],
  }) async {
    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      final response = await ref.read(calApiProvider).updateSchedule(
        scheduleId: scheduleId,
        request: request,
        newFilePaths: newFilePaths,
      );

      state = state.copyWith(isUpdating: false, clearError: true);
      return response.data;
    } catch (error) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: _getErrorMessage(error),
      );
      return null;
    }
  }

  Future<bool> deleteSchedule({required int scheduleId}) async {
    state = state.copyWith(isDeleting: true, clearError: true);

    try {
      await ref.read(calApiProvider).deleteSchedule(scheduleId: scheduleId);

      state = state.copyWith(isDeleting: false, clearError: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isDeleting: false,
        errorMessage: _getErrorMessage(error),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  String _getErrorMessage(Object error) {
    if (error is CalApiException) {
      return error.message;
    }

    return '요청 처리 중 오류가 발생했습니다.';
  }
}
