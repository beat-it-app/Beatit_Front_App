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
    required bool success,
    required int status,
    required String message,
    required LoginData data,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
abstract class LoginData with _$LoginData {
  const factory LoginData({
    required int userId,
    required Role role,
    required bool createdProfile,
    SocialProvider? socialProvider,
  }) = _LoginData;

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
}
