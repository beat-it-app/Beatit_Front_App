import 'package:flutter/foundation.dart';

@immutable
class MeetitDetailResponse {
  const MeetitDetailResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  final bool success;
  final int status;
  final String message;
  final MeetitDetailData data;

  factory MeetitDetailResponse.fromJson(Map<String, dynamic> json) {
    return MeetitDetailResponse(
      success: json['success'] as bool? ?? false,
      status: json['status'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: MeetitDetailData.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
    );
  }
}

@immutable
class MeetitDetailData {
  const MeetitDetailData({
    required this.meetitId,
    required this.title,
    required this.creatorId,
    required this.startTime,
    required this.endTime,
    required this.candidateDates,
    required this.totalInvitedCount,
    required this.respondedCount,
    required this.respondedParticipants,
    required this.entireMemberOptimalSlots,
    required this.maxMemberOptimalSlots,
    required this.maxOverlappingCount,
    required this.timetableGrid,
    required this.participant,
  });

  final int meetitId;
  final String title;
  final int creatorId;
  final String startTime;
  final String endTime;
  final List<String> candidateDates;
  final int totalInvitedCount;
  final int respondedCount;
  final List<MeetitRespondedParticipant> respondedParticipants;
  final List<MeetitOptimalSlot> entireMemberOptimalSlots;
  final List<MeetitOptimalSlot> maxMemberOptimalSlots;
  final int maxOverlappingCount;
  final List<MeetitTimetableSlot> timetableGrid;
  final bool participant;

