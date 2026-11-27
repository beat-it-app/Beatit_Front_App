// lib/src/domain/performance/model/performance_data.dart

import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:image_picker/image_picker.dart';

/// 공연 목록의 표시 데이터. API 연결 시 이 타입으로 변환해서 전달한다.
class PerformanceSummary {
  const PerformanceSummary({
    required this.title,
    required this.startsAt,
    this.imageUrl,
    this.detail,
  });

  final String title;
  final DateTime startsAt;
  final String? imageUrl;
  final PerformanceDetailData? detail;
}

enum PerformanceTicketType { free, advance, onsite, general }

enum PerformanceHostContactType { phone, link }

/// 두 생성 화면 사이에서 값이 유실되지 않도록 전달하는 첫 단계의 입력값.
class PerformanceInformation {
  const PerformanceInformation({
    required this.title,
    required this.startsAt,
    required this.location,
    required this.introduction,
    required this.poster,
    required this.ticketTypes,
    required this.ticketPrices,
    required this.hostName,
    required this.hostContactType,
    required this.hostContact,
    this.bookingClosesAt,
    this.bookingUrl = '',
  });

  final String title;
  final DateTime startsAt;
  final LocationData location;
  final String introduction;
  final XFile? poster;
  final Set<PerformanceTicketType> ticketTypes;
  final Map<PerformanceTicketType, String> ticketPrices;
  final DateTime? bookingClosesAt;
  final String bookingUrl;
  final String hostName;
  final PerformanceHostContactType hostContactType;
  final String hostContact;
}

/// 실제 등록 API가 연결되면 이 데이터를 request로 매핑한다.
class PerformanceCreateData {
  const PerformanceCreateData({
    required this.information,
    required this.detailImages,
    required this.detailDescription,
    required this.hasNoDetails,
  });

  final PerformanceInformation information;
  final List<XFile> detailImages;
  final String detailDescription;
  final bool hasNoDetails;
}

/// 조회 API 응답을 이 화면 전용 데이터로 변환하여 전달한다.
class PerformanceDetailData {
  const PerformanceDetailData({
    this.performancePublicId, // 💡 추가: 공연 식별자
    required this.title,
    required this.startsAt,
    this.posterUrl,
    this.posterFile,
    this.teamName,
    this.introduction = '',
    this.location,
    this.locationName, // 💡 추가: 장소명
    this.roadAddress, // 💡 추가: 도로명 주소
    this.advancePrice, // 💡 추가: 예매 가격
    this.onSitePrice, // 💡 추가: 현매 가격
    this.ticketTypes = const <PerformanceTicketType>{},
    this.ticketPrices = const <PerformanceTicketType, String>{},
    this.bookingClosesAt,
    this.bookingUrl = '',
    this.hostName = '',
    this.hostContactType,
    this.hostContact = '',
    this.detailImageUrls = const [],
    this.detailImageFiles = const [],
    this.detailDescription = '',
    this.hasNoDetails = false,
  });

  final String? performancePublicId;
  final String title;
  final DateTime startsAt;
  final String? posterUrl;
  final XFile? posterFile;
  final String? teamName;
  final String introduction;
  final LocationData? location;
  final String? locationName;
  final String? roadAddress;
  final int? advancePrice;
  final int? onSitePrice;
  final Set<PerformanceTicketType> ticketTypes;
  final Map<PerformanceTicketType, String> ticketPrices;
  final DateTime? bookingClosesAt;
  final String bookingUrl;
  final String hostName;
  final PerformanceHostContactType? hostContactType;
  final String hostContact;
  final List<String> detailImageUrls;
  final List<XFile> detailImageFiles;
  final String detailDescription;
  final bool hasNoDetails;

  factory PerformanceDetailData.fromSummary(PerformanceSummary summary) =>
      summary.detail ??
      PerformanceDetailData(
        title: summary.title,
        startsAt: summary.startsAt,
        posterUrl: summary.imageUrl,
      );

  factory PerformanceDetailData.fromCreate(PerformanceCreateData created) {
    final info = created.information;
    return PerformanceDetailData(
      title: info.title,
      startsAt: info.startsAt,
      posterFile: info.poster,
      introduction: info.introduction,
      location: info.location,
      ticketTypes: info.ticketTypes,
      ticketPrices: info.ticketPrices,
      bookingClosesAt: info.bookingClosesAt,
      bookingUrl: info.bookingUrl,
      hostName: info.hostName,
      hostContactType: info.hostContactType,
      hostContact: info.hostContact,
      detailImageFiles: created.detailImages,
      detailDescription: created.detailDescription,
      hasNoDetails: created.hasNoDetails,
    );
  }
}
