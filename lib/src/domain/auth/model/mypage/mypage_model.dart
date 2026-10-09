class MyPageResponseModel {
  final int userId;
  final String userName;
  final String email;
  final String? profileImageUrl;
  final List<String> socialAccounts;
  final MyPageTeamModel? team;

  MyPageResponseModel({
    required this.userId,
    required this.userName,
    required this.email,
    this.profileImageUrl,
    required this.socialAccounts,
    this.team,
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
    );
  }
}

class MyPageTeamModel {
  final String type;
  final String name;
  final String? imageUrl;
  final String leaderName;
  final int memberCount;

  MyPageTeamModel({
    required this.type,
    required this.name,
    this.imageUrl,
    required this.leaderName,
    required this.memberCount,
  });

  factory MyPageTeamModel.fromJson(Map<String, dynamic> json) {
    return MyPageTeamModel(
      type: json['type'] as String? ?? 'BAND',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      leaderName: json['leaderName'] as String? ?? '',
      memberCount: json['memberCount'] as int? ?? 1,
    );
  }
}
