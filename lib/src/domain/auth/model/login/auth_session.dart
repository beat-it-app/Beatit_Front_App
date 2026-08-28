import 'package:freezed_annotation/freezed_annotation.dart';

import 'login_response.dart';

part 'auth_session.freezed.dart';

@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required int userId,
    required Role role,
    required bool createdProfile,
    required String accessToken,
    SocialProvider? socialProvider,
  }) = _AuthSession;
}
