import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_main_models.freezed.dart';
part 'post_main_models.g.dart';

enum PostMainType { notice, poll, meetit }

extension PostMainTypeExtension on PostMainType {
  String get title {
    switch (this) {
      case PostMainType.notice:
        return '공지';
      case PostMainType.poll:
        return '투표';
      case PostMainType.meetit:
        return '밋잇';
    }
  }

  String get createMenuLabel {
    switch (this) {
      case PostMainType.notice:
        return '공지 작성하기';
      case PostMainType.poll:
        return '투표 생성하기';
      case PostMainType.meetit:
        return '밋잇 생성하기';
    }
  }
}

@freezed
abstract class NoticeListResponse with _$NoticeListResponse {
  const factory NoticeListResponse({
    required bool success,
    required int status,
    required String message,
    required NoticeListData data,
  }) = _NoticeListResponse;

  factory NoticeListResponse.fromJson(Map<String, dynamic> json) =>
      _$NoticeListResponseFromJson(json);
}

@freezed
abstract class NoticeListData with _$NoticeListData {
  const factory NoticeListData({
    @Default(<NoticeListItem>[]) List<NoticeListItem> noticeListResponse,
    required int totalCount,
    required bool hasNext,
  }) = _NoticeListData;

  factory NoticeListData.fromJson(Map<String, dynamic> json) =>
      _$NoticeListDataFromJson(json);
}

@freezed
abstract class NoticeListItem with _$NoticeListItem {
  const factory NoticeListItem({
    required int noticeId,
    required String title,
    required String description,
    required int likeCount,
    required int dislikeCount,
    required int commentCount,
    required DateTime createdAt,
    required String writer,
    String? thumbnailUrl,
  }) = _NoticeListItem;

  factory NoticeListItem.fromJson(Map<String, dynamic> json) =>
      _$NoticeListItemFromJson(json);
}

@freezed
abstract class PollListResponse with _$PollListResponse {
  const factory PollListResponse({
    required bool success,
    required int status,
    required String message,
    required PollListData data,
  }) = _PollListResponse;

  factory PollListResponse.fromJson(Map<String, dynamic> json) =>
      _$PollListResponseFromJson(json);
}

@freezed
abstract class PollListData with _$PollListData {
  const factory PollListData({
    @Default(<PollListItem>[]) List<PollListItem> pollListInProgress,
    @Default(<PollListItem>[]) List<PollListItem> pollListClosed,
    required int totalCount,
    required bool hasNext,
  }) = _PollListData;

  factory PollListData.fromJson(Map<String, dynamic> json) =>
      _$PollListDataFromJson(json);
}

@freezed
abstract class PollListItem with _$PollListItem {
  const factory PollListItem({
    required int pollId,
    required String title,
    DateTime? closeAt,
    required int pollCount,
    @JsonKey(name: 'voted')
    required bool isVoted,
  }) = _PollListItem;

  factory PollListItem.fromJson(Map<String, dynamic> json) =>
      _$PollListItemFromJson(json);
}

@freezed
abstract class MeetitListResponse with _$MeetitListResponse {
  const factory MeetitListResponse({
    required bool success,
    required int status,
    required String message,
    required MeetitListData data,
  }) = _MeetitListResponse;

  factory MeetitListResponse.fromJson(Map<String, dynamic> json) =>
      _$MeetitListResponseFromJson(json);
}

@freezed
abstract class MeetitListData with _$MeetitListData {
  const factory MeetitListData({
    @Default(<MeetitListItem>[]) List<MeetitListItem> meetitList,
    required int totalCount,
    required bool hasNext,
  }) = _MeetitListData;

  factory MeetitListData.fromJson(Map<String, dynamic> json) =>
      _$MeetitListDataFromJson(json);
}

enum MeetitMyResponseStatus {
  @JsonValue('RESPONDED')
  responded,
  @JsonValue('NOT_RESPONDED')
  notResponded,
  @JsonValue('NOT_PARTICIPANT')
  notParticipant,
}

@freezed
abstract class MeetitListItem with _$MeetitListItem {
  const factory MeetitListItem({
    required int meetitId,
    required String title,
    required int totalInvitedCount,
    required int respondedCount,
    required MeetitMyResponseStatus myResponseStatus,
    required bool dateOnly,
  }) = _MeetitListItem;

  factory MeetitListItem.fromJson(Map<String, dynamic> json) =>
      _$MeetitListItemFromJson(json);
}
