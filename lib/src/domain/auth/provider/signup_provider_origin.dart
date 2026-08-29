import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/auth/model/signup/signup_request.dart';
import 'package:beatit_front_app/src/domain/auth/model/signup/signup_response.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_api_provider.dart';

final signupProvider =
    NotifierProvider<SignupNotifier, AsyncValue<SignupData?>>(
      SignupNotifier.new,
    );

class SignupNotifier extends Notifier<AsyncValue<SignupData?>> {
  @override
  AsyncValue<SignupData?> build() {
    return const AsyncData(null);
  }

  Future<void> signup({
    required String identifier,
    required String password,
    required String email,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final authApi = ref.read(authApiProvider);

      final request = SignupRequest(
        identifier: identifier,
        password: password,
        email: email,
      );

      final response = await authApi.signup(request);
      return response.data;
    });
  }

  void reset() {
    state = const AsyncData(null);
  }
}
