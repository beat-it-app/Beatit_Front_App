import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

enum Role {
  @JsonValue('USER')
  user,
  @JsonValue('ADMIN')
  admin,
}

enum SocialProvider {
  @JsonValue('NAVER')
  naver,
  @JsonValue('KAKAO')
  kakao,
  @JsonValue('GOOGLE')
  google,
}

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required int userId,
    required Role role,
    required bool createdProfile,
    SocialProvider? socialProvider,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
