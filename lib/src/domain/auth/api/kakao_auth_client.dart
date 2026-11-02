import 'package:flutter/foundation.dart';
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

    debugPrint('[KakaoAuth] SDK login started');
    if (await isKakaoTalkInstalled()) {
      debugPrint('[KakaoAuth] KakaoTalk login started');
      try {
        final token = await UserApi.instance.loginWithKakaoTalk();
        debugPrint('[KakaoAuth] KakaoTalk token acquired');
        return token.accessToken;
      } catch (error) {
        if (_isCanceled(error)) {
          debugPrint('[KakaoAuth] KakaoTalk login cancelled');
          return null;
        }
        // 기존 정책: 카카오톡 로그인 실패 시 카카오계정 로그인으로 대체한다.
        debugPrint('[KakaoAuth] KakaoTalk login failed: ${_errorLabel(error)}');
      }
    }

    debugPrint('[KakaoAuth] KakaoAccount login started');
    try {
      final token = await UserApi.instance.loginWithKakaoAccount();
      debugPrint('[KakaoAuth] KakaoAccount token acquired');
      return token.accessToken;
    } catch (error) {
      if (_isCanceled(error)) {
        debugPrint('[KakaoAuth] KakaoAccount login cancelled');
        return null;
      }
      debugPrint('[KakaoAuth] KakaoAccount login failed: ${_errorLabel(error)}');
      rethrow;
    }
  }

  bool _isCanceled(Object error) {
    return (error is PlatformException && error.code == 'CANCELED') ||
        (error is KakaoAuthException &&
            error.error == AuthErrorCause.accessDenied);
  }

  String _errorLabel(Object error) {
    if (error is PlatformException) {
      return 'PlatformException(${error.code})';
    }
    if (error is KakaoAuthException) {
      return 'KakaoAuthException(${error.error})';
    }
    return error.runtimeType.toString();
  }

  Future<void> signOut() async {
    await UserApi.instance.logout();
  }
}
