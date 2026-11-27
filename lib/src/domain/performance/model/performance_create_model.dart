import 'package:image_picker/image_picker.dart';
import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';

/// 3단계 셋리스트 곡 정보
class SetlistSongItem {
  String songTitle;
  String artist;
  String notes; // 참여자 / 메모

  SetlistSongItem({this.songTitle = '', this.artist = '', this.notes = ''});

  Map<String, dynamic> toJson() => {
    'songTitle': songTitle,
    'artist': artist,
    'notes': notes,
  };
}

/// 3단계 팀별 셋리스트 그룹
class SetlistTeamGroup {
  String teamName;
  List<SetlistSongItem> songs;

  SetlistTeamGroup({required this.teamName, List<SetlistSongItem>? songs})
    : songs = songs ?? [SetlistSongItem()];

  Map<String, dynamic> toJson() => {
    'teamName': teamName,
    'songs': songs.map((s) => s.toJson()).toList(),
  };
}

/// 3단계 모바일 초대장 입력 데이터
class PerformanceInvitationData {
  final String invitationTitle;
  final String performanceTeamName;
  final DateTime startsAt;
  final LocationData location;
  final String invitationDescription;
  final bool enableSetlist;
  final List<SetlistTeamGroup> setlists;

  PerformanceInvitationData({
    required this.invitationTitle,
    required this.performanceTeamName,
    required this.startsAt,
    required this.location,
    required this.invitationDescription,
    required this.enableSetlist,
    required this.setlists,
  });
}

/// 전체 3단계 통합 등록 데이터
class PerformanceFullCreateData {
  final PerformanceInformation step1;
  final List<XFile> detailImages;
  final String detailDescription;
  final bool hasNoDetails;
  final PerformanceInvitationData step3;

  PerformanceFullCreateData({
    required this.step1,
    required this.detailImages,
    required this.detailDescription,
    required this.hasNoDetails,
    required this.step3,
  });

  /// 백엔드 multipart 요청의 JSON 객체 (performanceCreateRequest) 생성
  Map<String, dynamic> toRequestJson() {
    final pricesList = [];
    for (final entry in step1.ticketPrices.entries) {
      String type = 'ADVANCE';
      if (entry.key == PerformanceTicketType.onsite) type = 'ON_SITE';
      if (entry.key == PerformanceTicketType.general) type = 'GENERAL';

      final priceNum = int.tryParse(entry.value) ?? 0;
      pricesList.add({'priceType': type, 'price': priceNum});
    }

    if (step1.ticketTypes.contains(PerformanceTicketType.free)) {
      pricesList.add({'priceType': 'FREE', 'price': 0});
    }

    return {
      'title': step1.title,
      'description': step1.introduction,
      'performanceDateTime': step1.startsAt.toUtc().toIso8601String(),
      'locationId': step1.location.locationId,
      'placeName':
          step1.location.locationName ?? step1.location.roadAddress ?? '',
      'prices': pricesList,
      'bookingDeadline': step1.bookingClosesAt?.toUtc().toIso8601String(),
      'bookingLink': step1.bookingUrl,
      'hostName': step1.hostName,
      'hostContact': step1.hostContact,
      'hostLink': step1.hostContactType == PerformanceHostContactType.link
          ? step1.hostContact
          : null,
      'detailInfo': hasNoDetails ? '' : detailDescription,
    };
  }
}
