// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_detail_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleDetailResponse {

 bool get success; int get status; String get message; ScheduleDetailData get data;
/// Create a copy of ScheduleDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDetailResponseCopyWith<ScheduleDetailResponse> get copyWith => _$ScheduleDetailResponseCopyWithImpl<ScheduleDetailResponse>(this as ScheduleDetailResponse, _$identity);

  /// Serializes this ScheduleDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleDetailResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDetailResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleDetailResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as ScheduleDetailResponse;
  return 'ScheduleDetailResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $ScheduleDetailResponseCopyWith<$Res>  {
  factory $ScheduleDetailResponseCopyWith(ScheduleDetailResponse value, $Res Function(ScheduleDetailResponse) _then) = _$ScheduleDetailResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, ScheduleDetailData data
});


$ScheduleDetailDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ScheduleDetailResponseCopyWithImpl<$Res>
    implements $ScheduleDetailResponseCopyWith<$Res> {
  _$ScheduleDetailResponseCopyWithImpl(this._self, this._then);

  final ScheduleDetailResponse _self;
  final $Res Function(ScheduleDetailResponse) _then;

/// Create a copy of ScheduleDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(ScheduleDetailResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ScheduleDetailData,
  ));
}
/// Create a copy of ScheduleDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleDetailDataCopyWith<$Res> get data {
  
  return $ScheduleDetailDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleDetailResponse].
extension ScheduleDetailResponsePatterns on ScheduleDetailResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleDetailResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  ScheduleDetailData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleDetailResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  ScheduleDetailData data)  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailResponse():
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  ScheduleDetailData data)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleDetailResponse implements ScheduleDetailResponse {
  const _ScheduleDetailResponse({required this.success, required this.status, required this.message, required this.data});
  factory _ScheduleDetailResponse.fromJson(Map<String, dynamic> json) => _$ScheduleDetailResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  ScheduleDetailData data;

/// Create a copy of ScheduleDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDetailResponseCopyWith<_ScheduleDetailResponse> get copyWith => __$ScheduleDetailResponseCopyWithImpl<_ScheduleDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleDetailResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'ScheduleDetailResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDetailResponseCopyWith<$Res> implements $ScheduleDetailResponseCopyWith<$Res> {
  factory _$ScheduleDetailResponseCopyWith(_ScheduleDetailResponse value, $Res Function(_ScheduleDetailResponse) _then) = __$ScheduleDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, ScheduleDetailData data
});


@override $ScheduleDetailDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ScheduleDetailResponseCopyWithImpl<$Res>
    implements _$ScheduleDetailResponseCopyWith<$Res> {
  __$ScheduleDetailResponseCopyWithImpl(this._self, this._then);

  final _ScheduleDetailResponse _self;
  final $Res Function(_ScheduleDetailResponse) _then;

/// Create a copy of ScheduleDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_ScheduleDetailResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ScheduleDetailData,
  ));
}

/// Create a copy of ScheduleDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleDetailDataCopyWith<$Res> get data {
  
  return $ScheduleDetailDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ScheduleDetailData {

 int get scheduleId; int get teamId; int get userId; int? get locationId; String get title; String? get content; DateTime get startsAt; DateTime get endsAt; DateTime get createdAt; DateTime get updatedAt; List<ScheduleDetailParticipant> get participants; List<ScheduleDetailFile> get files;/// 현재 첨부된 백엔드 ScheduleDetailResponse에는 아직 없는 필드입니다.
/// 백엔드가 상세 조회 응답에 musics를 추가하면 프론트 수정 없이 표시할 수 있도록
/// 기본값을 빈 목록으로 둡니다.
 List<ScheduleDetailMusic> get musics;
/// Create a copy of ScheduleDetailData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDetailDataCopyWith<ScheduleDetailData> get copyWith => _$ScheduleDetailDataCopyWithImpl<ScheduleDetailData>(this as ScheduleDetailData, _$identity);

  /// Serializes this ScheduleDetailData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleDetailData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDetailData&&(identical(other.scheduleId, _this.scheduleId) || other.scheduleId == _this.scheduleId)&&(identical(other.teamId, _this.teamId) || other.teamId == _this.teamId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.locationId, _this.locationId) || other.locationId == _this.locationId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.participants, _this.participants)&&const DeepCollectionEquality().equals(other.files, _this.files)&&const DeepCollectionEquality().equals(other.musics, _this.musics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleDetailData;
  return Object.hash(runtimeType,_this.scheduleId,_this.teamId,_this.userId,_this.locationId,_this.title,_this.content,_this.startsAt,_this.endsAt,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.participants),const DeepCollectionEquality().hash(_this.files),const DeepCollectionEquality().hash(_this.musics));
}

