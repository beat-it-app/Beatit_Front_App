class TeamArchiveDetailRating {
  final double averageRating;
  final int ratingCount;
  final double myRating;

  TeamArchiveDetailRating({
    required this.averageRating,
    required this.ratingCount,
    required this.myRating,
  });

  factory TeamArchiveDetailRating.fromJson(Map<String, dynamic> json) {
    return TeamArchiveDetailRating(
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['ratingCount'] as int? ?? 0,
      myRating: (json['myRating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ArchiveMentionUserModel {
  final int userId;
  final String nickname;

  const ArchiveMentionUserModel({required this.userId, required this.nickname});

  factory ArchiveMentionUserModel.fromJson(Map<String, dynamic> json) {
    return ArchiveMentionUserModel(
      userId: json['userId'] as int? ?? 0,
      nickname: json['nickname'] as String? ?? '',
    );
  }
}

class TeamArchiveCommentModel {
  final int commentId;
  final int? parentCommentId;
  final String writerName;
  final String content;
  final String createdAt;
  final String? profileImageUrl;
  final bool isWriter;
  final bool isMine;
  final List<ArchiveMentionUserModel> mentionedUsers;
  final List<TeamArchiveCommentModel> replies; // 👈 백엔드의 replies 트리 구조

  const TeamArchiveCommentModel({
    required this.commentId,
    this.parentCommentId,
    required this.writerName,
    required this.content,
    required this.createdAt,
    this.profileImageUrl,
    required this.isWriter,
    required this.isMine,
    this.mentionedUsers = const [],
    this.replies = const [],
  });

  factory TeamArchiveCommentModel.fromJson(Map<String, dynamic> json) {
    return TeamArchiveCommentModel(
      commentId: json['commentId'] as int? ?? 0,
      parentCommentId: json['parentCommentId'] as int?,
      writerName: json['writerName'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      isWriter: json['isWriter'] as bool? ?? false,
      isMine: json['isMine'] as bool? ?? false,
      mentionedUsers:
          (json['mentionedUsers'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ArchiveMentionUserModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map(
                (e) =>
                    TeamArchiveCommentModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
}

class TeamArchiveDetailModel {
  final int archiveId;
  final int teamId;
  final int writerId;
  final String title;
  final String? roadAddress;
  final int locationId;
  final String description;
  final List<String> archiveImageUrls;
  final String writerName;
  final String? writerProfileImageUrl;
  final bool isWriter;
  final bool topArchive;
  final TeamArchiveDetailRating rating;
  final int commentCount;
  final List<TeamArchiveCommentModel> commentList;
  final String createdAt;
  final String updatedAt;

  TeamArchiveDetailModel({
    required this.archiveId,
    required this.teamId,
    required this.writerId,
    required this.title,
    this.roadAddress,
    required this.locationId,
    required this.description,
    required this.archiveImageUrls,
    required this.writerName,
    this.writerProfileImageUrl,
    required this.isWriter,
    required this.topArchive,
    required this.rating,
    required this.commentCount,
    required this.commentList,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeamArchiveDetailModel.fromJson(Map<String, dynamic> json) {
    return TeamArchiveDetailModel(
      archiveId: json['archiveId'] as int? ?? 0,
      teamId: json['teamId'] as int? ?? 0,
      writerId: json['writerId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      roadAddress: json['roadAddress'] as String?,
      locationId: json['locationId'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      archiveImageUrls:
          (json['archiveImageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      writerName: json['writerName'] as String? ?? '',
      writerProfileImageUrl: json['writerProfileImageUrl'] as String?,
      isWriter: json['isWriter'] as bool? ?? false,
      topArchive: json['topArchive'] as bool? ?? false,
      rating: TeamArchiveDetailRating.fromJson(
        json['rating'] as Map<String, dynamic>? ?? {},
      ),
      commentCount: json['commentCount'] as int? ?? 0,
      commentList:
          (json['commentList'] as List<dynamic>?)
              ?.map(
                (e) =>
                    TeamArchiveCommentModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}
