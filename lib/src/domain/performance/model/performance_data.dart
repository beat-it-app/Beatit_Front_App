import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:image_picker/image_picker.dart';

/// 공연 목록의 표시 데이터. API 연결 시 이 타입으로 변환해서 전달한다.
class PerformanceSummary {
  const PerformanceSummary({
    required this.title,
    required this.startsAt,
    this.imageUrl,
  });

  final String title;
  final DateTime startsAt;
  final String? imageUrl;
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
