import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/core/network/auth_token_storage.dart';
import 'package:beatit_front_app/src/domain/auth/api/auth_api.dart';
import 'package:beatit_front_app/src/domain/auth/api/auth_push_registration.dart';
import 'package:beatit_front_app/src/domain/auth/api/google_auth_client.dart';
import 'package:beatit_front_app/src/domain/auth/api/kakao_auth_client.dart';
import 'package:beatit_front_app/src/domain/auth/api/naver_auth_client.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/auth_login_result.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/auth_session.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/google_login_request.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/login_request.dart';
import 'package:beatit_front_app/src/domain/auth/model/login/login_response.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_api_provider.dart';

final authPushRegistrationProvider = Provider<AuthPushRegistration>((ref) {
  final registration = AuthPushRegistration();
  ref.onDispose(registration.dispose);
  return registration;
});

final googleAuthClientProvider = Provider<GoogleAuthClient>((ref) {
  return GoogleAuthClient();
});

final naverAuthClientProvider = Provider<NaverAuthClient>((ref) {
  return NaverAuthClient();
});

final kakaoAuthClientProvider = Provider<KakaoAuthClient>((ref) {
  return KakaoAuthClient();
});

final authProvider = NotifierProvider<AuthNotifier, AsyncValue<AuthSession?>>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AsyncValue<AuthSession?>> {
  @override
  AsyncValue<AuthSession?> build() {
    return const AsyncData(null);
  }

  static const Set<String> _invalidRefreshTokenCodes = {
    'LOGIN-006',
    'LOGIN-007',
    'LOGIN-008',
  };

  Future<AuthSession?> restoreSession() async {
    final tokenStorage = ref.read(authTokenStorageProvider);
    final refreshToken = await tokenStorage.readRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      await tokenStorage.deleteTokens();
      state = const AsyncData(null);
      return null;
    }

    state = const AsyncLoading();

    try {
      final result = await ref
          .read(authApiProvider)
          .reissueLogin(refreshToken: refreshToken);

      await tokenStorage.saveTokens(
        accessToken: result.session.accessToken,
        refreshToken: result.refreshToken,
      );

      state = AsyncData(result.session);
      _startTokenRefreshListener();
      unawaited(_registerPushAfterRestore(result.session.accessToken));
      return result.session;
    } on AuthApiException catch (error) {
      if (_invalidRefreshTokenCodes.contains(error.code)) {
        await tokenStorage.deleteTokens();
      }

      debugPrint('[Auth] session restore failed: ${error.code} ${error.message}');
      state = const AsyncData(null);
      return null;
    } catch (error) {
      debugPrint('[Auth] session restore failed: $error');
      state = const AsyncData(null);
      return null;
    }
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

      final deviceFields = await ref
          .read(authPushRegistrationProvider)
          .collectLoginFields();
      final result = await authApi.login(
        LoginRequest(
          identifier: identifier,
          password: password,
          rememberMe: rememberMe,
        ),
        deviceFields: deviceFields,
      );

      await tokenStorage.saveTokens(
        accessToken: result.session.accessToken,
        refreshToken: result.refreshToken,
      );

      _startTokenRefreshListener();
      if (deviceFields['pushToken'] == null) {
        unawaited(_retryPushRegistration(result.session.accessToken));
      }
      return result.session;
    });
  }

  Future<void> loginWithGoogle() => _loginWithSocial(
    getToken: () => ref.read(googleAuthClientProvider).getIdToken(),
    authenticate: (token, deviceFields) => ref
        .read(authApiProvider)
        .loginWithGoogle(
          GoogleLoginRequest(idToken: token),
          deviceFields: deviceFields,
        ),
  );

  Future<void> loginWithNaver() => _loginWithSocial(
    getToken: () => ref.read(naverAuthClientProvider).getAccessToken(),
    authenticate: (token, deviceFields) => ref
        .read(authApiProvider)
        .loginWithNaver(accessToken: token, deviceFields: deviceFields),
  );

  Future<void> loginWithKakao() => _loginWithSocial(
    getToken: () => ref.read(kakaoAuthClientProvider).getAccessToken(),
    authenticate: (token, deviceFields) => ref
        .read(authApiProvider)
        .loginWithKakao(accessToken: token, deviceFields: deviceFields),
  );

  Future<void> _loginWithSocial({
    required Future<String?> Function() getToken,
    required Future<AuthLoginResult> Function(
      String token,
      Map<String, dynamic> deviceFields,
    ) authenticate,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final token = await getToken();
      if (token == null) return null; // SDK 로그인 취소

      final deviceFields = await ref
          .read(authPushRegistrationProvider)
          .collectLoginFields();
      final result = await authenticate(token, deviceFields);

      await ref.read(authTokenStorageProvider).saveTokens(
        accessToken: result.session.accessToken,
        refreshToken: result.refreshToken,
      );

      _startTokenRefreshListener();
      if (deviceFields['pushToken'] == null) {
        unawaited(_retryPushRegistration(result.session.accessToken));
      }
      return result.session;
    });
  }

  void _startTokenRefreshListener() {
    ref.read(authPushRegistrationProvider).startTokenRefreshListener(
      (token) async {
        final tokenStorage = ref.read(authTokenStorageProvider);
        final accessToken = await tokenStorage.readAccessToken();
        if (accessToken == null || accessToken.isEmpty) return;

        final registration = await ref
            .read(authPushRegistrationProvider)
            .registrationForRefreshedToken(token);
        if (registration == null) return;

        // 토큰 정보를 가져오는 중 로그아웃한 경우에는 전송하지 않는다.
        if (await tokenStorage.readAccessToken() != accessToken) return;
        await ref.read(authApiProvider).registerPushToken(registration);
      },
    );
  }

  Future<void> _retryPushRegistration(String accessToken) async {
    await Future<void>.delayed(const Duration(seconds: 5));
    await _registerPushAfterRestore(accessToken);
  }

  Future<void> _registerPushAfterRestore(String restoredAccessToken) async {
    try {
      final registration = await ref
          .read(authPushRegistrationProvider)
          .collectLoginFields();
      if (registration['deviceId'] == null ||
          registration['pushToken'] == null) {
        return;
      }

      // 재발급 이후 로그인된 사용자가 바뀌었다면 이전 토큰을 등록하지 않는다.
      final currentAccessToken = await ref
          .read(authTokenStorageProvider)
          .readAccessToken();
      if (currentAccessToken != restoredAccessToken) return;

      await ref.read(authApiProvider).registerPushToken(registration);
    } catch (error) {
      // 세션 복구 성공과 푸시 등록 성공은 별개다.
      debugPrint('[AuthPush] registration after restore skipped: $error');
    }
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

    // 푸시 갱신이 로그아웃 도중 다시 등록되지 않도록 먼저 중지한다.
    await ref.read(authPushRegistrationProvider).stopTokenRefreshListener();

    try {
      // 서버가 Refresh Token을 폐기하고 현재 기기의 푸시 토큰을 비활성화한다.
      await ref.read(authApiProvider).logout();
    } catch (error) {
      // 서버가 이미 세션을 만료시킨 경우에도 기기의 인증 정보는 삭제한다.
      debugPrint('[Auth] server logout failed: $error');
    } finally {
      try {
        final provider = currentSession?.socialProvider;
        if (provider == SocialProvider.google) {
          await ref.read(googleAuthClientProvider).signOut();
        } else if (provider == SocialProvider.naver) {
          await ref.read(naverAuthClientProvider).signOut();
        } else if (provider == SocialProvider.kakao) {
          await ref.read(kakaoAuthClientProvider).signOut();
        }
      } catch (error) {
        // 외부 SDK 세션 정리 실패가 BeatIt 로그아웃을 막아서는 안 된다.
        debugPrint('[Auth] social logout failed: $error');
      } finally {
        await tokenStorage.deleteTokens();
        state = const AsyncData(null);
      }
    }
  }
}
