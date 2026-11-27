import 'package:freezed_annotation/freezed_annotation.dart';

part 'meetit_create_request.freezed.dart';
part 'meetit_create_request.g.dart';

@freezed
abstract class MeetitCreateRequest with _$MeetitCreateRequest {
  const factory MeetitCreateRequest({
    required String title,
    required List<String> candidateDates,
    String? startTime,
    String? endTime,
    required bool dateOnly,
    required List<int> participantUserIds,
  }) = _MeetitCreateRequest;

  factory MeetitCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$MeetitCreateRequestFromJson(json);
}
