import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../view/auth/naver_webview_login_page.dart';

class NaverAuthClient {
  // env.json에 등록된 NAVER_CLIENT_ID, NAVER_CLIENT_SECRET 사용
  static const String _naverClientId = String.fromEnvironment(
    'NAVER_CLIENT_ID',
    defaultValue: '',
  );

  static const String _naverClientSecret = String.fromEnvironment(
    'NAVER_CLIENT_SECRET',
    defaultValue: '',
  );

  // 네이버 개발자 센터 콘솔의 '서비스 URL / Callback URL'에 등록되어 있는 URL
  static const String _redirectUri = 'http://localhost:8080';

  Future<String?> getAccessToken({BuildContext? context}) async {
    debugPrint('[NaverAuth] Web OAuth login started');

    if (context == null) {
      throw StateError('네이버 로그인을 위해 BuildContext가 필요합니다.');
    }

    // 1. 웹뷰로 인가 코드(code) 획득
    final String? code = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => const NaverWebviewLoginPage(
          clientId: _naverClientId,
          redirectUri: _redirectUri,
        ),
        fullscreenDialog: true,
      ),
    );

    if (code == null) {
      debugPrint('[NaverAuth] 로그인 취소');
      return null;
    }

    // 2. 획득한 code로 네이버 API를 호출해 백엔드가 요구하는 accessToken 발급
    final state = DateTime.now().millisecondsSinceEpoch.toString();
    final tokenUrl = Uri.parse(
      'https://nid.naver.com/oauth2.0/token'
      '?grant_type=authorization_code'
      '&client_id=$_naverClientId'
      '&client_secret=$_naverClientSecret'
      '&code=$code'
      '&state=$state',
    );

    try {
      final response = await http.get(tokenUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final accessToken = data['access_token'] as String?;

        if (accessToken != null && accessToken.isNotEmpty) {
          debugPrint('[NaverAuth] AccessToken 획득 완료: $accessToken');
          return accessToken; // 💡 백엔드 NaverAuthService.verifyToken에 그대로 전달
        }
      }
      throw StateError('네이버 토큰 발급 실패: ${response.body}');
    } catch (e) {
      debugPrint('[NaverAuth] 토큰 요청 오류: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    final cookieManager = WebViewCookieManager();
    await cookieManager.clearCookies();
  }
}
