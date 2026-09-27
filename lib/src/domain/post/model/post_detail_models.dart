import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_detail_models.freezed.dart';
part 'post_detail_models.g.dart';

@freezed
abstract class PostComment with _$PostComment {
  const factory PostComment({
    required int commentId,
    int? parentCommentId,
    required String writerName,
    required String content,
    required DateTime createdAt,
    String? profileImageUrl,
    @JsonKey(name: 'writer') @Default(false) bool isWriter,
    @JsonKey(name: 'mine') @Default(false) bool isMine,
    @Default(<PostMentionUser>[]) List<PostMentionUser> mentionedUsers,
    @Default(<PostComment>[]) List<PostComment> replies,
  }) = _PostComment;

  factory PostComment.fromJson(Map<String, dynamic> json) =>
      _$PostCommentFromJson(json);
}

@freezed
abstract class PostMentionUser with _$PostMentionUser {
  const factory PostMentionUser({
    required int userId,
    required String name,
    String? profileImageUrl,
  }) = _PostMentionUser;

  factory PostMentionUser.fromJson(Map<String, dynamic> json) =>
      _$PostMentionUserFromJson(json);
}

@freezed
abstract class NoticeDetailResponse with _$NoticeDetailResponse {
  const factory NoticeDetailResponse({
    required bool success,
    required int status,
    required String message,
    required NoticeDetailData data,
  }) = _NoticeDetailResponse;

  factory NoticeDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$NoticeDetailResponseFromJson(json);
}

@freezed
abstract class NoticeDetailData with _$NoticeDetailData {
  const factory NoticeDetailData({
    required int noticeId,
    required String title,
    required String content,
    required String writerName,
    String? writerProfileImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(<String>[]) List<String> images,
    @JsonKey(name: 'writer') @Default(false) bool isWriter,
    required NoticeReaction reaction,
    @Default(<PostComment>[]) List<PostComment> commentList,
  }) = _NoticeDetailData;

  factory NoticeDetailData.fromJson(Map<String, dynamic> json) =>
      _$NoticeDetailDataFromJson(json);
}

@freezed
abstract class NoticeReaction with _$NoticeReaction {
  const factory NoticeReaction({
    required int likeCount,
    required int dislikeCount,
    @JsonKey(name: 'liked') @Default(false) bool isLiked,
    @JsonKey(name: 'disliked') @Default(false) bool isDisliked,
    required int commentCount,
  }) = _NoticeReaction;

  factory NoticeReaction.fromJson(Map<String, dynamic> json) =>
      _$NoticeReactionFromJson(json);
}

@freezed
abstract class PollDetailResponse with _$PollDetailResponse {
  const factory PollDetailResponse({
    required bool success,
    required int status,
    required String message,
    required PollDetailData data,
  }) = _PollDetailResponse;

  factory PollDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PollDetailResponseFromJson(json);
}

@freezed
abstract class PollDetailData with _$PollDetailData {
  const factory PollDetailData({
    required int pollId,
    required String title,
    String? content,
    required String pollType,
    required bool allowMultipleChoice,
    @JsonKey(name: 'anonymous') required bool isAnonymous,
    DateTime? closeAt,
    required String writerName,
    String? writerProfileImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(<PollDetailItem>[]) List<PollDetailItem> pollItems,
    @JsonKey(name: 'writer') @Default(false) bool isWriter,
    required int commentCount,
    @Default(<PostComment>[]) List<PostComment> commentList,
  }) = _PollDetailData;

  factory PollDetailData.fromJson(Map<String, dynamic> json) =>
      _$PollDetailDataFromJson(json);
}

@freezed
abstract class PollDetailItem with _$PollDetailItem {
  const factory PollDetailItem({
    required int itemId,
    required int voteCount,
    @JsonKey(name: 'voted') @Default(false) bool isVoted,
    String? content,
    String? title,
    String? artist,
    String? previewUrl,
    String? location,
    int? locationId,
    String? locationName,
    String? roadAddress,
  }) = _PollDetailItem;

  factory PollDetailItem.fromJson(Map<String, dynamic> json) =>
      _$PollDetailItemFromJson(json);
}

@freezed
abstract class PollCreateRequest with _$PollCreateRequest {
  const factory PollCreateRequest({
    required String title,
    String? content,
    required String pollType,
    required List<PollCreateItem> pollList,
    required bool allowMultipleChoice,
    @JsonKey(name: 'isAnonymous') required bool isAnonymous,
    required bool remindBeforeClose,
    DateTime? closeAt,
  }) = _PollCreateRequest;

  factory PollCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$PollCreateRequestFromJson(json);
}

@freezed
abstract class PollCreateItem with _$PollCreateItem {
  const factory PollCreateItem({
    String? content,
    PollCreateMusic? music,
    String? location,
    int? locationId,
  }) = _PollCreateItem;

  factory PollCreateItem.fromJson(Map<String, dynamic> json) =>
      _$PollCreateItemFromJson(json);
}

@freezed
abstract class PollCreateMusic with _$PollCreateMusic {
  const factory PollCreateMusic({
    required String title,
    required String artist,
    String? previewUrl,
  }) = _PollCreateMusic;

  factory PollCreateMusic.fromJson(Map<String, dynamic> json) =>
      _$PollCreateMusicFromJson(json);
}