@override
String toString() {
  final _this = this as ScheduleDetailData;
  return 'ScheduleDetailData(scheduleId: ${_this.scheduleId}, teamId: ${_this.teamId}, userId: ${_this.userId}, locationId: ${_this.locationId}, title: ${_this.title}, content: ${_this.content}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, participants: ${_this.participants}, files: ${_this.files}, musics: ${_this.musics})';
}


}

/// @nodoc
abstract mixin class $ScheduleDetailDataCopyWith<$Res>  {
  factory $ScheduleDetailDataCopyWith(ScheduleDetailData value, $Res Function(ScheduleDetailData) _then) = _$ScheduleDetailDataCopyWithImpl;
@useResult
$Res call({
 int scheduleId, int teamId, int userId, int? locationId, String title, String? content, DateTime startsAt, DateTime endsAt, DateTime createdAt, DateTime updatedAt, List<ScheduleDetailParticipant> participants, List<ScheduleDetailFile> files, List<ScheduleDetailMusic> musics
});




}
/// @nodoc
class _$ScheduleDetailDataCopyWithImpl<$Res>
    implements $ScheduleDetailDataCopyWith<$Res> {
  _$ScheduleDetailDataCopyWithImpl(this._self, this._then);

  final ScheduleDetailData _self;
  final $Res Function(ScheduleDetailData) _then;

/// Create a copy of ScheduleDetailData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleId = null,Object? teamId = null,Object? userId = null,Object? locationId = freezed,Object? title = null,Object? content = freezed,Object? startsAt = null,Object? endsAt = null,Object? createdAt = null,Object? updatedAt = null,Object? participants = null,Object? files = null,Object? musics = null,}) {
  return _then(ScheduleDetailData(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<ScheduleDetailParticipant>,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<ScheduleDetailFile>,musics: null == musics ? _self.musics : musics // ignore: cast_nullable_to_non_nullable
as List<ScheduleDetailMusic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleDetailData].
extension ScheduleDetailDataPatterns on ScheduleDetailData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleDetailData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleDetailData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleDetailData value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleDetailData value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scheduleId,  int teamId,  int userId,  int? locationId,  String title,  String? content,  DateTime startsAt,  DateTime endsAt,  DateTime createdAt,  DateTime updatedAt,  List<ScheduleDetailParticipant> participants,  List<ScheduleDetailFile> files,  List<ScheduleDetailMusic> musics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleDetailData() when $default != null:
return $default(_that.scheduleId,_that.teamId,_that.userId,_that.locationId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.createdAt,_that.updatedAt,_that.participants,_that.files,_that.musics);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scheduleId,  int teamId,  int userId,  int? locationId,  String title,  String? content,  DateTime startsAt,  DateTime endsAt,  DateTime createdAt,  DateTime updatedAt,  List<ScheduleDetailParticipant> participants,  List<ScheduleDetailFile> files,  List<ScheduleDetailMusic> musics)  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailData():
return $default(_that.scheduleId,_that.teamId,_that.userId,_that.locationId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.createdAt,_that.updatedAt,_that.participants,_that.files,_that.musics);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scheduleId,  int teamId,  int userId,  int? locationId,  String title,  String? content,  DateTime startsAt,  DateTime endsAt,  DateTime createdAt,  DateTime updatedAt,  List<ScheduleDetailParticipant> participants,  List<ScheduleDetailFile> files,  List<ScheduleDetailMusic> musics)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailData() when $default != null:
return $default(_that.scheduleId,_that.teamId,_that.userId,_that.locationId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.createdAt,_that.updatedAt,_that.participants,_that.files,_that.musics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleDetailData implements ScheduleDetailData {
  const _ScheduleDetailData({required this.scheduleId, required this.teamId, required this.userId, this.locationId, required this.title, this.content, required this.startsAt, required this.endsAt, required this.createdAt, required this.updatedAt,  List<ScheduleDetailParticipant> participants = const <ScheduleDetailParticipant>[],  List<ScheduleDetailFile> files = const <ScheduleDetailFile>[],  List<ScheduleDetailMusic> musics = const <ScheduleDetailMusic>[]}): _participants = participants,_files = files,_musics = musics;
  factory _ScheduleDetailData.fromJson(Map<String, dynamic> json) => _$ScheduleDetailDataFromJson(json);

@override final  int scheduleId;
@override final  int teamId;
@override final  int userId;
@override final  int? locationId;
@override final  String title;
@override final  String? content;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<ScheduleDetailParticipant> _participants;
@override@JsonKey() List<ScheduleDetailParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

 final  List<ScheduleDetailFile> _files;
@override@JsonKey() List<ScheduleDetailFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

/// 현재 첨부된 백엔드 ScheduleDetailResponse에는 아직 없는 필드입니다.
/// 백엔드가 상세 조회 응답에 musics를 추가하면 프론트 수정 없이 표시할 수 있도록
/// 기본값을 빈 목록으로 둡니다.
 final  List<ScheduleDetailMusic> _musics;
/// 현재 첨부된 백엔드 ScheduleDetailResponse에는 아직 없는 필드입니다.
/// 백엔드가 상세 조회 응답에 musics를 추가하면 프론트 수정 없이 표시할 수 있도록
/// 기본값을 빈 목록으로 둡니다.
@override@JsonKey() List<ScheduleDetailMusic> get musics {
  if (_musics is EqualUnmodifiableListView) return _musics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_musics);
}


/// Create a copy of ScheduleDetailData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDetailDataCopyWith<_ScheduleDetailData> get copyWith => __$ScheduleDetailDataCopyWithImpl<_ScheduleDetailData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleDetailDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleDetailData&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.participants, _participants)&&const DeepCollectionEquality().equals(other.files, _files)&&const DeepCollectionEquality().equals(other.musics, _musics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,scheduleId,teamId,userId,locationId,title,content,startsAt,endsAt,createdAt,updatedAt,const DeepCollectionEquality().hash(_participants),const DeepCollectionEquality().hash(_files),const DeepCollectionEquality().hash(_musics));
}

