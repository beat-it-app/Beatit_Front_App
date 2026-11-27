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

  Map<String, dynamic> toLocationRequestJson() {
    return {
      'locationName': locationName,
      'roadAddress': roadAddress,
      'latitude': latitude,
      'longitude': longitude,
      'mapUrl': mapUrl,
      'phone': phone,
      'kakaoPlaceId': kakaoPlaceId,
      'jibunAddress': jibunAddress,
    };
  }
}

class LocationData {
  const LocationData({
    required this.locationId,
    this.locationName,
    this.roadAddress,
    this.latitude,
    this.longitude,
    this.mapUrl,
    this.phone,
    this.kakaoPlaceId,
    this.jibunAddress,
  });

  final int locationId;
  final String? locationName;
  final String? roadAddress;
  final double? latitude;
  final double? longitude;
  final String? mapUrl;
  final String? phone;
  final String? kakaoPlaceId;
  final String? jibunAddress;

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      locationId: _toInt(json['locationId']),
      locationName: json['locationName']?.toString(),
      roadAddress: json['roadAddress']?.toString(),
      latitude: _toNullableDouble(json['latitude']),
      longitude: _toNullableDouble(json['longitude']),
      mapUrl: json['mapUrl']?.toString(),
      phone: json['phone']?.toString(),
      kakaoPlaceId: json['kakaoPlaceId']?.toString(),
      jibunAddress: json['jibunAddress']?.toString(),
    );
  }
}

double _toDouble(Object? value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

double? _toNullableDouble(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}

int _toInt(Object? value) {
  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
