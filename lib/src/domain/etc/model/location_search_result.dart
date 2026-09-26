class LocationSearchResult {
  const LocationSearchResult({
    required this.locationName,
    required this.roadAddress,
    required this.latitude,
    required this.longitude,
    required this.mapUrl,
    this.phone,
    this.kakaoPlaceId,
    this.jibunAddress,
    this.distance,
  });

  final String locationName;
  final String roadAddress;
  final double latitude;
  final double longitude;
  final String mapUrl;
  final String? phone;
  final String? kakaoPlaceId;
  final String? jibunAddress;
  final String? distance;

  factory LocationSearchResult.fromJson(Map<String, dynamic> json) {
    return LocationSearchResult(
      locationName: json['locationName']?.toString() ?? '',
      roadAddress: json['roadAddress']?.toString() ?? '',
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      mapUrl: json['mapUrl']?.toString() ?? '',
      phone: json['phone']?.toString(),
      kakaoPlaceId: json['kakaoPlaceId']?.toString(),
      jibunAddress: json['jibunAddress']?.toString(),
      distance: json['distance']?.toString(),
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
