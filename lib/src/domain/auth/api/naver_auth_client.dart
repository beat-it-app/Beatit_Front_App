import 'package:flutter/cupertino.dart';
import 'package:naver_login_flutter/naver_login_flutter.dart';

class NaverAuthClient {
  Future<String?> getAccessToken() async {
    debugPrint('[NaverAuth] SDK login started');

    try {
      final result = await FlutterNaverLogin.logIn();

      debugPrint('[NaverAuth] SDK login status: ${result.status}');

      if (result.status == NaverLoginStatus.loggedOut) {
        return null;
      }
      if (result.status != NaverLoginStatus.loggedIn) {
        throw StateError('네이버 로그인에 실패했습니다. 다시 시도해주세요.');
      }

      final token = await FlutterNaverLogin.getCurrentAccessToken();
      if (!token.isValid() || token.accessToken.trim().isEmpty) {
        throw StateError('네이버 로그인 토큰을 가져오지 못했습니다.');
      }

      return token.accessToken;
    } catch (error) {
      debugPrint('[NaverAuth] SDK login error: $error');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await FlutterNaverLogin.logOut();
  }
}
