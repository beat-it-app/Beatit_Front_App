// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignupResponse _$SignupResponseFromJson(Map<String, dynamic> json) =>
    _SignupResponse(
      success: json['success'] as bool,
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      data: SignupData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignupResponseToJson(_SignupResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_SignupData _$SignupDataFromJson(Map<String, dynamic> json) => _SignupData(
  userId: (json['userId'] as num).toInt(),
  identifier: json['identifier'] as String,
  email: json['email'] as String,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$SignupDataToJson(_SignupData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'identifier': instance.identifier,
      'email': instance.email,
      'createdAt': instance.createdAt,
    };
