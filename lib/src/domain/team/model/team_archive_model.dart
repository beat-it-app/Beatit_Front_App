class TeamArchiveItemModel {
  final int archiveId;
  final int teamId;
  final int writerId;
  final String title;
  final String? roadAddress;
  final String? archiveImageUrl;
  final double averageRating;
  final int commentCount;

  TeamArchiveItemModel({
    required this.archiveId,
    required this.teamId,
    required this.writerId,
    required this.title,
    this.roadAddress,
    this.archiveImageUrl,
    required this.averageRating,
    required this.commentCount,
  });

  factory TeamArchiveItemModel.fromJson(Map<String, dynamic> json) {
    return TeamArchiveItemModel(
      archiveId: json['archiveId'] as int? ?? 0,
      teamId: json['teamId'] as int? ?? 0,
      writerId: json['writerId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      roadAddress: json['roadAddress'] as String?,
      archiveImageUrl: json['archiveImageUrl'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      commentCount: json['commentCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'archiveId': archiveId,
      'teamId': teamId,
      'writerId': writerId,
      'title': title,
      'roadAddress': roadAddress,
      'archiveImageUrl': archiveImageUrl,
      'averageRating': averageRating,
      'commentCount': commentCount,
    };
  }
}

class TeamArchiveResponseModel {
  final List<TeamArchiveItemModel> archives;
  final int totalCount;
  final bool hasNext;

  TeamArchiveResponseModel({
    required this.archives,
    required this.totalCount,
    required this.hasNext,
  });

  factory TeamArchiveResponseModel.fromJson(Map<String, dynamic> json) {
    final list = json['archives'] as List<dynamic>? ?? [];
    return TeamArchiveResponseModel(
      archives: list
          .map((e) => TeamArchiveItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'archives': archives.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'hasNext': hasNext,
    };
  }
}
