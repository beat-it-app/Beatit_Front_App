// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoogleLoginRequest _$GoogleLoginRequestFromJson(Map<String, dynamic> json) =>
    _GoogleLoginRequest(
      idToken: json['idToken'] as String,
      isRestore: json['isRestore'] as bool? ?? false,
    );

Map<String, dynamic> _$GoogleLoginRequestToJson(_GoogleLoginRequest instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'isRestore': instance.isRestore,
    };
