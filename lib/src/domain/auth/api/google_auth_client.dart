import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthClient {
  static const String _serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '269219968306-29skj0ruajrsujcr7u7ld3v6rrgjnv7c.apps.googleusercontent.com',
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

    await _googleSignIn.initialize(serverClientId: _serverClientId);

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
