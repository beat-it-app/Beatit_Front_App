// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_main_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoticeListResponse _$NoticeListResponseFromJson(Map<String, dynamic> json) =>
    _NoticeListResponse(
      success: json['success'] as bool,
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      data: NoticeListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NoticeListResponseToJson(_NoticeListResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_NoticeListData _$NoticeListDataFromJson(Map<String, dynamic> json) =>
    _NoticeListData(
      noticeListResponse:
          (json['noticeListResponse'] as List<dynamic>?)
              ?.map((e) => NoticeListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <NoticeListItem>[],
      totalCount: (json['totalCount'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
    );

Map<String, dynamic> _$NoticeListDataToJson(_NoticeListData instance) =>
    <String, dynamic>{
      'noticeListResponse': instance.noticeListResponse,
      'totalCount': instance.totalCount,
      'hasNext': instance.hasNext,
    };

_NoticeListItem _$NoticeListItemFromJson(Map<String, dynamic> json) =>
    _NoticeListItem(
      noticeId: (json['noticeId'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      likeCount: (json['likeCount'] as num).toInt(),
      dislikeCount: (json['dislikeCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      writer: json['writer'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );

Map<String, dynamic> _$NoticeListItemToJson(_NoticeListItem instance) =>
    <String, dynamic>{
      'noticeId': instance.noticeId,
      'title': instance.title,
      'description': instance.description,
      'likeCount': instance.likeCount,
      'dislikeCount': instance.dislikeCount,
      'commentCount': instance.commentCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'writer': instance.writer,
      'thumbnailUrl': instance.thumbnailUrl,
    };

_PollListResponse _$PollListResponseFromJson(Map<String, dynamic> json) =>
    _PollListResponse(
      success: json['success'] as bool,
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      data: PollListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PollListResponseToJson(_PollListResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_PollListData _$PollListDataFromJson(Map<String, dynamic> json) =>
    _PollListData(
      pollListInProgress:
          (json['pollListInProgress'] as List<dynamic>?)
              ?.map((e) => PollListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PollListItem>[],
      pollListClosed:
          (json['pollListClosed'] as List<dynamic>?)
              ?.map((e) => PollListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PollListItem>[],
      totalCount: (json['totalCount'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
    );

Map<String, dynamic> _$PollListDataToJson(_PollListData instance) =>
    <String, dynamic>{
      'pollListInProgress': instance.pollListInProgress,
      'pollListClosed': instance.pollListClosed,
      'totalCount': instance.totalCount,
      'hasNext': instance.hasNext,
    };

_PollListItem _$PollListItemFromJson(Map<String, dynamic> json) =>
    _PollListItem(
      pollId: (json['pollId'] as num).toInt(),
      title: json['title'] as String,
      closeAt: json['closeAt'] == null
          ? null
          : DateTime.parse(json['closeAt'] as String),
      pollCount: (json['pollCount'] as num).toInt(),
      isVoted: json['voted'] as bool,
    );

Map<String, dynamic> _$PollListItemToJson(_PollListItem instance) =>
    <String, dynamic>{
      'pollId': instance.pollId,
      'title': instance.title,
      'closeAt': instance.closeAt?.toIso8601String(),
      'pollCount': instance.pollCount,
      'voted': instance.isVoted,
    };

_MeetitListResponse _$MeetitListResponseFromJson(Map<String, dynamic> json) =>
    _MeetitListResponse(
      success: json['success'] as bool,
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      data: MeetitListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MeetitListResponseToJson(_MeetitListResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_MeetitListData _$MeetitListDataFromJson(Map<String, dynamic> json) =>
    _MeetitListData(
      meetitList:
          (json['meetitList'] as List<dynamic>?)
              ?.map((e) => MeetitListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MeetitListItem>[],
      totalCount: (json['totalCount'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
    );

Map<String, dynamic> _$MeetitListDataToJson(_MeetitListData instance) =>
    <String, dynamic>{
      'meetitList': instance.meetitList,
      'totalCount': instance.totalCount,
      'hasNext': instance.hasNext,
    };

_MeetitListItem _$MeetitListItemFromJson(Map<String, dynamic> json) =>
    _MeetitListItem(
      meetitId: (json['meetitId'] as num).toInt(),
      title: json['title'] as String,
      totalInvitedCount: (json['totalInvitedCount'] as num).toInt(),
      respondedCount: (json['respondedCount'] as num).toInt(),
      myResponseStatus: $enumDecode(
        _$MeetitMyResponseStatusEnumMap,
        json['myResponseStatus'],
      ),
      dateOnly: json['dateOnly'] as bool,
    );

Map<String, dynamic> _$MeetitListItemToJson(_MeetitListItem instance) =>
    <String, dynamic>{
      'meetitId': instance.meetitId,
      'title': instance.title,
      'totalInvitedCount': instance.totalInvitedCount,
      'respondedCount': instance.respondedCount,
      'myResponseStatus':
          _$MeetitMyResponseStatusEnumMap[instance.myResponseStatus]!,
      'dateOnly': instance.dateOnly,
    };

const _$MeetitMyResponseStatusEnumMap = {
  MeetitMyResponseStatus.responded: 'RESPONDED',
  MeetitMyResponseStatus.notResponded: 'NOT_RESPONDED',
  MeetitMyResponseStatus.notParticipant: 'NOT_PARTICIPANT',
};
