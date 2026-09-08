import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_response.freezed.dart';
part 'signup_response.g.dart';

@freezed
abstract class SignupResponse with _$SignupResponse {
  const factory SignupResponse({
    required bool success,
    required int status,
    required String message,
    required SignupData data,
  }) = _SignupResponse;

  factory SignupResponse.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseFromJson(json);
}

@freezed
abstract class SignupData with _$SignupData {
  const factory SignupData({
    required int userId,
    required String identifier,
    required String email,
    required String createdAt,
  }) = _SignupData;

  factory SignupData.fromJson(Map<String, dynamic> json) =>
      _$SignupDataFromJson(json);
}
