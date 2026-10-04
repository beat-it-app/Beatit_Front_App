import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_create_request.freezed.dart';

part 'team_create_request.g.dart';

@freezed
abstract class TeamCreateRequest with _$TeamCreateRequest {
  const factory TeamCreateRequest({
    required String teamName,
    required String teamType,
    String? description,
    String? establishedOn,
    String? teamImageUrl,
  }) = _TeamCreateRequest;

  factory TeamCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$TeamCreateRequestFromJson(json);
}