@override
String toString() {
    return 'ScheduleDetailData(scheduleId: $scheduleId, teamId: $teamId, userId: $userId, locationId: $locationId, title: $title, content: $content, startsAt: $startsAt, endsAt: $endsAt, createdAt: $createdAt, updatedAt: $updatedAt, participants: $participants, files: $files, musics: $musics)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDetailDataCopyWith<$Res> implements $ScheduleDetailDataCopyWith<$Res> {
  factory _$ScheduleDetailDataCopyWith(_ScheduleDetailData value, $Res Function(_ScheduleDetailData) _then) = __$ScheduleDetailDataCopyWithImpl;
@override @useResult
$Res call({
 int scheduleId, int teamId, int userId, int? locationId, String title, String? content, DateTime startsAt, DateTime endsAt, DateTime createdAt, DateTime updatedAt, List<ScheduleDetailParticipant> participants, List<ScheduleDetailFile> files, List<ScheduleDetailMusic> musics
});




}
/// @nodoc
class __$ScheduleDetailDataCopyWithImpl<$Res>
    implements _$ScheduleDetailDataCopyWith<$Res> {
  __$ScheduleDetailDataCopyWithImpl(this._self, this._then);

  final _ScheduleDetailData _self;
  final $Res Function(_ScheduleDetailData) _then;

/// Create a copy of ScheduleDetailData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleId = null,Object? teamId = null,Object? userId = null,Object? locationId = freezed,Object? title = null,Object? content = freezed,Object? startsAt = null,Object? endsAt = null,Object? createdAt = null,Object? updatedAt = null,Object? participants = null,Object? files = null,Object? musics = null,}) {
  return _then(_ScheduleDetailData(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<ScheduleDetailParticipant>,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<ScheduleDetailFile>,musics: null == musics ? _self._musics : musics // ignore: cast_nullable_to_non_nullable
as List<ScheduleDetailMusic>,
  ));
}


}


