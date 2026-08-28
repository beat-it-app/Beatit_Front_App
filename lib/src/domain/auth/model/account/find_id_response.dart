import 'package:freezed_annotation/freezed_annotation.dart';

part 'find_id_response.freezed.dart';
part 'find_id_response.g.dart';

@freezed
abstract class FindIdentifierResponse with _$FindIdentifierResponse {
  const factory FindIdentifierResponse({
    required bool success,
    required int status,
    required String message,
    required FindIdentifierData data,
  }) = _FindIdentifierResponse;

  factory FindIdentifierResponse.fromJson(Map<String, dynamic> json) =>
      _$FindIdentifierResponseFromJson(json);
}

@freezed
abstract class FindIdentifierData with _$FindIdentifierData {
  const factory FindIdentifierData({
    required String identifier,
  }) = _FindIdentifierData;

  factory FindIdentifierData.fromJson(Map<String, dynamic> json) =>
      _$FindIdentifierDataFromJson(json);
}
