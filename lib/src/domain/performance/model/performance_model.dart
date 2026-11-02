class PerformanceModel {
  final String performancePublicId;
  final String title;
  final DateTime? performanceDateTime;
  final String? posterImageUrl;

  PerformanceModel({
    required this.performancePublicId,
    required this.title,
    this.performanceDateTime,
    this.posterImageUrl,
  });

  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    return PerformanceModel(
      performancePublicId: json['performancePublicId']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      // 백엔드 UTC 시각을 기기 로컬 시각(KST)으로 변환
      performanceDateTime: json['performanceDateTime'] != null
          ? DateTime.tryParse(json['performanceDateTime'].toString())?.toLocal()
          : null,
      posterImageUrl: json['posterImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'performancePublicId': performancePublicId,
      'title': title,
      'performanceDateTime': performanceDateTime?.toIso8601String(),
      'posterImageUrl': posterImageUrl,
    };
  }
}

/// 2. GET /performances 응답의 최상위 data 필드 모델
class PerformanceResponseModel {
  final List<PerformanceModel> upcoming;
  final List<PerformanceModel> past;
  final int totalCount;
  final bool hasNext;

  PerformanceResponseModel({
    required this.upcoming,
    required this.past,
    required this.totalCount,
    required this.hasNext,
  });

  factory PerformanceResponseModel.fromJson(Map<String, dynamic> json) {
    final upcomingList = (json['upcoming'] as List<dynamic>?) ?? [];
    final pastList = (json['past'] as List<dynamic>?) ?? [];

    return PerformanceResponseModel(
      upcoming: upcomingList
          .map((e) => PerformanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      past: pastList
          .map((e) => PerformanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
    );
  }

  /// '전체 보기(ALL)'일 때 진행 예정과 지난 공연을 합쳐서 반환
  List<PerformanceModel> get allItems => [...upcoming, ...past];
}
