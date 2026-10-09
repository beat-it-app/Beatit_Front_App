class PollVoter {
  const PollVoter({
    required this.name,
    this.profileImageUrl,
    this.position,
  });

  final String name;
  final String? profileImageUrl;
  final String? position;

  factory PollVoter.fromJson(Map<String, dynamic> json) => PollVoter(
    name: json['name']?.toString() ?? '알 수 없음',
    profileImageUrl: json['profileImageUrl']?.toString(),
    position: json['position']?.toString(),
  );
}
