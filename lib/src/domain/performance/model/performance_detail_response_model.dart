// lib/src/domain/performance/model/performance_detail_response_model.dart

import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_invitation_view_model.dart';

class PerformanceLocation {
  final int locationId;
  final String locationName;
  final String roadAddress;
  final double? latitude;
  final double? longitude;
  final String? mapUrl;
  final String? phone;
  final String? kakaoPlaceId;
  final String? jibunAddress;

  PerformanceLocation({
    required this.locationId,
    required this.locationName,
    required this.roadAddress,
    this.latitude,
    this.longitude,
    this.mapUrl,
    this.phone,
    this.kakaoPlaceId,
    this.jibunAddress,
  });

  factory PerformanceLocation.fromJson(Map<String, dynamic> json) {
    return PerformanceLocation(
      locationId: (json['locationId'] as num?)?.toInt() ?? 0,
      locationName: json['locationName']?.toString() ?? '',
      roadAddress: json['roadAddress']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      mapUrl: json['mapUrl']?.toString(),
      phone: json['phone']?.toString(),
      kakaoPlaceId: json['kakaoPlaceId']?.toString(),
      jibunAddress: json['jibunAddress']?.toString(),
    );
  }
}

class PerformanceFile {
  final int fileId;
  final String originalFileName;
  final String cdnUrl;
  final String? previewCdnUrl;
  final String fileType;
  final int displayOrder;

  PerformanceFile({
    required this.fileId,
    required this.originalFileName,
    required this.cdnUrl,
    this.previewCdnUrl,
    required this.fileType,
    required this.displayOrder,
  });

  factory PerformanceFile.fromJson(Map<String, dynamic> json) {
    return PerformanceFile(
      fileId: (json['fileId'] as num?)?.toInt() ?? 0,
      originalFileName: json['originalFileName']?.toString() ?? '',
      cdnUrl: json['cdnUrl']?.toString() ?? '',
      previewCdnUrl: json['previewCdnUrl']?.toString(),
      fileType: json['fileType']?.toString() ?? '',
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
    );
  }
}

class PerformancePrice {
  final String priceType;
  final int price;

  PerformancePrice({required this.priceType, required this.price});

  factory PerformancePrice.fromJson(Map<String, dynamic> json) {
    return PerformancePrice(
      priceType: json['priceType']?.toString() ?? '',
      // 💡 0.0(double) 또는 0(int) 모두 안전하게 int 변환
      price: (json['price'] as num?)?.toInt() ?? 0,
    );
  }
}

class PerformanceDetailModel {
  final int performanceId;
  final String performancePublicId;
  final int teamId;
  final String teamName;
  final int createdUserId;
  final bool isWriter;
  final String title;
  final String description;
  final DateTime performanceDateTime;
  final PerformanceLocation? location;
  final String placeName;
  final PerformanceFile? poster;
  final List<PerformancePrice> prices;
  final DateTime? bookingDeadline;
  final String? bookingLink;
  final String hostName;
  final String hostContact;
  final String? hostLink;
  final List<PerformanceFile> detailImages;
  final String detailInfo;
  final String performanceStatus;
  final PerformanceInvitationCard? invitationCard;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PerformanceDetailModel({
    required this.performanceId,
    required this.performancePublicId,
    required this.teamId,
    required this.teamName,
    required this.createdUserId,
    this.isWriter = false,
    required this.title,
    required this.description,
    required this.performanceDateTime,
    this.location,
    required this.placeName,
    this.poster,
    required this.prices,
    this.bookingDeadline,
    this.bookingLink,
    required this.hostName,
    required this.hostContact,
    this.hostLink,
    required this.detailImages,
    required this.detailInfo,
    required this.performanceStatus,
    this.invitationCard,
    this.createdAt,
    this.updatedAt,
  });

