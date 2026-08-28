import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_response.freezed.dart';
part 'reset_password_response.g.dart';

@freezed
abstract class ResetPasswordResponse with _$ResetPasswordResponse {
  const factory ResetPasswordResponse({
    required bool success,
    required int status,
    required String message,
    required ResetPasswordData data,
  }) = _ResetPasswordResponse;

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);
}

@freezed
abstract class ResetPasswordData with _$ResetPasswordData {
  const factory ResetPasswordData({
    required String password,
  }) = _ResetPasswordData;

  factory ResetPasswordData.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordDataFromJson(json);
}
