// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_id_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FindIdentifierResponse _$FindIdentifierResponseFromJson(
  Map<String, dynamic> json,
) => _FindIdentifierResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: FindIdentifierData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FindIdentifierResponseToJson(
  _FindIdentifierResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_FindIdentifierData _$FindIdentifierDataFromJson(Map<String, dynamic> json) =>
    _FindIdentifierData(identifier: json['identifier'] as String);

Map<String, dynamic> _$FindIdentifierDataToJson(_FindIdentifierData instance) =>
    <String, dynamic>{'identifier': instance.identifier};
