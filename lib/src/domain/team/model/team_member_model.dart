class TeamMemberModel {
  final String userPublicId;
  final String name;
  final String? profileImageUrl;
  final String teamRole;
  final String? position;

  TeamMemberModel({
    required this.userPublicId,
    required this.name,
    this.profileImageUrl,
    required this.teamRole,
    this.position,
  });

  bool get isLeader => teamRole == 'LEADER';

  bool get isManager => teamRole == 'MANAGER';

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      userPublicId: json['userPublicId'] as String? ?? '',
      // 백엔드 명세(name) 및 응답 예시(userName) 양쪽 대응
      name: (json['userName'] ?? json['name']) as String? ?? '',
      profileImageUrl:
          (json['profileImageUrl'] ?? json['profile_image_url']) as String?,
      teamRole: json['teamRole'] as String? ?? 'MEMBER',
      position: json['position'] as String?,
    );
  }

  TeamMemberModel copyWith({
    String? userPublicId,
    String? name,
    String? profileImageUrl,
    String? teamRole,
    String? position,
  }) {
    return TeamMemberModel(
      userPublicId: userPublicId ?? this.userPublicId,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      teamRole: teamRole ?? this.teamRole,
      position: position ?? this.position,
    );
  }
}
