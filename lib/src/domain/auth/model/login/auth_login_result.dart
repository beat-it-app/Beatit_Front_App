import 'auth_session.dart';

class AuthLoginResult {
  const AuthLoginResult({
    required this.session,
    required this.refreshToken,
  });

  final AuthSession session;
  final String refreshToken;
}
