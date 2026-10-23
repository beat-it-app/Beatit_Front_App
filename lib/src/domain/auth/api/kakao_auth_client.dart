import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoAuthClient {
  static const String nativeAppKey = String.fromEnvironment(
    'KAKAO_NATIVE_APP_KEY',
  );

  Future<String?> getAccessToken() async {
    if (nativeAppKey.isEmpty) {
      throw StateError('카카오 앱 키가 설정되지 않았습니다.');
    }

    if (await isKakaoTalkInstalled()) {
      try {
        final token = await UserApi.instance.loginWithKakaoTalk();
        return token.accessToken;
      } catch (error) {
        if (_isCanceled(error)) return null;
        // 카카오톡 연결이 실패하면 카카오계정 로그인으로 대체한다.
      }
    }

    try {
      final token = await UserApi.instance.loginWithKakaoAccount();
      return token.accessToken;
    } catch (error) {
      if (_isCanceled(error)) return null;
      rethrow;
    }
  }

  bool _isCanceled(Object error) {
    return (error is PlatformException && error.code == 'CANCELED') ||
        (error is KakaoAuthException &&
            error.error == AuthErrorCause.accessDenied);
  }

  Future<void> signOut() async {
    await UserApi.instance.logout();
  }
}
