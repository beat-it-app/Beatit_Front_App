// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResetPasswordResponse _$ResetPasswordResponseFromJson(
  Map<String, dynamic> json,
) => _ResetPasswordResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: ResetPasswordData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ResetPasswordResponseToJson(
  _ResetPasswordResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_ResetPasswordData _$ResetPasswordDataFromJson(Map<String, dynamic> json) =>
    _ResetPasswordData(password: json['password'] as String);

Map<String, dynamic> _$ResetPasswordDataToJson(_ResetPasswordData instance) =>
    <String, dynamic>{'password': instance.password};
