class TeamPerformanceModel {
  final String performancePublicId;
  final String title;
  final DateTime? performanceDateTime;
  final String? posterImageUrl;

  TeamPerformanceModel({
    required this.performancePublicId,
    required this.title,
    this.performanceDateTime,
    this.posterImageUrl,
  });

  factory TeamPerformanceModel.fromJson(Map<String, dynamic> json) {
    return TeamPerformanceModel(
      performancePublicId: json['performancePublicId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      performanceDateTime: json['performanceDateTime'] != null
          ? DateTime.tryParse(json['performanceDateTime'] as String)
          : null,
      posterImageUrl: json['posterImageUrl'] as String?,
    );
  }
}
