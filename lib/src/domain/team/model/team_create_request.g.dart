// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamCreateRequest _$TeamCreateRequestFromJson(Map<String, dynamic> json) =>
    _TeamCreateRequest(
      teamName: json['teamName'] as String,
      teamType: json['teamType'] as String,
      description: json['description'] as String?,
      establishedOn: json['establishedOn'] as String?,
      teamImageUrl: json['teamImageUrl'] as String?,
    );

Map<String, dynamic> _$TeamCreateRequestToJson(_TeamCreateRequest instance) =>
    <String, dynamic>{
      'teamName': instance.teamName,
      'teamType': instance.teamType,
      'description': instance.description,
      'establishedOn': instance.establishedOn,
      'teamImageUrl': instance.teamImageUrl,
    };
