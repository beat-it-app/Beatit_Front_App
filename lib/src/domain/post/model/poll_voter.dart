class PollVoter {
  const PollVoter({
    required this.userId,
    required this.name,
    this.profileImageUrl,
    this.position,
  });

  final int userId;
  final String name;
  final String? profileImageUrl;
  final String? position;

  factory PollVoter.fromJson(Map<String, dynamic> json) => PollVoter(
    userId: (json['userId'] as num).toInt(),
    name: json['name']?.toString() ?? '알 수 없음',
    profileImageUrl: json['profileImageUrl']?.toString(),
    position: json['position']?.toString(),
  );
}
