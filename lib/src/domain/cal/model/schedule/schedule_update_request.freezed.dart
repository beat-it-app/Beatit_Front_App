// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_update_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleUpdateRequest {

 int? get locationId; String get title; String? get content;@KstDateTimeConverter() DateTime get startsAt;@KstDateTimeConverter() DateTime get endsAt;/// null이면 기존 참여자를 유지합니다.
 List<int>? get participantUserIds;/// 새로 추가할 음원입니다.
 List<ScheduleUpdateMusicRequest>? get musics;/// 기존 음원 중 유지할 ID 목록입니다.
/// 백엔드 현재 구현상 null도 빈 목록처럼 처리되어 기존 음원이 삭제됩니다.
 List<int>? get retainMusicIds;/// 기존 파일 중 유지할 ID 목록입니다.
/// 백엔드 현재 구현상 null도 빈 목록처럼 처리되어 기존 파일이 삭제됩니다.
 List<int>? get retainFileIds;
/// Create a copy of ScheduleUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleUpdateRequestCopyWith<ScheduleUpdateRequest> get copyWith => _$ScheduleUpdateRequestCopyWithImpl<ScheduleUpdateRequest>(this as ScheduleUpdateRequest, _$identity);

  /// Serializes this ScheduleUpdateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleUpdateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleUpdateRequest&&(identical(other.locationId, _this.locationId) || other.locationId == _this.locationId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&const DeepCollectionEquality().equals(other.participantUserIds, _this.participantUserIds)&&const DeepCollectionEquality().equals(other.musics, _this.musics)&&const DeepCollectionEquality().equals(other.retainMusicIds, _this.retainMusicIds)&&const DeepCollectionEquality().equals(other.retainFileIds, _this.retainFileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleUpdateRequest;
  return Object.hash(runtimeType,_this.locationId,_this.title,_this.content,_this.startsAt,_this.endsAt,const DeepCollectionEquality().hash(_this.participantUserIds),const DeepCollectionEquality().hash(_this.musics),const DeepCollectionEquality().hash(_this.retainMusicIds),const DeepCollectionEquality().hash(_this.retainFileIds));
}

@override
String toString() {
  final _this = this as ScheduleUpdateRequest;
  return 'ScheduleUpdateRequest(locationId: ${_this.locationId}, title: ${_this.title}, content: ${_this.content}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, participantUserIds: ${_this.participantUserIds}, musics: ${_this.musics}, retainMusicIds: ${_this.retainMusicIds}, retainFileIds: ${_this.retainFileIds})';
}


}