/// @nodoc
mixin _$ScheduleDetailParticipant {

 int get scheduleParticipantId; int get userId;
/// Create a copy of ScheduleDetailParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDetailParticipantCopyWith<ScheduleDetailParticipant> get copyWith => _$ScheduleDetailParticipantCopyWithImpl<ScheduleDetailParticipant>(this as ScheduleDetailParticipant, _$identity);

  /// Serializes this ScheduleDetailParticipant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleDetailParticipant;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDetailParticipant&&(identical(other.scheduleParticipantId, _this.scheduleParticipantId) || other.scheduleParticipantId == _this.scheduleParticipantId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleDetailParticipant;
  return Object.hash(runtimeType,_this.scheduleParticipantId,_this.userId);
}

@override
String toString() {
  final _this = this as ScheduleDetailParticipant;
  return 'ScheduleDetailParticipant(scheduleParticipantId: ${_this.scheduleParticipantId}, userId: ${_this.userId})';
}


}

/// @nodoc
abstract mixin class $ScheduleDetailParticipantCopyWith<$Res>  {
  factory $ScheduleDetailParticipantCopyWith(ScheduleDetailParticipant value, $Res Function(ScheduleDetailParticipant) _then) = _$ScheduleDetailParticipantCopyWithImpl;
@useResult
$Res call({
 int scheduleParticipantId, int userId
});




}
/// @nodoc
class _$ScheduleDetailParticipantCopyWithImpl<$Res>
    implements $ScheduleDetailParticipantCopyWith<$Res> {
  _$ScheduleDetailParticipantCopyWithImpl(this._self, this._then);

  final ScheduleDetailParticipant _self;
  final $Res Function(ScheduleDetailParticipant) _then;

/// Create a copy of ScheduleDetailParticipant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleParticipantId = null,Object? userId = null,}) {
  return _then(ScheduleDetailParticipant(
scheduleParticipantId: null == scheduleParticipantId ? _self.scheduleParticipantId : scheduleParticipantId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleDetailParticipant].
extension ScheduleDetailParticipantPatterns on ScheduleDetailParticipant {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleDetailParticipant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleDetailParticipant() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleDetailParticipant value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailParticipant():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleDetailParticipant value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailParticipant() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scheduleParticipantId,  int userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleDetailParticipant() when $default != null:
return $default(_that.scheduleParticipantId,_that.userId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scheduleParticipantId,  int userId)  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailParticipant():
return $default(_that.scheduleParticipantId,_that.userId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scheduleParticipantId,  int userId)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailParticipant() when $default != null:
return $default(_that.scheduleParticipantId,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleDetailParticipant implements ScheduleDetailParticipant {
  const _ScheduleDetailParticipant({required this.scheduleParticipantId, required this.userId});
  factory _ScheduleDetailParticipant.fromJson(Map<String, dynamic> json) => _$ScheduleDetailParticipantFromJson(json);

@override final  int scheduleParticipantId;
@override final  int userId;

/// Create a copy of ScheduleDetailParticipant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDetailParticipantCopyWith<_ScheduleDetailParticipant> get copyWith => __$ScheduleDetailParticipantCopyWithImpl<_ScheduleDetailParticipant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleDetailParticipantToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleDetailParticipant&&(identical(other.scheduleParticipantId, scheduleParticipantId) || other.scheduleParticipantId == scheduleParticipantId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,scheduleParticipantId,userId);
}

@override
String toString() {
    return 'ScheduleDetailParticipant(scheduleParticipantId: $scheduleParticipantId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDetailParticipantCopyWith<$Res> implements $ScheduleDetailParticipantCopyWith<$Res> {
  factory _$ScheduleDetailParticipantCopyWith(_ScheduleDetailParticipant value, $Res Function(_ScheduleDetailParticipant) _then) = __$ScheduleDetailParticipantCopyWithImpl;
@override @useResult
$Res call({
 int scheduleParticipantId, int userId
});




}
/// @nodoc
class __$ScheduleDetailParticipantCopyWithImpl<$Res>
    implements _$ScheduleDetailParticipantCopyWith<$Res> {
  __$ScheduleDetailParticipantCopyWithImpl(this._self, this._then);

  final _ScheduleDetailParticipant _self;
  final $Res Function(_ScheduleDetailParticipant) _then;

/// Create a copy of ScheduleDetailParticipant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleParticipantId = null,Object? userId = null,}) {
  return _then(_ScheduleDetailParticipant(
scheduleParticipantId: null == scheduleParticipantId ? _self.scheduleParticipantId : scheduleParticipantId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ScheduleDetailFile {

 int get fileId; String get originalFileName; String get cdnUrl;
/// Create a copy of ScheduleDetailFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDetailFileCopyWith<ScheduleDetailFile> get copyWith => _$ScheduleDetailFileCopyWithImpl<ScheduleDetailFile>(this as ScheduleDetailFile, _$identity);

  /// Serializes this ScheduleDetailFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleDetailFile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDetailFile&&(identical(other.fileId, _this.fileId) || other.fileId == _this.fileId)&&(identical(other.originalFileName, _this.originalFileName) || other.originalFileName == _this.originalFileName)&&(identical(other.cdnUrl, _this.cdnUrl) || other.cdnUrl == _this.cdnUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleDetailFile;
  return Object.hash(runtimeType,_this.fileId,_this.originalFileName,_this.cdnUrl);
}

@override
String toString() {
  final _this = this as ScheduleDetailFile;
  return 'ScheduleDetailFile(fileId: ${_this.fileId}, originalFileName: ${_this.originalFileName}, cdnUrl: ${_this.cdnUrl})';
}


}

/// @nodoc
abstract mixin class $ScheduleDetailFileCopyWith<$Res>  {
  factory $ScheduleDetailFileCopyWith(ScheduleDetailFile value, $Res Function(ScheduleDetailFile) _then) = _$ScheduleDetailFileCopyWithImpl;
@useResult
$Res call({
 int fileId, String originalFileName, String cdnUrl
});




}
/// @nodoc
class _$ScheduleDetailFileCopyWithImpl<$Res>
    implements $ScheduleDetailFileCopyWith<$Res> {
  _$ScheduleDetailFileCopyWithImpl(this._self, this._then);

  final ScheduleDetailFile _self;
  final $Res Function(ScheduleDetailFile) _then;

/// Create a copy of ScheduleDetailFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? originalFileName = null,Object? cdnUrl = null,}) {
  return _then(ScheduleDetailFile(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as int,originalFileName: null == originalFileName ? _self.originalFileName : originalFileName // ignore: cast_nullable_to_non_nullable
as String,cdnUrl: null == cdnUrl ? _self.cdnUrl : cdnUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleDetailFile].
extension ScheduleDetailFilePatterns on ScheduleDetailFile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleDetailFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleDetailFile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleDetailFile value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailFile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleDetailFile value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailFile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fileId,  String originalFileName,  String cdnUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleDetailFile() when $default != null:
return $default(_that.fileId,_that.originalFileName,_that.cdnUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fileId,  String originalFileName,  String cdnUrl)  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailFile():
return $default(_that.fileId,_that.originalFileName,_that.cdnUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fileId,  String originalFileName,  String cdnUrl)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailFile() when $default != null:
return $default(_that.fileId,_that.originalFileName,_that.cdnUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleDetailFile implements ScheduleDetailFile {
  const _ScheduleDetailFile({required this.fileId, required this.originalFileName, required this.cdnUrl});
  factory _ScheduleDetailFile.fromJson(Map<String, dynamic> json) => _$ScheduleDetailFileFromJson(json);

@override final  int fileId;
@override final  String originalFileName;
@override final  String cdnUrl;

/// Create a copy of ScheduleDetailFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDetailFileCopyWith<_ScheduleDetailFile> get copyWith => __$ScheduleDetailFileCopyWithImpl<_ScheduleDetailFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleDetailFileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleDetailFile&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.originalFileName, originalFileName) || other.originalFileName == originalFileName)&&(identical(other.cdnUrl, cdnUrl) || other.cdnUrl == cdnUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,fileId,originalFileName,cdnUrl);
}

@override
String toString() {
    return 'ScheduleDetailFile(fileId: $fileId, originalFileName: $originalFileName, cdnUrl: $cdnUrl)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDetailFileCopyWith<$Res> implements $ScheduleDetailFileCopyWith<$Res> {
  factory _$ScheduleDetailFileCopyWith(_ScheduleDetailFile value, $Res Function(_ScheduleDetailFile) _then) = __$ScheduleDetailFileCopyWithImpl;
@override @useResult
$Res call({
 int fileId, String originalFileName, String cdnUrl
});




}
/// @nodoc
class __$ScheduleDetailFileCopyWithImpl<$Res>
    implements _$ScheduleDetailFileCopyWith<$Res> {
  __$ScheduleDetailFileCopyWithImpl(this._self, this._then);

  final _ScheduleDetailFile _self;
  final $Res Function(_ScheduleDetailFile) _then;

/// Create a copy of ScheduleDetailFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? originalFileName = null,Object? cdnUrl = null,}) {
  return _then(_ScheduleDetailFile(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as int,originalFileName: null == originalFileName ? _self.originalFileName : originalFileName // ignore: cast_nullable_to_non_nullable
as String,cdnUrl: null == cdnUrl ? _self.cdnUrl : cdnUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ScheduleDetailMusic {

 int get musicId; String? get musicTitle; String? get musicArtist; String? get musicPreviewUrl;
/// Create a copy of ScheduleDetailMusic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDetailMusicCopyWith<ScheduleDetailMusic> get copyWith => _$ScheduleDetailMusicCopyWithImpl<ScheduleDetailMusic>(this as ScheduleDetailMusic, _$identity);

  /// Serializes this ScheduleDetailMusic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleDetailMusic;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDetailMusic&&(identical(other.musicId, _this.musicId) || other.musicId == _this.musicId)&&(identical(other.musicTitle, _this.musicTitle) || other.musicTitle == _this.musicTitle)&&(identical(other.musicArtist, _this.musicArtist) || other.musicArtist == _this.musicArtist)&&(identical(other.musicPreviewUrl, _this.musicPreviewUrl) || other.musicPreviewUrl == _this.musicPreviewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleDetailMusic;
  return Object.hash(runtimeType,_this.musicId,_this.musicTitle,_this.musicArtist,_this.musicPreviewUrl);
}

@override
String toString() {
  final _this = this as ScheduleDetailMusic;
  return 'ScheduleDetailMusic(musicId: ${_this.musicId}, musicTitle: ${_this.musicTitle}, musicArtist: ${_this.musicArtist}, musicPreviewUrl: ${_this.musicPreviewUrl})';
}


}

/// @nodoc
abstract mixin class $ScheduleDetailMusicCopyWith<$Res>  {
  factory $ScheduleDetailMusicCopyWith(ScheduleDetailMusic value, $Res Function(ScheduleDetailMusic) _then) = _$ScheduleDetailMusicCopyWithImpl;
@useResult
$Res call({
 int musicId, String? musicTitle, String? musicArtist, String? musicPreviewUrl
});




}
/// @nodoc
class _$ScheduleDetailMusicCopyWithImpl<$Res>
    implements $ScheduleDetailMusicCopyWith<$Res> {
  _$ScheduleDetailMusicCopyWithImpl(this._self, this._then);

  final ScheduleDetailMusic _self;
  final $Res Function(ScheduleDetailMusic) _then;

/// Create a copy of ScheduleDetailMusic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? musicId = null,Object? musicTitle = freezed,Object? musicArtist = freezed,Object? musicPreviewUrl = freezed,}) {
  return _then(ScheduleDetailMusic(
musicId: null == musicId ? _self.musicId : musicId // ignore: cast_nullable_to_non_nullable
as int,musicTitle: freezed == musicTitle ? _self.musicTitle : musicTitle // ignore: cast_nullable_to_non_nullable
as String?,musicArtist: freezed == musicArtist ? _self.musicArtist : musicArtist // ignore: cast_nullable_to_non_nullable
as String?,musicPreviewUrl: freezed == musicPreviewUrl ? _self.musicPreviewUrl : musicPreviewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleDetailMusic].
extension ScheduleDetailMusicPatterns on ScheduleDetailMusic {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleDetailMusic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleDetailMusic() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleDetailMusic value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailMusic():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleDetailMusic value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleDetailMusic() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int musicId,  String? musicTitle,  String? musicArtist,  String? musicPreviewUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleDetailMusic() when $default != null:
return $default(_that.musicId,_that.musicTitle,_that.musicArtist,_that.musicPreviewUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int musicId,  String? musicTitle,  String? musicArtist,  String? musicPreviewUrl)  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailMusic():
return $default(_that.musicId,_that.musicTitle,_that.musicArtist,_that.musicPreviewUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int musicId,  String? musicTitle,  String? musicArtist,  String? musicPreviewUrl)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleDetailMusic() when $default != null:
return $default(_that.musicId,_that.musicTitle,_that.musicArtist,_that.musicPreviewUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleDetailMusic implements ScheduleDetailMusic {
  const _ScheduleDetailMusic({required this.musicId, this.musicTitle, this.musicArtist, this.musicPreviewUrl});
  factory _ScheduleDetailMusic.fromJson(Map<String, dynamic> json) => _$ScheduleDetailMusicFromJson(json);

@override final  int musicId;
@override final  String? musicTitle;
@override final  String? musicArtist;
@override final  String? musicPreviewUrl;

/// Create a copy of ScheduleDetailMusic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDetailMusicCopyWith<_ScheduleDetailMusic> get copyWith => __$ScheduleDetailMusicCopyWithImpl<_ScheduleDetailMusic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleDetailMusicToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleDetailMusic&&(identical(other.musicId, musicId) || other.musicId == musicId)&&(identical(other.musicTitle, musicTitle) || other.musicTitle == musicTitle)&&(identical(other.musicArtist, musicArtist) || other.musicArtist == musicArtist)&&(identical(other.musicPreviewUrl, musicPreviewUrl) || other.musicPreviewUrl == musicPreviewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,musicId,musicTitle,musicArtist,musicPreviewUrl);
}

@override
String toString() {
    return 'ScheduleDetailMusic(musicId: $musicId, musicTitle: $musicTitle, musicArtist: $musicArtist, musicPreviewUrl: $musicPreviewUrl)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDetailMusicCopyWith<$Res> implements $ScheduleDetailMusicCopyWith<$Res> {
  factory _$ScheduleDetailMusicCopyWith(_ScheduleDetailMusic value, $Res Function(_ScheduleDetailMusic) _then) = __$ScheduleDetailMusicCopyWithImpl;
@override @useResult
$Res call({
 int musicId, String? musicTitle, String? musicArtist, String? musicPreviewUrl
});




}
/// @nodoc
class __$ScheduleDetailMusicCopyWithImpl<$Res>
    implements _$ScheduleDetailMusicCopyWith<$Res> {
  __$ScheduleDetailMusicCopyWithImpl(this._self, this._then);

  final _ScheduleDetailMusic _self;
  final $Res Function(_ScheduleDetailMusic) _then;

/// Create a copy of ScheduleDetailMusic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? musicId = null,Object? musicTitle = freezed,Object? musicArtist = freezed,Object? musicPreviewUrl = freezed,}) {
  return _then(_ScheduleDetailMusic(
musicId: null == musicId ? _self.musicId : musicId // ignore: cast_nullable_to_non_nullable
as int,musicTitle: freezed == musicTitle ? _self.musicTitle : musicTitle // ignore: cast_nullable_to_non_nullable
as String?,musicArtist: freezed == musicArtist ? _self.musicArtist : musicArtist // ignore: cast_nullable_to_non_nullable
as String?,musicPreviewUrl: freezed == musicPreviewUrl ? _self.musicPreviewUrl : musicPreviewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
