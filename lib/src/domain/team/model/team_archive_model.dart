class TeamArchiveItemModel {
  final int rehearsalRecordId;
  final String title;
  final String? placeName;
  final int likeCount;
  final int dislikeCount;
  final int commentCount;
  final String createdAt;

  TeamArchiveItemModel({
    required this.rehearsalRecordId,
    required this.title,
    this.placeName,
    required this.likeCount,
    required this.dislikeCount,
    required this.commentCount,
    required this.createdAt,
  });

  factory TeamArchiveItemModel.fromJson(Map<String, dynamic> json) {
    return TeamArchiveItemModel(
      rehearsalRecordId: json['rehearsal_record_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      placeName: json['place_name'] as String?,
      likeCount: json['like_count'] as int? ?? 0,
      dislikeCount: json['dislike_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}

class TeamArchiveResponseModel {
  final List<TeamArchiveItemModel> items;
  final int page;
  final int size;
  final int totalCount;

  TeamArchiveResponseModel({
    required this.items,
    required this.page,
    required this.size,
    required this.totalCount,
  });

  factory TeamArchiveResponseModel.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List<dynamic>? ?? [];
    return TeamArchiveResponseModel(
      items: list
          .map((e) => TeamArchiveItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int? ?? 0,
      size: json['size'] as int? ?? 20,
      totalCount: json['total_count'] as int? ?? 0,
    );
  }
}
