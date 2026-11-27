class TeamScheduleModel {
  final int scheduleId;
  final String title;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String locationName;

  TeamScheduleModel({
    required this.scheduleId,
    required this.title,
    this.startsAt,
    this.endsAt,
    required this.locationName,
  });

  factory TeamScheduleModel.fromJson(Map<String, dynamic> json) {
    return TeamScheduleModel(
      scheduleId: json['scheduleId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      startsAt: json['startsAt'] != null
          ? DateTime.tryParse(json['startsAt'] as String)?.toLocal()
          : null,
      endsAt: json['endsAt'] != null
          ? DateTime.tryParse(json['endsAt'] as String)?.toLocal()
          : null,
      locationName: json['locationName'] as String? ?? '',
    );
  }
}
