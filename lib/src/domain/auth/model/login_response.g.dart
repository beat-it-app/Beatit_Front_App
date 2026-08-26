// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      userId: (json['userId'] as num).toInt(),
      role: $enumDecode(_$RoleEnumMap, json['role']),
      createdProfile: json['createdProfile'] as bool,
      socialProvider: $enumDecodeNullable(
        _$SocialProviderEnumMap,
        json['socialProvider'],
      ),
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'role': _$RoleEnumMap[instance.role]!,
      'createdProfile': instance.createdProfile,
      'socialProvider': _$SocialProviderEnumMap[instance.socialProvider],
    };

const _$RoleEnumMap = {Role.user: 'USER', Role.admin: 'ADMIN'};

const _$SocialProviderEnumMap = {
  SocialProvider.naver: 'NAVER',
  SocialProvider.kakao: 'KAKAO',
  SocialProvider.google: 'GOOGLE',
};
