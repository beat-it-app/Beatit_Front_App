import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/network/auth_token_storage.dart';
import 'package:beatit_front_app/src/domain/auth/api/google_auth_client.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/auth_session.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/google_login_request.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/login_request.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/login_response.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_api_provider.dart';

final googleAuthClientProvider = Provider<GoogleAuthClient>((ref) {
  return GoogleAuthClient();
});

final authProvider = NotifierProvider<AuthNotifier, AsyncValue<AuthSession?>>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AsyncValue<AuthSession?>> {
  @override
  AsyncValue<AuthSession?> build() {
    return const AsyncData(null);
  }

  Future<void> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final authApi = ref.read(authApiProvider);
      final tokenStorage = ref.read(authTokenStorageProvider);

      final session = await authApi.login(
        LoginRequest(
          identifier: identifier,
          password: password,
          rememberMe: rememberMe,
        ),
      );

      await tokenStorage.saveAccessToken(session.accessToken);

      return session;
    });
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      debugPrint('[Auth] Google token request start');

      final googleAuthClient = ref.read(googleAuthClientProvider);

      final authApi = ref.read(authApiProvider);

      final idToken = await googleAuthClient.getIdToken();

      debugPrint('[Auth] Google token acquired');
      debugPrint('[Auth] Beatit /auth/google request start');

      final session = await authApi.loginWithGoogle(
        GoogleLoginRequest(idToken: idToken),
      );

      debugPrint('[Auth] Beatit login success');

      await ref
          .read(authTokenStorageProvider)
          .saveAccessToken(session.accessToken);

      debugPrint('[Auth] access token saved');

      return session;
    });
  }

  void markProfileCreated() {
    final session = state.asData?.value;

    if (session == null) {
      return;
    }

    state = AsyncData(session.copyWith(createdProfile: true));
  }

  Future<void> logout() async {
    final currentSession = state.asData?.value;
    final tokenStorage = ref.read(authTokenStorageProvider);

    if (currentSession?.socialProvider == SocialProvider.google) {
      await ref.read(googleAuthClientProvider).signOut();
    }

    await tokenStorage.deleteAccessToken();
    state = const AsyncData(null);
  }
}
