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
      status: (json['status'] as num?)?.toInt() ?? 0,
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
    required this.dateOnly,
    required this.startTime,
    required this.endTime,
    required this.candidateDates,
    required this.totalInvitedCount,
    required this.respondedCount,
    required this.isParticipant,
    required this.respondedParticipants,
    required this.entireMemberOptimalSlots,
    required this.maxMemberOptimalSlots,
    required this.maxOverlappingCount,
    required this.timetableGrid,
  });

  final int meetitId;
  final String title;
  final int creatorId;
  final bool dateOnly;

  /// 백엔드에서 dateOnly=true이면 null이다.
  final String? startTime;
  final String? endTime;

  final List<String> candidateDates;
  final int totalInvitedCount;
  final int respondedCount;
  final bool isParticipant;
  final List<MeetitRespondedParticipant> respondedParticipants;
  final List<MeetitOptimalSlot> entireMemberOptimalSlots;
  final List<MeetitOptimalSlot> maxMemberOptimalSlots;
  final int maxOverlappingCount;
  final List<MeetitTimetableSlot> timetableGrid;

  factory MeetitDetailData.fromJson(Map<String, dynamic> json) {
    return MeetitDetailData(
      meetitId: (json['meetitId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      creatorId: (json['creatorId'] as num?)?.toInt() ?? 0,
      dateOnly: json['dateOnly'] as bool? ?? false,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      candidateDates: (json['candidateDates'] as List? ?? const <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      totalInvitedCount: (json['totalInvitedCount'] as num?)?.toInt() ?? 0,
      respondedCount: (json['respondedCount'] as num?)?.toInt() ?? 0,
      isParticipant: json['isParticipant'] as bool? ?? false,
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
      maxOverlappingCount: (json['maxOverlappingCount'] as num?)?.toInt() ?? 0,
      timetableGrid: (json['timetableGrid'] as List? ?? const <dynamic>[])
          .whereType<Map>()
          .map(
            (item) => MeetitTimetableSlot.fromJson(
              item.cast<String, dynamic>(),
            ),
          )
          .toList(growable: false),
    );
  }

  /// 화면 단독 확인용 샘플 데이터.
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

      for (var slotIndex = 0; slotIndex < 14; slotIndex++) {
        final totalMinutes = 9 * 60 + slotIndex * 30;
        final hour = totalMinutes ~/ 60;
        final minute = totalMinutes % 60;

        final isMaxOverlapSlot =
            (date == '2026-08-18' &&
                (totalMinutes == 600 || totalMinutes == 630)) ||
            (date == '2026-08-22' &&
                (totalMinutes == 840 || totalMinutes == 870)) ||
            (date == '2026-08-26' &&
                (totalMinutes == 690 || totalMinutes == 720));

        final availableUserIds = <int>[];

        if (isMaxOverlapSlot) {
          availableUserIds.addAll(userIds);
        } else {
          if ((dayIndex + slotIndex) % 2 == 0) availableUserIds.add(5);
          if ((dayIndex + slotIndex * 2) % 3 != 0) availableUserIds.add(6);
          if ((dayIndex * 2 + slotIndex) % 4 < 2) availableUserIds.add(7);
          if ((dayIndex + slotIndex) % 5 <= 1) availableUserIds.add(8);
          if ((dayIndex * 3 + slotIndex) % 6 < 2) availableUserIds.add(9);

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
      dateOnly: false,
      startTime: '09:00',
      endTime: '16:00',
      candidateDates: candidateDates,
      totalInvitedCount: 6,
      respondedCount: 5,
      isParticipant: true,
      respondedParticipants: const <MeetitRespondedParticipant>[
        MeetitRespondedParticipant(userId: 5, name: '김빗잇'),
        MeetitRespondedParticipant(userId: 6, name: '노영서'),
        MeetitRespondedParticipant(userId: 7, name: '김지원'),
        MeetitRespondedParticipant(userId: 8, name: '이현영'),
        MeetitRespondedParticipant(userId: 9, name: '송하은'),
      ],
      entireMemberOptimalSlots: const <MeetitOptimalSlot>[],
      maxMemberOptimalSlots: const <MeetitOptimalSlot>[
        MeetitOptimalSlot(
          startDateTime: '2026-08-18T10:00:00+09:00',
          endDateTime: '2026-08-18T11:00:00+09:00',
        ),
        MeetitOptimalSlot(
          startDateTime: '2026-08-22T14:00:00+09:00',
          endDateTime: '2026-08-22T15:00:00+09:00',
        ),
        MeetitOptimalSlot(
          startDateTime: '2026-08-26T11:30:00+09:00',
          endDateTime: '2026-08-26T12:30:00+09:00',
        ),
      ],
      maxOverlappingCount: 5,
      timetableGrid: timetableGrid,
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
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

@immutable
class MeetitOptimalSlot {
  const MeetitOptimalSlot({
    required this.startDateTime,
    required this.endDateTime,
  });

  final String startDateTime;
  final String endDateTime;

  factory MeetitOptimalSlot.fromJson(Map<String, dynamic> json) {
    return MeetitOptimalSlot(
      startDateTime: json['startDateTime'] as String? ?? '',
      endDateTime: json['endDateTime'] as String? ?? '',
    );
  }

  /// 서버 OffsetDateTime의 timezone 변환을 하지 않고,
  /// 사용자가 선택한 달력상의 날짜/시각 그대로 비교하기 위한 값이다.
  DateTime? get wallClockStart => _parseWallClock(startDateTime);
  DateTime? get wallClockEnd => _parseWallClock(endDateTime);

  static DateTime? _parseWallClock(String value) {
    if (value.length < 16) return null;
    return DateTime.tryParse(value.substring(0, 16));
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
          .whereType<num>()
          .map((value) => value.toInt())
          .toList(growable: false),
    );
  }
}
