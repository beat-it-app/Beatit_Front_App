class TeamVerifyResponse {
  final bool success;
  final int status;
  final String message;
  final TeamVerifyData? data;

  TeamVerifyResponse({
    required this.success,
    required this.status,
    required this.message,
    this.data,
  });

  factory TeamVerifyResponse.fromJson(Map<String, dynamic> json) {
    return TeamVerifyResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? TeamVerifyData.fromJson(json['data']) : null,
    );
  }
}

class TeamVerifyData {
  final int teamId;
  final String teamPublicId;
  final String teamName;
  final String teamType;
  final String? teamImageUrl;
  final String createdAt;

  TeamVerifyData({
    required this.teamId,
    required this.teamPublicId,
    required this.teamName,
    required this.teamType,
    this.teamImageUrl,
    required this.createdAt,
  });

  factory TeamVerifyData.fromJson(Map<String, dynamic> json) {
    return TeamVerifyData(
      teamId: json['teamId'] ?? 0,
      teamPublicId: json['teamPublicId'] ?? '',
      teamName: json['teamName'] ?? '',
      teamType: json['teamType'] ?? '',
      teamImageUrl: json['teamImageUrl'],
      createdAt: json['createdAt'] ?? '',
    );
  }
}
