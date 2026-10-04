class TeamLinkModel {
  final int teamLinkId;
  final String platformCode; // INSTAGRAM, YOUTUBE, ETC
  final String linkUrl;

  TeamLinkModel({
    required this.teamLinkId,
    required this.platformCode,
    required this.linkUrl,
  });

  factory TeamLinkModel.fromJson(Map<String, dynamic> json) {
    return TeamLinkModel(
      teamLinkId: json['teamLinkId'] as int? ?? 0,
      platformCode: json['platformCode'] as String? ?? '',
      linkUrl: json['linkUrl'] as String? ?? '',
    );
  }
}

class TeamDetailMemberModel {
  final String userName;
  final String? profileImageUrl;
  final String? position;

  TeamDetailMemberModel({
    required this.userName,
    this.profileImageUrl,
    this.position,
  });

  factory TeamDetailMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamDetailMemberModel(
      userName:
          json['userName'] as String? ?? json['user_name'] as String? ?? '',
      profileImageUrl:
          (json['profileImageUrl'] ?? json['profile_image_url']) as String?,
      position: json['position'] as String?,
    );
  }
}

class TeamDetailModel {
  final int teamId;
  final String teamPublicId;
  final String? teamImageUrl;
  final String teamName;
  final String? description;
  final String? establishedOn;
  final String inviteCode;
  final int memberCount;
  final String? myRole;
  final String createdAt;
  final String updatedAt;
  final List<TeamLinkModel> links;
  final List<TeamDetailMemberModel> members;
  final int archiveCount;
  final int cloudItemCount;

  TeamDetailModel({
    required this.teamId,
    required this.teamPublicId,
    this.teamImageUrl,
    required this.teamName,
    this.description,
    this.establishedOn,
    this.myRole,
    required this.inviteCode,
    required this.memberCount,
    required this.createdAt,
    required this.updatedAt,
    required this.links,
    required this.members,
    required this.archiveCount,
    required this.cloudItemCount,
  });

  factory TeamDetailModel.fromJson(Map<String, dynamic> json) {
    final linksList = json['links'] as List<dynamic>? ?? [];
    final membersList =
        (json['members'] ?? json['memberListResponse']) as List<dynamic>? ?? [];

    return TeamDetailModel(
      teamId: json['teamId'] as int? ?? 0,
      teamPublicId: json['teamPublicId'] as String? ?? '',
      teamImageUrl: json['teamImageUrl'] as String?,
      teamName: json['teamName'] as String? ?? '',
      description: json['description'] as String?,
      establishedOn: json['establishedOn'] as String?,
      inviteCode: json['inviteCode'] as String? ?? '',
      memberCount: json['memberCount'] as int? ?? 0,
      myRole: json['myRole'] as String? ?? json['my_role'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      links: linksList
          .map((e) => TeamLinkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      members: membersList
          .map((e) => TeamDetailMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      archiveCount: json['archiveCount'] as int? ?? 0,
      cloudItemCount: json['cloudItemCount'] as int? ?? 0,
    );
  }
}
