import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthClient {
  // 1. 백엔드 검증용 웹 클라이언트 ID (Audience 대상)
  static const String _serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '269219968306-4eu5u8ci2bu6hdc9djfo9qphfqp3uskm.apps.googleusercontent.com',
  );

  // 2. Google Cloud Console에서 발급받은 iOS 전용 클라이언트 ID
  // (Info.plist의 GIDClientID에 넣으신 그 값을 defaultValue에 넣으세요)
  static const String _iosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue:
        '269219968306-rc52umj39t821joakhuq5rb2ngpeh526.apps.googleusercontent.com',
  );

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _initialized = false;

  Future<String> getIdToken() async {
    try {
      debugPrint('[GoogleAuth] initialize start');

      await _ensureInitialized();

      debugPrint('[GoogleAuth] initialize success');
      debugPrint('[GoogleAuth] authenticate start');

      final account = await _googleSignIn.authenticate();

      debugPrint('[GoogleAuth] authenticate success');
      debugPrint('[GoogleAuth] email: ${account.email}');

      final idToken = account.authentication.idToken;

      debugPrint('[GoogleAuth] idToken exists: ${idToken != null}');

      if (idToken == null) {
        throw const GoogleAuthClientException('Google ID Token을 가져오지 못했습니다.');
      }

      return idToken;
    } catch (error, stackTrace) {
      debugPrint('[GoogleAuth] ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> signOut() async {
    await _ensureInitialized();
    await _googleSignIn.signOut();
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }

    // iOS일 때는 네이티브 clientId와 serverClientId를 동시에 주입해야
    // 백엔드 웹 클라이언트 ID 기준의 정상 idToken이 발급됩니다.
    await _googleSignIn.initialize(
      serverClientId: _serverClientId,
      clientId: Platform.isIOS ? _iosClientId : null,
    );

    _initialized = true;
  }
}

class GoogleLoginCanceledException implements Exception {
  const GoogleLoginCanceledException();

  @override
  String toString() => 'Google 로그인이 취소되었습니다.';
}

class GoogleAuthClientException implements Exception {
  const GoogleAuthClientException(this.message);

  final String message;

  @override
  String toString() => message;
}