  factory MeetitDetailData.fromJson(Map<String, dynamic> json) {
    return MeetitDetailData(
      meetitId: json['meetitId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      creatorId: json['creatorId'] as int? ?? 0,
      startTime: json['startTime'] as String? ?? '09:00',
      endTime: json['endTime'] as String? ?? '16:00',
      candidateDates: (json['candidateDates'] as List? ?? const <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      totalInvitedCount: json['totalInvitedCount'] as int? ?? 0,
      respondedCount: json['respondedCount'] as int? ?? 0,
      respondedParticipants:
          (json['respondedParticipants'] as List? ?? const <dynamic>[])
              .whereType<Map>()
              .map(
                (item) => MeetitRespondedParticipant.fromJson(
                  item.cast<String, dynamic>(),
                ),
              )
              .toList(growable: false),
      entireMemberOptimalSlots:
          (json['entireMemberOptimalSlots'] as List? ?? const <dynamic>[])
              .whereType<Map>()
              .map(
                (item) => MeetitOptimalSlot.fromJson(
                  item.cast<String, dynamic>(),
                ),
              )
              .toList(growable: false),
      maxMemberOptimalSlots:
          (json['maxMemberOptimalSlots'] as List? ?? const <dynamic>[])
              .whereType<Map>()
              .map(
                (item) => MeetitOptimalSlot.fromJson(
                  item.cast<String, dynamic>(),
                ),
              )
              .toList(growable: false),
      maxOverlappingCount: json['maxOverlappingCount'] as int? ?? 0,
      timetableGrid: (json['timetableGrid'] as List? ?? const <dynamic>[])
          .whereType<Map>()
          .map(
            (item) => MeetitTimetableSlot.fromJson(
              item.cast<String, dynamic>(),
            ),
          )
          .toList(growable: false),
      participant: json['participant'] as bool? ?? false,
    );
  }

  /// 백엔드 연동 전 화면 확인용 데이터입니다.
  /// 실제 API 처리 로직과는 분리된 테스트 전용 가짜 응답이며,
  /// 8/15 ~ 8/27 전체를 좌우 스크롤/드래그 테스트할 수 있도록 구성합니다.
  static final MeetitDetailData sample = _buildSample();

  static MeetitDetailData _buildSample() {
    const userIds = <int>[5, 6, 7, 8, 9];
    final candidateDates = List<String>.generate(
      13,
      (index) => '2026-08-${_twoDigits(15 + index)}',
      growable: false,
    );

    final timetableGrid = <MeetitTimetableSlot>[];

    for (var dayIndex = 0; dayIndex < candidateDates.length; dayIndex++) {
      final date = candidateDates[dayIndex];

      // 09:00 ~ 16:00, 30분 단위 = 하루 14셀
      for (var slotIndex = 0; slotIndex < 14; slotIndex++) {
        final totalMinutes = 9 * 60 + slotIndex * 30;
        final hour = totalMinutes ~/ 60;
        final minute = totalMinutes % 60;

        final isMaxOverlapSlot =
            (date == '2026-08-18' && (totalMinutes == 600 || totalMinutes == 630)) ||
            (date == '2026-08-22' && (totalMinutes == 840 || totalMinutes == 870)) ||
            (date == '2026-08-26' && (totalMinutes == 690 || totalMinutes == 720));

        final availableUserIds = <int>[];

        if (isMaxOverlapSlot) {
          availableUserIds.addAll(userIds);
        } else {
          // 화면 테스트용으로 날짜/시간마다 서로 다른 농도가 나오도록 만든 더미 응답입니다.
          if ((dayIndex + slotIndex) % 2 == 0) availableUserIds.add(5);
          if ((dayIndex + slotIndex * 2) % 3 != 0) availableUserIds.add(6);
          if ((dayIndex * 2 + slotIndex) % 4 < 2) availableUserIds.add(7);
          if ((dayIndex + slotIndex) % 5 <= 1) availableUserIds.add(8);
          if ((dayIndex * 3 + slotIndex) % 6 < 2) availableUserIds.add(9);

          // maxMemberOptimalSlots로 지정한 곳 외에는 5명 전원이 겹치지 않게 제한합니다.
          if (availableUserIds.length == userIds.length) {
            availableUserIds.removeLast();
          }
        }

        timetableGrid.add(
          MeetitTimetableSlot(
            slotStartTime:
                '${date}T${_twoDigits(hour)}:${_twoDigits(minute)}:00+09:00',
            availableUserIds: availableUserIds,
          ),
        );
      }
    }

    return MeetitDetailData(
      meetitId: 2,
      title: '8월 밋잇 시간 테스트',
      creatorId: 5,
      startTime: '09:00',
      endTime: '16:00',
      candidateDates: candidateDates,
      totalInvitedCount: 6,
      respondedCount: 5,
      respondedParticipants: const <MeetitRespondedParticipant>[
        MeetitRespondedParticipant(userId: 5, name: '김빗잇'),
        MeetitRespondedParticipant(userId: 6, name: '노영서'),
        MeetitRespondedParticipant(userId: 7, name: '김지원'),
        MeetitRespondedParticipant(userId: 8, name: '이현영'),
        MeetitRespondedParticipant(userId: 9, name: '송하은'),
      ],
      // 초대 6명 중 응답자는 5명이므로 전원 가능 시간은 없는 응답으로 둡니다.
      entireMemberOptimalSlots: const <MeetitOptimalSlot>[],
      maxMemberOptimalSlots: const <MeetitOptimalSlot>[
        MeetitOptimalSlot(
          date: '2026-08-18',
          startTime: '10:00',
          endTime: '11:00',
        ),
        MeetitOptimalSlot(
          date: '2026-08-22',
          startTime: '14:00',
          endTime: '15:00',
        ),
        MeetitOptimalSlot(
          date: '2026-08-26',
          startTime: '11:30',
          endTime: '12:30',
        ),
      ],
      maxOverlappingCount: 5,
      timetableGrid: timetableGrid,
      participant: true,
    );
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');

}

@immutable
class MeetitRespondedParticipant {
  const MeetitRespondedParticipant({
    required this.userId,
    required this.name,
  });

  final int userId;
  final String name;

  factory MeetitRespondedParticipant.fromJson(Map<String, dynamic> json) {
    return MeetitRespondedParticipant(
      userId: json['userId'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

@immutable
class MeetitOptimalSlot {
  const MeetitOptimalSlot({
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  final String date;
  final String startTime;
  final String endTime;

  factory MeetitOptimalSlot.fromJson(Map<String, dynamic> json) {
    return MeetitOptimalSlot(
      date: json['date'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
    );
  }
}

@immutable
class MeetitTimetableSlot {
  const MeetitTimetableSlot({
    required this.slotStartTime,
    required this.availableUserIds,
  });

  final String slotStartTime;
  final List<int> availableUserIds;

  factory MeetitTimetableSlot.fromJson(Map<String, dynamic> json) {
    return MeetitTimetableSlot(
      slotStartTime: json['slotStartTime'] as String? ?? '',
      availableUserIds: (json['availableUserIds'] as List? ?? const <dynamic>[])
          .whereType<int>()
          .toList(growable: false),
    );
  }
}