  factory PerformanceDetailModel.fromJson(Map<String, dynamic> json) {
    final List<PerformancePrice> parsedPrices = [];
    final rawPrices = json['prices'];
    if (rawPrices is List) {
      for (final element in rawPrices) {
        if (element is List) {
          for (final inner in element) {
            if (inner is Map<String, dynamic>) {
              parsedPrices.add(PerformancePrice.fromJson(inner));
            }
          }
        } else if (element is Map<String, dynamic>) {
          parsedPrices.add(PerformancePrice.fromJson(element));
        }
      }
    }

    final List<PerformanceFile> parsedDetailImages = [];
    final rawDetailImages = json['detailImages'];
    if (rawDetailImages is List) {
      for (final item in rawDetailImages) {
        if (item is Map<String, dynamic>) {
          parsedDetailImages.add(PerformanceFile.fromJson(item));
        }
      }
    }

    return PerformanceDetailModel(
      performanceId: (json['performanceId'] as num?)?.toInt() ?? 0,
      performancePublicId: json['performancePublicId']?.toString() ?? '',
      teamId: (json['teamId'] as num?)?.toInt() ?? 0,
      teamName: json['teamName']?.toString() ?? '',
      createdUserId: (json['createdUserId'] as num?)?.toInt() ?? 0,
      isWriter: json['isWriter'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      performanceDateTime: json['performanceDateTime'] != null
          ? (DateTime.tryParse(
                  json['performanceDateTime'].toString(),
                )?.toLocal() ??
                DateTime.now())
          : DateTime.now(),
      location: json['location'] is Map<String, dynamic>
          ? PerformanceLocation.fromJson(
              json['location'] as Map<String, dynamic>,
            )
          : null,
      placeName: json['placeName']?.toString() ?? '',
      poster: json['poster'] is Map<String, dynamic>
          ? PerformanceFile.fromJson(json['poster'] as Map<String, dynamic>)
          : null,
      prices: parsedPrices,
      bookingDeadline: json['bookingDeadline'] != null
          ? DateTime.tryParse(json['bookingDeadline'].toString())?.toLocal()
          : null,
      bookingLink: json['bookingLink']?.toString(),
      hostName: json['hostName']?.toString() ?? '',
      hostContact: json['hostContact']?.toString() ?? '',
      hostLink: json['hostLink']?.toString(),
      detailImages: parsedDetailImages,
      detailInfo: json['detailInfo']?.toString() ?? '',
      performanceStatus: json['performanceStatus']?.toString() ?? 'UPCOMING',
      invitationCard: json['invitationCard'] is Map
          ? PerformanceInvitationCard.fromJson(
              Map<String, dynamic>.from(json['invitationCard'] as Map),
            )
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())?.toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())?.toLocal()
          : null,
    );
  }
}

extension PerformanceDetailModelMapper on PerformanceDetailModel {
  PerformanceDetailData toDetailData() {
    // 1. 티켓 정보 매핑
    final Set<PerformanceTicketType> ticketTypes = {};
    final Map<PerformanceTicketType, String> ticketPrices = {};

    for (final p in prices) {
      final type = p.priceType.toUpperCase();
      final priceStr = p.price.toString();

      if (type == 'FREE') {
        ticketTypes.add(PerformanceTicketType.free);
        ticketPrices[PerformanceTicketType.free] = '0';
      } else if (type == 'ADVANCE') {
        ticketTypes.add(PerformanceTicketType.advance);
        ticketPrices[PerformanceTicketType.advance] = priceStr;
      } else if (type == 'ON_SITE') {
        ticketTypes.add(PerformanceTicketType.onsite);
        ticketPrices[PerformanceTicketType.onsite] = priceStr;
      } else if (type == 'GENERAL') {
        ticketTypes.add(PerformanceTicketType.general);
        ticketPrices[PerformanceTicketType.general] = priceStr;
      }
    }

    // 2. 위치 및 지도 정보 매핑
    LocationData? locationData;
    if (location != null) {
      locationData = LocationData(
        locationId: location!.locationId,
        locationName: location!.locationName.isNotEmpty
            ? location!.locationName
            : placeName,
        roadAddress: location!.roadAddress,
        jibunAddress: location!.jibunAddress,
        latitude: location!.latitude,
        longitude: location!.longitude,
      );
    } else if (placeName.isNotEmpty) {
      locationData = LocationData(locationId: 0, locationName: placeName);
    }

    // 3. 호스트 연락처 타입 판별
    PerformanceHostContactType hostType = PerformanceHostContactType.phone;
    if (hostLink != null && hostLink!.trim().isNotEmpty) {
      hostType = PerformanceHostContactType.link;
    }

    return PerformanceDetailData(
      performancePublicId: performancePublicId,
      title: title,
      teamName: teamName,
      // 💡 팀 이름 전달
      startsAt: performanceDateTime,
      introduction: description,
      // 💡 공연 소개 전달
      location: locationData,
      // 💡 지도 표시용 LocationData 전달
      locationName: location?.locationName ?? placeName,
      roadAddress: location?.roadAddress,
      posterUrl: poster?.cdnUrl,
      ticketTypes: ticketTypes,
      // 💡 티켓 Set 전달
      ticketPrices: ticketPrices,
      // 💡 티켓 가격 Map 전달
      bookingClosesAt: bookingDeadline,
      bookingUrl: bookingLink ?? '',
      hostName: hostName,
      hostContactType: hostType,
      hostContact: (hostLink != null && hostLink!.isNotEmpty)
          ? hostLink!
          : hostContact,
      detailImageUrls: detailImages.map((e) => e.cdnUrl).toList(),
      detailDescription: detailInfo,
      hasNoDetails: detailInfo.trim().isEmpty && detailImages.isEmpty,
    );
  }
}
