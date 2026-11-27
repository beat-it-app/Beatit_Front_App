class TeamMemberPositionModel {
  final int userId;
  final String userName;
  final String? profileImageUrl;
  final String? position;

  TeamMemberPositionModel({
    required this.userId,
    required this.userName,
    this.profileImageUrl,
    this.position,
  });

  factory TeamMemberPositionModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberPositionModel(
      userId: json['userId'] as int? ?? 0,
      userName: json['userName'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      position: json['position'] as String?,
    );
  }

  TeamMemberPositionModel copyWith({
    int? userId,
    String? userName,
    String? profileImageUrl,
    String? position,
  }) {
    return TeamMemberPositionModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      position: position ?? this.position,
    );
  }
}
