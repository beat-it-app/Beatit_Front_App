import 'dart:convert';

import 'package:beatit_front_app/src/domain/etc/model/location_search_result.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_data.dart';
import 'package:beatit_front_app/src/domain/performance/model/performance_demo_images.dart';
import 'package:image_picker/image_picker.dart';

/// 마이페이지 UI 확인 전용 데이터. 서버/등록 API에는 전송하지 않는다.
/// 더미 이미지를 메모리에서 읽으므로 파일 저장 권한/네트워크/asset 설정이 필요 없다.
class PerformanceDemoData {
  const PerformanceDemoData._({
    required this.performances,
    required this.mine,
    required this.draft,
  });

  final List<PerformanceSummary> performances;
  final List<PerformanceSummary> mine;
  final PerformanceCreateData draft;

  /// 나의 공연에서 '수정하기'를 테스트할 때 선택한 공연 내용으로 채운다.
  PerformanceCreateData draftFor(PerformanceSummary item) {
    final detail = PerformanceDetailData.fromSummary(item);
    if (detail.location == null || detail.posterFile == null ||
        detail.hostContactType == null) return draft;
    return PerformanceCreateData(
      information: PerformanceInformation(
        title: detail.title,
        startsAt: detail.startsAt,
        location: detail.location!,
        introduction: detail.introduction,
        poster: detail.posterFile,
        ticketTypes: detail.ticketTypes,
        ticketPrices: detail.ticketPrices,
        bookingClosesAt: detail.bookingClosesAt,
        bookingUrl: detail.bookingUrl,
        hostName: detail.hostName,
        hostContactType: detail.hostContactType!,
        hostContact: detail.hostContact,
      ),
      detailImages: detail.detailImageFiles,
      detailDescription: detail.detailDescription,
      hasNoDetails: detail.hasNoDetails,
    );
  }

  static Future<PerformanceDemoData>? _cached;

  static Future<PerformanceDemoData> load() =>
      _cached ??= _create();

  static Future<PerformanceDemoData> _create() async {
    final now = DateTime.now();
    DateTime at(int days, int hour) {
      final day = now.add(Duration(days: days));
      return DateTime(day.year, day.month, day.day, hour);
    }

    final poster1 = _demoImage('poster1');
    final poster2 = _demoImage('poster2');
    final poster3 = _demoImage('poster3');
    final poster4 = _demoImage('poster4');
    final detail1 = _demoImage('detail1');
    final detail2 = _demoImage('detail2');

    const place = LocationData(
      locationId: 0,
      locationName: '홍대 소극장 B2 (테스트)',
      roadAddress: '서울특별시 마포구 (더미 장소)',
    );

    final first = PerformanceDetailData(
      title: '잘나가는밴드 단독 공연',
      startsAt: at(14, 19),
      bookingClosesAt: at(12, 18),
      posterFile: poster1,
      teamName: '잘나가는밴드',
      introduction: '안녕하세요, 잘나가는밴드입니다.\n소중한 여러분을 위해 준비한 단독 공연에 초대합니다.',
      location: place,
      ticketTypes: const {PerformanceTicketType.advance, PerformanceTicketType.onsite},
      ticketPrices: const {
        PerformanceTicketType.advance: '5000',
        PerformanceTicketType.onsite: '6000',
      },
      bookingUrl: 'https://example.com/beatit-ticket',
      hostName: '잘나가는밴드',
      hostContactType: PerformanceHostContactType.phone,
      hostContact: '010-1234-5678',
      detailImageFiles: [detail1, detail2],
      detailDescription: '[공연 안내]\n본 공연은 대학 밴드 연합 공연입니다.\n입장 시 모바일 학생증 또는 예매 정보를 확인할 수 있습니다.\n\n[주의 사항]\n공연장 내 외부 음식물 반입은 제한됩니다.',
    );
    final second = PerformanceDetailData(
      title: '가을밤 음악회',
      startsAt: at(28, 18),
      bookingClosesAt: at(26, 20),
      posterFile: poster2,
      teamName: '어텀 사운드',
      introduction: '선선한 가을밤, 다양한 음악과 함께하는 작은 공연입니다.',
      location: place,
      ticketTypes: const {PerformanceTicketType.general},
      ticketPrices: const {PerformanceTicketType.general: '10000'},
      bookingUrl: 'https://example.com/autumn',
      hostName: '어텀 사운드',
      hostContactType: PerformanceHostContactType.link,
      hostContact: 'https://example.com/contact',
      detailImageFiles: [detail2],
      detailDescription: '공연 시간 18:00\n입장 시작 17:30\n공연 예매 관련 문의는 호스트 링크를 이용해주세요.',
    );
    final past = PerformanceDetailData(
      title: '뮤직 퍼레이드',
      startsAt: at(-21, 17),
      posterFile: poster3,
      teamName: 'BEAT IT 밴드',
      introduction: '함께해서 즐거웠던 지난 공연입니다.',
      location: place,
      ticketTypes: const {PerformanceTicketType.free},
      hostName: 'BEAT IT 밴드',
      hostContactType: PerformanceHostContactType.phone,
      hostContact: '010-0000-0000',
      hasNoDetails: true,
    );
    final fourth = PerformanceDetailData(
      title: '우리들의 첫 무대',
      startsAt: at(7, 16),
      posterFile: poster4,
      teamName: '첫무대',
      introduction: '첫 공연을 준비하는 팀의 무료 쇼케이스입니다.',
      location: place,
      ticketTypes: const {PerformanceTicketType.free},
      hostName: '첫무대',
      hostContactType: PerformanceHostContactType.link,
      hostContact: 'https://example.com/first-stage',
      detailImageFiles: [detail1],
      detailDescription: '무료 입장 공연입니다. 많은 관심 부탁드립니다.',
    );

    PerformanceSummary summary(PerformanceDetailData detail) =>
        PerformanceSummary(title: detail.title, startsAt: detail.startsAt, detail: detail);
    final all = [summary(first), summary(second), summary(past), summary(fourth)];

    final info = PerformanceInformation(
      title: first.title,
      startsAt: first.startsAt,
      location: place,
      introduction: first.introduction,
      poster: poster1,
      ticketTypes: first.ticketTypes,
      ticketPrices: first.ticketPrices,
      bookingClosesAt: first.bookingClosesAt,
      bookingUrl: first.bookingUrl,
      hostName: first.hostName,
      hostContactType: first.hostContactType!,
      hostContact: first.hostContact,
    );
    return PerformanceDemoData._(
      performances: all,
      mine: [all[0], all[2]],
      draft: PerformanceCreateData(
        information: info,
        detailImages: [detail1, detail2],
        detailDescription: first.detailDescription,
        hasNoDetails: false,
      ),
    );
  }

  /// XFile.fromData의 고유 경로는 위젯의 이미지 선택/삭제 키로만 사용한다.
  static XFile _demoImage(String name) => XFile.fromData(
    base64Decode(performanceDemoImageBase64[name]!),
    mimeType: 'image/jpeg',
    name: '$name.jpg',
    path: 'performance-demo://$name.jpg',
  );
}
