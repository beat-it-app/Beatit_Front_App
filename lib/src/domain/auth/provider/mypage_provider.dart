import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/mypage_api.dart';
import '../model/mypage/mypage_model.dart';

class MyPageState {
  final bool isLoading;
  final MyPageResponseModel? data;
  final int selectedTeamIndex;
  final String? errorMessage;

  const MyPageState({
    this.isLoading = false,
    this.data,
    this.selectedTeamIndex = 0,
    this.errorMessage,
  });

  MyPageState copyWith({
    bool? isLoading,
    MyPageResponseModel? data,
    int? selectedTeamIndex,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MyPageState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      selectedTeamIndex: selectedTeamIndex ?? this.selectedTeamIndex,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class MyPageNotifier extends Notifier<MyPageState> {
  @override
  MyPageState build() {
    return const MyPageState();
  }

  Future<void> fetchMyPage() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final api = ref.read(myPageApiProvider);
      final result = await api.getMyPage();
      state = state.copyWith(isLoading: false, data: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectTeamIndex(int index) {
    state = state.copyWith(selectedTeamIndex: index);
  }
}

final myPageProvider = NotifierProvider<MyPageNotifier, MyPageState>(() {
  return MyPageNotifier();
});
