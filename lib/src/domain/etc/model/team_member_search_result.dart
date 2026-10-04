class TeamMemberSearchResult {
  const TeamMemberSearchResult({
    required this.userPublicId,
    required this.userName,
    required this.teamRole,
    this.userId,
    this.profileImageUrl,
    this.position,
  });

  /// 일정 API의 participantUserIds에 사용할 내부 사용자 ID.
  /// 백엔드가 아직 내려주지 않는 동안에는 null이다.
  final int? userId;
  final String userPublicId;
  final String userName;
  final String? profileImageUrl;
  final String teamRole;
  final String? position;

  factory TeamMemberSearchResult.fromJson(Map<String, dynamic> json) {
    return TeamMemberSearchResult(
      userId: _toNullableInt(json['id'] ?? json['userId']),
      userPublicId: json['userPublicId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      profileImageUrl: json['profileImageUrl']?.toString(),
      teamRole: json['teamRole']?.toString() ?? 'MEMBER',
      position: json['position']?.toString(),
    );
  }

  static int? _toNullableInt(Object? value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '');
  }
}

class TeamMemberListData {
  const TeamMemberListData({
    required this.members,
    required this.totalCount,
    required this.hasNext,
  });

  final List<TeamMemberSearchResult> members;
  final int totalCount;
  final bool hasNext;

  factory TeamMemberListData.fromJson(Map<String, dynamic> json) {
    final rawMembers = json['memberListResponse'];
    final members = rawMembers is List
        ? rawMembers
              .whereType<Map>()
              .map(
                (item) => TeamMemberSearchResult.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList(growable: false)
        : const <TeamMemberSearchResult>[];

    return TeamMemberListData(
      members: members,
      totalCount: _toInt(json['totalCount']),
      hasNext: json['hasNext'] == true,
    );
  }

  static int _toInt(Object? value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
