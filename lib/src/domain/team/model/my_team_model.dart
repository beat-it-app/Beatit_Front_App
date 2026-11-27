class MyTeamModel {
  final int teamId;
  final String teamPublicId;
  final String teamName;
  final String teamType;
  final String? teamImageUrl;
  final String createdAt;

  MyTeamModel({
    required this.teamId,
    required this.teamPublicId,
    required this.teamName,
    required this.teamType,
    this.teamImageUrl,
    required this.createdAt,
  });

  factory MyTeamModel.fromJson(Map<String, dynamic> json) {
    return MyTeamModel(
      teamId: json['teamId'] as int? ?? 0,
      teamPublicId: json['teamPublicId'] as String? ?? '',
      teamName: json['teamName'] as String? ?? '',
      teamType: json['teamType'] as String? ?? 'BAND',
      teamImageUrl: json['teamImageUrl'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

class MyTeamResponse {
  final bool success;
  final int status;
  final String message;
  final bool hasActiveTeam; // 💡 선택된 팀이 이미 있는지 여부
  final List<MyTeamModel> teams;

  MyTeamResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.hasActiveTeam,
    required this.teams,
  });

  factory MyTeamResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    // 1. data 안에 'teamId' 필드가 있으면 -> 이미 활성화된 팀이 있는 경우 (3번 시나리오)
    if (data is Map<String, dynamic> && data.containsKey('teamId')) {
      return MyTeamResponse(
        success: json['success'] as bool? ?? true,
        status: json['status'] as int? ?? 200,
        message: json['message'] as String? ?? '',
        hasActiveTeam: true,
        teams: const [],
      );
    }

    // 2. data 안에 'teams' 배열이 있으면 -> 선택된 팀이 없는 경우 (1번 또는 2번 시나리오)
    final list = (data is Map<String, dynamic>)
        ? data['teams'] as List<dynamic>? ?? []
        : [];

    return MyTeamResponse(
      success: json['success'] as bool? ?? false,
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      hasActiveTeam: false,
      teams: list
          .map((e) => MyTeamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
