// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostComment _$PostCommentFromJson(Map<String, dynamic> json) => _PostComment(
  commentId: (json['commentId'] as num).toInt(),
  parentCommentId: (json['parentCommentId'] as num?)?.toInt(),
  writerName: json['writerName'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  profileImageUrl: json['profileImageUrl'] as String?,
  isWriter: json['writer'] as bool? ?? false,
  isMine: json['mine'] as bool? ?? false,
  mentionedUsers:
      (json['mentionedUsers'] as List<dynamic>?)
          ?.map((e) => PostMentionUser.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PostMentionUser>[],
  replies:
      (json['replies'] as List<dynamic>?)
          ?.map((e) => PostComment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PostComment>[],
);

Map<String, dynamic> _$PostCommentToJson(_PostComment instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'parentCommentId': instance.parentCommentId,
      'writerName': instance.writerName,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'profileImageUrl': instance.profileImageUrl,
      'writer': instance.isWriter,
      'mine': instance.isMine,
      'mentionedUsers': instance.mentionedUsers,
      'replies': instance.replies,
    };

_PostMentionUser _$PostMentionUserFromJson(Map<String, dynamic> json) =>
    _PostMentionUser(
      userId: (json['userId'] as num).toInt(),
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$PostMentionUserToJson(_PostMentionUser instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'profileImageUrl': instance.profileImageUrl,
    };

_NoticeDetailResponse _$NoticeDetailResponseFromJson(
  Map<String, dynamic> json,
) => _NoticeDetailResponse(
  success: json['success'] as bool,
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  data: NoticeDetailData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NoticeDetailResponseToJson(
  _NoticeDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

_NoticeDetailData _$NoticeDetailDataFromJson(
  Map<String, dynamic> json,
) => _NoticeDetailData(
  noticeId: (json['noticeId'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String,
  writerName: json['writerName'] as String,
  writerProfileImageUrl: json['writerProfileImageUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  isWriter: json['writer'] as bool? ?? false,
  reaction: NoticeReaction.fromJson(json['reaction'] as Map<String, dynamic>),
  commentList:
      (json['commentList'] as List<dynamic>?)
          ?.map((e) => PostComment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PostComment>[],
);

Map<String, dynamic> _$NoticeDetailDataToJson(_NoticeDetailData instance) =>
    <String, dynamic>{
      'noticeId': instance.noticeId,
      'title': instance.title,
      'content': instance.content,
      'writerName': instance.writerName,
      'writerProfileImageUrl': instance.writerProfileImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'images': instance.images,
      'writer': instance.isWriter,
      'reaction': instance.reaction,
      'commentList': instance.commentList,
    };

_NoticeReaction _$NoticeReactionFromJson(Map<String, dynamic> json) =>
    _NoticeReaction(
      likeCount: (json['likeCount'] as num).toInt(),
      dislikeCount: (json['dislikeCount'] as num).toInt(),
      isLiked: json['liked'] as bool? ?? false,
      isDisliked: json['disliked'] as bool? ?? false,
      commentCount: (json['commentCount'] as num).toInt(),
    );

Map<String, dynamic> _$NoticeReactionToJson(_NoticeReaction instance) =>
    <String, dynamic>{
      'likeCount': instance.likeCount,
      'dislikeCount': instance.dislikeCount,
      'liked': instance.isLiked,
      'disliked': instance.isDisliked,
      'commentCount': instance.commentCount,
    };

_PollDetailResponse _$PollDetailResponseFromJson(Map<String, dynamic> json) =>
    _PollDetailResponse(
      success: json['success'] as bool,
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
      data: PollDetailData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PollDetailResponseToJson(_PollDetailResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

_PollDetailData _$PollDetailDataFromJson(Map<String, dynamic> json) =>
    _PollDetailData(
      pollId: (json['pollId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String?,
      pollType: json['pollType'] as String,
      allowMultipleChoice: json['allowMultipleChoice'] as bool,
      isAnonymous: json['anonymous'] as bool,
      closeAt: json['closeAt'] == null
          ? null
          : DateTime.parse(json['closeAt'] as String),
      writerName: json['writerName'] as String,
      writerProfileImageUrl: json['writerProfileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      pollItems:
          (json['pollItems'] as List<dynamic>?)
              ?.map((e) => PollDetailItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PollDetailItem>[],
      isWriter: json['writer'] as bool? ?? false,
      commentCount: (json['commentCount'] as num).toInt(),
      commentList:
          (json['commentList'] as List<dynamic>?)
              ?.map((e) => PostComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PostComment>[],
    );

Map<String, dynamic> _$PollDetailDataToJson(_PollDetailData instance) =>
    <String, dynamic>{
      'pollId': instance.pollId,
      'title': instance.title,
      'content': instance.content,
      'pollType': instance.pollType,
      'allowMultipleChoice': instance.allowMultipleChoice,
      'anonymous': instance.isAnonymous,
      'closeAt': instance.closeAt?.toIso8601String(),
      'writerName': instance.writerName,
      'writerProfileImageUrl': instance.writerProfileImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'pollItems': instance.pollItems,
      'writer': instance.isWriter,
      'commentCount': instance.commentCount,
      'commentList': instance.commentList,
    };

_PollDetailItem _$PollDetailItemFromJson(Map<String, dynamic> json) =>
    _PollDetailItem(
      itemId: (json['itemId'] as num).toInt(),
      voteCount: (json['voteCount'] as num).toInt(),
      isVoted: json['voted'] as bool? ?? false,
      content: json['content'] as String?,
      title: json['title'] as String?,
      artist: json['artist'] as String?,
      previewUrl: json['previewUrl'] as String?,
      location: json['location'] as String?,
      locationId: (json['locationId'] as num?)?.toInt(),
      locationName: json['locationName'] as String?,
      roadAddress: json['roadAddress'] as String?,
    );

Map<String, dynamic> _$PollDetailItemToJson(_PollDetailItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'voteCount': instance.voteCount,
      'voted': instance.isVoted,
      'content': instance.content,
      'title': instance.title,
      'artist': instance.artist,
      'previewUrl': instance.previewUrl,
      'location': instance.location,
      'locationId': instance.locationId,
      'locationName': instance.locationName,
      'roadAddress': instance.roadAddress,
    };

_PollCreateRequest _$PollCreateRequestFromJson(Map<String, dynamic> json) =>
    _PollCreateRequest(
      title: json['title'] as String,
      content: json['content'] as String?,
      pollType: json['pollType'] as String,
      pollList: (json['pollList'] as List<dynamic>)
          .map((e) => PollCreateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      allowMultipleChoice: json['allowMultipleChoice'] as bool,
      isAnonymous: json['isAnonymous'] as bool,
      remindBeforeClose: json['remindBeforeClose'] as bool,
      closeAt: json['closeAt'] == null
          ? null
          : DateTime.parse(json['closeAt'] as String),
    );

Map<String, dynamic> _$PollCreateRequestToJson(_PollCreateRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'pollType': instance.pollType,
      'pollList': instance.pollList,
      'allowMultipleChoice': instance.allowMultipleChoice,
      'isAnonymous': instance.isAnonymous,
      'remindBeforeClose': instance.remindBeforeClose,
      'closeAt': instance.closeAt?.toIso8601String(),
    };

_PollCreateItem _$PollCreateItemFromJson(Map<String, dynamic> json) =>
    _PollCreateItem(
      content: json['content'] as String?,
      music: json['music'] == null
          ? null
          : PollCreateMusic.fromJson(json['music'] as Map<String, dynamic>),
      location: json['location'] as String?,
      locationId: (json['locationId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PollCreateItemToJson(_PollCreateItem instance) =>
    <String, dynamic>{
      'content': instance.content,
      'music': instance.music,
      'location': instance.location,
      'locationId': instance.locationId,
    };

_PollCreateMusic _$PollCreateMusicFromJson(Map<String, dynamic> json) =>
    _PollCreateMusic(
      title: json['title'] as String,
      artist: json['artist'] as String,
      previewUrl: json['previewUrl'] as String?,
    );

Map<String, dynamic> _$PollCreateMusicToJson(_PollCreateMusic instance) =>
    <String, dynamic>{
      'title': instance.title,
      'artist': instance.artist,
      'previewUrl': instance.previewUrl,
    };