/// @nodoc
abstract mixin class $ScheduleUpdateRequestCopyWith<$Res>  {
  factory $ScheduleUpdateRequestCopyWith(ScheduleUpdateRequest value, $Res Function(ScheduleUpdateRequest) _then) = _$ScheduleUpdateRequestCopyWithImpl;
@useResult
$Res call({
 int? locationId, String title, String? content,@KstDateTimeConverter() DateTime startsAt,@KstDateTimeConverter() DateTime endsAt, List<int>? participantUserIds, List<ScheduleUpdateMusicRequest>? musics, List<int>? retainMusicIds, List<int>? retainFileIds
});




}
/// @nodoc
class _$ScheduleUpdateRequestCopyWithImpl<$Res>
    implements $ScheduleUpdateRequestCopyWith<$Res> {
  _$ScheduleUpdateRequestCopyWithImpl(this._self, this._then);

  final ScheduleUpdateRequest _self;
  final $Res Function(ScheduleUpdateRequest) _then;

/// Create a copy of ScheduleUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locationId = freezed,Object? title = null,Object? content = freezed,Object? startsAt = null,Object? endsAt = null,Object? participantUserIds = freezed,Object? musics = freezed,Object? retainMusicIds = freezed,Object? retainFileIds = freezed,}) {
  return _then(ScheduleUpdateRequest(
locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,participantUserIds: freezed == participantUserIds ? _self.participantUserIds : participantUserIds // ignore: cast_nullable_to_non_nullable
as List<int>?,musics: freezed == musics ? _self.musics : musics // ignore: cast_nullable_to_non_nullable
as List<ScheduleUpdateMusicRequest>?,retainMusicIds: freezed == retainMusicIds ? _self.retainMusicIds : retainMusicIds // ignore: cast_nullable_to_non_nullable
as List<int>?,retainFileIds: freezed == retainFileIds ? _self.retainFileIds : retainFileIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleUpdateRequest].
extension ScheduleUpdateRequestPatterns on ScheduleUpdateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleUpdateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleUpdateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleUpdateRequest value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleUpdateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleUpdateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleUpdateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? locationId,  String title,  String? content, @KstDateTimeConverter()  DateTime startsAt, @KstDateTimeConverter()  DateTime endsAt,  List<int>? participantUserIds,  List<ScheduleUpdateMusicRequest>? musics,  List<int>? retainMusicIds,  List<int>? retainFileIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleUpdateRequest() when $default != null:
return $default(_that.locationId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.participantUserIds,_that.musics,_that.retainMusicIds,_that.retainFileIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? locationId,  String title,  String? content, @KstDateTimeConverter()  DateTime startsAt, @KstDateTimeConverter()  DateTime endsAt,  List<int>? participantUserIds,  List<ScheduleUpdateMusicRequest>? musics,  List<int>? retainMusicIds,  List<int>? retainFileIds)  $default,) {final _that = this;
switch (_that) {
case _ScheduleUpdateRequest():
return $default(_that.locationId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.participantUserIds,_that.musics,_that.retainMusicIds,_that.retainFileIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? locationId,  String title,  String? content, @KstDateTimeConverter()  DateTime startsAt, @KstDateTimeConverter()  DateTime endsAt,  List<int>? participantUserIds,  List<ScheduleUpdateMusicRequest>? musics,  List<int>? retainMusicIds,  List<int>? retainFileIds)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleUpdateRequest() when $default != null:
return $default(_that.locationId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.participantUserIds,_that.musics,_that.retainMusicIds,_that.retainFileIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleUpdateRequest implements ScheduleUpdateRequest {
  const _ScheduleUpdateRequest({this.locationId, required this.title, this.content, @KstDateTimeConverter() required this.startsAt, @KstDateTimeConverter() required this.endsAt,  List<int>? participantUserIds,  List<ScheduleUpdateMusicRequest>? musics,  List<int>? retainMusicIds,  List<int>? retainFileIds}): _participantUserIds = participantUserIds,_musics = musics,_retainMusicIds = retainMusicIds,_retainFileIds = retainFileIds;
  factory _ScheduleUpdateRequest.fromJson(Map<String, dynamic> json) => _$ScheduleUpdateRequestFromJson(json);

@override final  int? locationId;
@override final  String title;
@override final  String? content;
@override@KstDateTimeConverter() final  DateTime startsAt;
@override@KstDateTimeConverter() final  DateTime endsAt;
/// null이면 기존 참여자를 유지합니다.
 final  List<int>? _participantUserIds;
/// null이면 기존 참여자를 유지합니다.
@override List<int>? get participantUserIds {
  final value = _participantUserIds;
  if (value == null) return null;
  if (_participantUserIds is EqualUnmodifiableListView) return _participantUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// 새로 추가할 음원입니다.
 final  List<ScheduleUpdateMusicRequest>? _musics;
/// 새로 추가할 음원입니다.
@override List<ScheduleUpdateMusicRequest>? get musics {
  final value = _musics;
  if (value == null) return null;
  if (_musics is EqualUnmodifiableListView) return _musics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// 기존 음원 중 유지할 ID 목록입니다.
/// 백엔드 현재 구현상 null도 빈 목록처럼 처리되어 기존 음원이 삭제됩니다.
 final  List<int>? _retainMusicIds;
/// 기존 음원 중 유지할 ID 목록입니다.
/// 백엔드 현재 구현상 null도 빈 목록처럼 처리되어 기존 음원이 삭제됩니다.
@override List<int>? get retainMusicIds {
  final value = _retainMusicIds;
  if (value == null) return null;
  if (_retainMusicIds is EqualUnmodifiableListView) return _retainMusicIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// 기존 파일 중 유지할 ID 목록입니다.
/// 백엔드 현재 구현상 null도 빈 목록처럼 처리되어 기존 파일이 삭제됩니다.
 final  List<int>? _retainFileIds;
/// 기존 파일 중 유지할 ID 목록입니다.
/// 백엔드 현재 구현상 null도 빈 목록처럼 처리되어 기존 파일이 삭제됩니다.
@override List<int>? get retainFileIds {
  final value = _retainFileIds;
  if (value == null) return null;
  if (_retainFileIds is EqualUnmodifiableListView) return _retainFileIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ScheduleUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleUpdateRequestCopyWith<_ScheduleUpdateRequest> get copyWith => __$ScheduleUpdateRequestCopyWithImpl<_ScheduleUpdateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleUpdateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleUpdateRequest&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&const DeepCollectionEquality().equals(other.participantUserIds, _participantUserIds)&&const DeepCollectionEquality().equals(other.musics, _musics)&&const DeepCollectionEquality().equals(other.retainMusicIds, _retainMusicIds)&&const DeepCollectionEquality().equals(other.retainFileIds, _retainFileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,locationId,title,content,startsAt,endsAt,const DeepCollectionEquality().hash(_participantUserIds),const DeepCollectionEquality().hash(_musics),const DeepCollectionEquality().hash(_retainMusicIds),const DeepCollectionEquality().hash(_retainFileIds));
}

@override
String toString() {
    return 'ScheduleUpdateRequest(locationId: $locationId, title: $title, content: $content, startsAt: $startsAt, endsAt: $endsAt, participantUserIds: $participantUserIds, musics: $musics, retainMusicIds: $retainMusicIds, retainFileIds: $retainFileIds)';
}


}

/// @nodoc
abstract mixin class _$ScheduleUpdateRequestCopyWith<$Res> implements $ScheduleUpdateRequestCopyWith<$Res> {
  factory _$ScheduleUpdateRequestCopyWith(_ScheduleUpdateRequest value, $Res Function(_ScheduleUpdateRequest) _then) = __$ScheduleUpdateRequestCopyWithImpl;
@override @useResult
$Res call({
 int? locationId, String title, String? content,@KstDateTimeConverter() DateTime startsAt,@KstDateTimeConverter() DateTime endsAt, List<int>? participantUserIds, List<ScheduleUpdateMusicRequest>? musics, List<int>? retainMusicIds, List<int>? retainFileIds
});




}
/// @nodoc
class __$ScheduleUpdateRequestCopyWithImpl<$Res>
    implements _$ScheduleUpdateRequestCopyWith<$Res> {
  __$ScheduleUpdateRequestCopyWithImpl(this._self, this._then);

  final _ScheduleUpdateRequest _self;
  final $Res Function(_ScheduleUpdateRequest) _then;

/// Create a copy of ScheduleUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locationId = freezed,Object? title = null,Object? content = freezed,Object? startsAt = null,Object? endsAt = null,Object? participantUserIds = freezed,Object? musics = freezed,Object? retainMusicIds = freezed,Object? retainFileIds = freezed,}) {
  return _then(_ScheduleUpdateRequest(
locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,participantUserIds: freezed == participantUserIds ? _self._participantUserIds : participantUserIds // ignore: cast_nullable_to_non_nullable
as List<int>?,musics: freezed == musics ? _self._musics : musics // ignore: cast_nullable_to_non_nullable
as List<ScheduleUpdateMusicRequest>?,retainMusicIds: freezed == retainMusicIds ? _self._retainMusicIds : retainMusicIds // ignore: cast_nullable_to_non_nullable
as List<int>?,retainFileIds: freezed == retainFileIds ? _self._retainFileIds : retainFileIds // ignore: cast_nullable_to_non_nullable
as List<int>?,
  ));
}


}


/// @nodoc
mixin _$ScheduleUpdateMusicRequest {

 String get musicTitle; String get musicArtist; String? get musicPreviewUrl;
/// Create a copy of ScheduleUpdateMusicRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleUpdateMusicRequestCopyWith<ScheduleUpdateMusicRequest> get copyWith => _$ScheduleUpdateMusicRequestCopyWithImpl<ScheduleUpdateMusicRequest>(this as ScheduleUpdateMusicRequest, _$identity);

  /// Serializes this ScheduleUpdateMusicRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleUpdateMusicRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleUpdateMusicRequest&&(identical(other.musicTitle, _this.musicTitle) || other.musicTitle == _this.musicTitle)&&(identical(other.musicArtist, _this.musicArtist) || other.musicArtist == _this.musicArtist)&&(identical(other.musicPreviewUrl, _this.musicPreviewUrl) || other.musicPreviewUrl == _this.musicPreviewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleUpdateMusicRequest;
  return Object.hash(runtimeType,_this.musicTitle,_this.musicArtist,_this.musicPreviewUrl);
}

@override
String toString() {
  final _this = this as ScheduleUpdateMusicRequest;
  return 'ScheduleUpdateMusicRequest(musicTitle: ${_this.musicTitle}, musicArtist: ${_this.musicArtist}, musicPreviewUrl: ${_this.musicPreviewUrl})';
}


}

/// @nodoc
abstract mixin class $ScheduleUpdateMusicRequestCopyWith<$Res>  {
  factory $ScheduleUpdateMusicRequestCopyWith(ScheduleUpdateMusicRequest value, $Res Function(ScheduleUpdateMusicRequest) _then) = _$ScheduleUpdateMusicRequestCopyWithImpl;
@useResult
$Res call({
 String musicTitle, String musicArtist, String? musicPreviewUrl
});




}
/// @nodoc
class _$ScheduleUpdateMusicRequestCopyWithImpl<$Res>
    implements $ScheduleUpdateMusicRequestCopyWith<$Res> {
  _$ScheduleUpdateMusicRequestCopyWithImpl(this._self, this._then);

  final ScheduleUpdateMusicRequest _self;
  final $Res Function(ScheduleUpdateMusicRequest) _then;

/// Create a copy of ScheduleUpdateMusicRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? musicTitle = null,Object? musicArtist = null,Object? musicPreviewUrl = freezed,}) {
  return _then(ScheduleUpdateMusicRequest(
musicTitle: null == musicTitle ? _self.musicTitle : musicTitle // ignore: cast_nullable_to_non_nullable
as String,musicArtist: null == musicArtist ? _self.musicArtist : musicArtist // ignore: cast_nullable_to_non_nullable
as String,musicPreviewUrl: freezed == musicPreviewUrl ? _self.musicPreviewUrl : musicPreviewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleUpdateMusicRequest].
extension ScheduleUpdateMusicRequestPatterns on ScheduleUpdateMusicRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleUpdateMusicRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleUpdateMusicRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleUpdateMusicRequest value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleUpdateMusicRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleUpdateMusicRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleUpdateMusicRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String musicTitle,  String musicArtist,  String? musicPreviewUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleUpdateMusicRequest() when $default != null:
return $default(_that.musicTitle,_that.musicArtist,_that.musicPreviewUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String musicTitle,  String musicArtist,  String? musicPreviewUrl)  $default,) {final _that = this;
switch (_that) {
case _ScheduleUpdateMusicRequest():
return $default(_that.musicTitle,_that.musicArtist,_that.musicPreviewUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String musicTitle,  String musicArtist,  String? musicPreviewUrl)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleUpdateMusicRequest() when $default != null:
return $default(_that.musicTitle,_that.musicArtist,_that.musicPreviewUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleUpdateMusicRequest implements ScheduleUpdateMusicRequest {
  const _ScheduleUpdateMusicRequest({required this.musicTitle, required this.musicArtist, this.musicPreviewUrl});
  factory _ScheduleUpdateMusicRequest.fromJson(Map<String, dynamic> json) => _$ScheduleUpdateMusicRequestFromJson(json);

@override final  String musicTitle;
@override final  String musicArtist;
@override final  String? musicPreviewUrl;

/// Create a copy of ScheduleUpdateMusicRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleUpdateMusicRequestCopyWith<_ScheduleUpdateMusicRequest> get copyWith => __$ScheduleUpdateMusicRequestCopyWithImpl<_ScheduleUpdateMusicRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleUpdateMusicRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleUpdateMusicRequest&&(identical(other.musicTitle, musicTitle) || other.musicTitle == musicTitle)&&(identical(other.musicArtist, musicArtist) || other.musicArtist == musicArtist)&&(identical(other.musicPreviewUrl, musicPreviewUrl) || other.musicPreviewUrl == musicPreviewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,musicTitle,musicArtist,musicPreviewUrl);
}

@override
String toString() {
    return 'ScheduleUpdateMusicRequest(musicTitle: $musicTitle, musicArtist: $musicArtist, musicPreviewUrl: $musicPreviewUrl)';
}


}

/// @nodoc
abstract mixin class _$ScheduleUpdateMusicRequestCopyWith<$Res> implements $ScheduleUpdateMusicRequestCopyWith<$Res> {
  factory _$ScheduleUpdateMusicRequestCopyWith(_ScheduleUpdateMusicRequest value, $Res Function(_ScheduleUpdateMusicRequest) _then) = __$ScheduleUpdateMusicRequestCopyWithImpl;
@override @useResult
$Res call({
 String musicTitle, String musicArtist, String? musicPreviewUrl
});




}
/// @nodoc
class __$ScheduleUpdateMusicRequestCopyWithImpl<$Res>
    implements _$ScheduleUpdateMusicRequestCopyWith<$Res> {
  __$ScheduleUpdateMusicRequestCopyWithImpl(this._self, this._then);

  final _ScheduleUpdateMusicRequest _self;
  final $Res Function(_ScheduleUpdateMusicRequest) _then;

/// Create a copy of ScheduleUpdateMusicRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? musicTitle = null,Object? musicArtist = null,Object? musicPreviewUrl = freezed,}) {
  return _then(_ScheduleUpdateMusicRequest(
musicTitle: null == musicTitle ? _self.musicTitle : musicTitle // ignore: cast_nullable_to_non_nullable
as String,musicArtist: null == musicArtist ? _self.musicArtist : musicArtist // ignore: cast_nullable_to_non_nullable
as String,musicPreviewUrl: freezed == musicPreviewUrl ? _self.musicPreviewUrl : musicPreviewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
