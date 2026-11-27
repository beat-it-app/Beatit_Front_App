class MyPageResponseModel {
  final int userId;
  final String userName;
  final String email;
  final String? profileImageUrl;
  final List<String> socialAccounts;
  final MyPageTeamModel? team;
  final int unreadNotificationCount;

  MyPageResponseModel({
    required this.userId,
    required this.userName,
    required this.email,
    this.profileImageUrl,
    required this.socialAccounts,
    this.team,
    this.unreadNotificationCount = 0,
  });

  factory MyPageResponseModel.fromJson(Map<String, dynamic> json) {
    return MyPageResponseModel(
      userId: json['userId'] as int? ?? 0,
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      socialAccounts:
          (json['socialAccounts'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      team: json['team'] != null
          ? MyPageTeamModel.fromJson(json['team'] as Map<String, dynamic>)
          : null,
      unreadNotificationCount:
          (json['unreadNotificationCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class MyPageTeamModel {
  final int teamId;
  final String teamPublicId;
  final String type;
  final String name;
  final String? imageUrl;
  final String leaderName;
  final String? myRole; // 👈 추가: LEADER, MANAGER, MEMBER 등
  final int memberCount;
  final String? establishedOn;

  MyPageTeamModel({
    required this.teamId,
    required this.teamPublicId,
    required this.type,
    required this.name,
    this.imageUrl,
    required this.leaderName,
    this.myRole,
    required this.memberCount,
    this.establishedOn,
  });

  // 권한 헬퍼 getter
  bool get isLeader => myRole?.toUpperCase() == 'LEADER';

  bool get isManager => myRole?.toUpperCase() == 'MANAGER';

  bool get isLeaderOrManager => isLeader || isManager;

  factory MyPageTeamModel.fromJson(Map<String, dynamic> json) {
    return MyPageTeamModel(
      teamId: (json['teamId'] as num?)?.toInt() ?? 0,
      teamPublicId: json['teamPublicId']?.toString() ?? '',
      type: json['type'] as String? ?? 'BAND',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      leaderName: json['leaderName'] as String? ?? '',
      myRole: json['myRole']?.toString(),
      // 👈 매핑
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      establishedOn: json['establishedOn']?.toString(),
    );
  }
}
