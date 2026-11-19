import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthCredentialResult {
  final String identityToken;
  final String? email;

  const AppleAuthCredentialResult({required this.identityToken, this.email});
}

class AppleAuthClient {
  Future<AppleAuthCredentialResult?> getCredential() async {
    debugPrint('[AppleAuth] SDK login started');

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      if (identityToken == null || identityToken.trim().isEmpty) {
        throw StateError('Apple ID Token을 가져오지 못했습니다.');
      }

      debugPrint(
        '[AppleAuth] identityToken acquired, email: ${credential.email}',
      );
      return AppleAuthCredentialResult(
        identityToken: identityToken,
        email: credential.email,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint('[AppleAuth] SDK login cancelled');
        return null;
      }
      debugPrint('[AppleAuth] SDK login error: $e');
      rethrow;
    }
  }
}
