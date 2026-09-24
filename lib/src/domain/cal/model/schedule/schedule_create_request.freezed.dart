// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleCreateRequest {

 int? get locationId; String get title; String? get content;@KstDateTimeConverter() DateTime get startsAt;@KstDateTimeConverter() DateTime get endsAt; List<int> get participantUserIds; List<ScheduleCreateMusicRequest> get musics;
/// Create a copy of ScheduleCreateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCreateRequestCopyWith<ScheduleCreateRequest> get copyWith => _$ScheduleCreateRequestCopyWithImpl<ScheduleCreateRequest>(this as ScheduleCreateRequest, _$identity);

  /// Serializes this ScheduleCreateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleCreateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleCreateRequest&&(identical(other.locationId, _this.locationId) || other.locationId == _this.locationId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&const DeepCollectionEquality().equals(other.participantUserIds, _this.participantUserIds)&&const DeepCollectionEquality().equals(other.musics, _this.musics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleCreateRequest;
  return Object.hash(runtimeType,_this.locationId,_this.title,_this.content,_this.startsAt,_this.endsAt,const DeepCollectionEquality().hash(_this.participantUserIds),const DeepCollectionEquality().hash(_this.musics));
}

@override
String toString() {
  final _this = this as ScheduleCreateRequest;
  return 'ScheduleCreateRequest(locationId: ${_this.locationId}, title: ${_this.title}, content: ${_this.content}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, participantUserIds: ${_this.participantUserIds}, musics: ${_this.musics})';
}


}

/// @nodoc
abstract mixin class $ScheduleCreateRequestCopyWith<$Res>  {
  factory $ScheduleCreateRequestCopyWith(ScheduleCreateRequest value, $Res Function(ScheduleCreateRequest) _then) = _$ScheduleCreateRequestCopyWithImpl;
@useResult
$Res call({
 int? locationId, String title, String? content,@KstDateTimeConverter() DateTime startsAt,@KstDateTimeConverter() DateTime endsAt, List<int> participantUserIds, List<ScheduleCreateMusicRequest> musics
});




}
/// @nodoc
class _$ScheduleCreateRequestCopyWithImpl<$Res>
    implements $ScheduleCreateRequestCopyWith<$Res> {
  _$ScheduleCreateRequestCopyWithImpl(this._self, this._then);

  final ScheduleCreateRequest _self;
  final $Res Function(ScheduleCreateRequest) _then;

/// Create a copy of ScheduleCreateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locationId = freezed,Object? title = null,Object? content = freezed,Object? startsAt = null,Object? endsAt = null,Object? participantUserIds = null,Object? musics = null,}) {
  return _then(ScheduleCreateRequest(
locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,participantUserIds: null == participantUserIds ? _self.participantUserIds : participantUserIds // ignore: cast_nullable_to_non_nullable
as List<int>,musics: null == musics ? _self.musics : musics // ignore: cast_nullable_to_non_nullable
as List<ScheduleCreateMusicRequest>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleCreateRequest].
extension ScheduleCreateRequestPatterns on ScheduleCreateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleCreateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleCreateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleCreateRequest value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleCreateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleCreateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleCreateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? locationId,  String title,  String? content, @KstDateTimeConverter()  DateTime startsAt, @KstDateTimeConverter()  DateTime endsAt,  List<int> participantUserIds,  List<ScheduleCreateMusicRequest> musics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleCreateRequest() when $default != null:
return $default(_that.locationId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.participantUserIds,_that.musics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? locationId,  String title,  String? content, @KstDateTimeConverter()  DateTime startsAt, @KstDateTimeConverter()  DateTime endsAt,  List<int> participantUserIds,  List<ScheduleCreateMusicRequest> musics)  $default,) {final _that = this;
switch (_that) {
case _ScheduleCreateRequest():
return $default(_that.locationId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.participantUserIds,_that.musics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? locationId,  String title,  String? content, @KstDateTimeConverter()  DateTime startsAt, @KstDateTimeConverter()  DateTime endsAt,  List<int> participantUserIds,  List<ScheduleCreateMusicRequest> musics)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleCreateRequest() when $default != null:
return $default(_that.locationId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.participantUserIds,_that.musics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleCreateRequest implements ScheduleCreateRequest {
  const _ScheduleCreateRequest({this.locationId, required this.title, this.content, @KstDateTimeConverter() required this.startsAt, @KstDateTimeConverter() required this.endsAt,  List<int> participantUserIds = const <int>[],  List<ScheduleCreateMusicRequest> musics = const <ScheduleCreateMusicRequest>[]}): _participantUserIds = participantUserIds,_musics = musics;
  factory _ScheduleCreateRequest.fromJson(Map<String, dynamic> json) => _$ScheduleCreateRequestFromJson(json);

@override final  int? locationId;
@override final  String title;
@override final  String? content;
@override@KstDateTimeConverter() final  DateTime startsAt;
@override@KstDateTimeConverter() final  DateTime endsAt;
 final  List<int> _participantUserIds;
@override@JsonKey() List<int> get participantUserIds {
  if (_participantUserIds is EqualUnmodifiableListView) return _participantUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantUserIds);
}

 final  List<ScheduleCreateMusicRequest> _musics;
@override@JsonKey() List<ScheduleCreateMusicRequest> get musics {
  if (_musics is EqualUnmodifiableListView) return _musics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_musics);
}


/// Create a copy of ScheduleCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCreateRequestCopyWith<_ScheduleCreateRequest> get copyWith => __$ScheduleCreateRequestCopyWithImpl<_ScheduleCreateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleCreateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleCreateRequest&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&const DeepCollectionEquality().equals(other.participantUserIds, _participantUserIds)&&const DeepCollectionEquality().equals(other.musics, _musics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,locationId,title,content,startsAt,endsAt,const DeepCollectionEquality().hash(_participantUserIds),const DeepCollectionEquality().hash(_musics));
}

@override
String toString() {
    return 'ScheduleCreateRequest(locationId: $locationId, title: $title, content: $content, startsAt: $startsAt, endsAt: $endsAt, participantUserIds: $participantUserIds, musics: $musics)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCreateRequestCopyWith<$Res> implements $ScheduleCreateRequestCopyWith<$Res> {
  factory _$ScheduleCreateRequestCopyWith(_ScheduleCreateRequest value, $Res Function(_ScheduleCreateRequest) _then) = __$ScheduleCreateRequestCopyWithImpl;
@override @useResult
$Res call({
 int? locationId, String title, String? content,@KstDateTimeConverter() DateTime startsAt,@KstDateTimeConverter() DateTime endsAt, List<int> participantUserIds, List<ScheduleCreateMusicRequest> musics
});




}
/// @nodoc
class __$ScheduleCreateRequestCopyWithImpl<$Res>
    implements _$ScheduleCreateRequestCopyWith<$Res> {
  __$ScheduleCreateRequestCopyWithImpl(this._self, this._then);

  final _ScheduleCreateRequest _self;
  final $Res Function(_ScheduleCreateRequest) _then;

/// Create a copy of ScheduleCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locationId = freezed,Object? title = null,Object? content = freezed,Object? startsAt = null,Object? endsAt = null,Object? participantUserIds = null,Object? musics = null,}) {
  return _then(_ScheduleCreateRequest(
locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,participantUserIds: null == participantUserIds ? _self._participantUserIds : participantUserIds // ignore: cast_nullable_to_non_nullable
as List<int>,musics: null == musics ? _self._musics : musics // ignore: cast_nullable_to_non_nullable
as List<ScheduleCreateMusicRequest>,
  ));
}


}


/// @nodoc
mixin _$ScheduleCreateMusicRequest {

 String? get musicTitle; String? get musicArtist; String? get musicPreviewUrl;
/// Create a copy of ScheduleCreateMusicRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCreateMusicRequestCopyWith<ScheduleCreateMusicRequest> get copyWith => _$ScheduleCreateMusicRequestCopyWithImpl<ScheduleCreateMusicRequest>(this as ScheduleCreateMusicRequest, _$identity);

  /// Serializes this ScheduleCreateMusicRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleCreateMusicRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleCreateMusicRequest&&(identical(other.musicTitle, _this.musicTitle) || other.musicTitle == _this.musicTitle)&&(identical(other.musicArtist, _this.musicArtist) || other.musicArtist == _this.musicArtist)&&(identical(other.musicPreviewUrl, _this.musicPreviewUrl) || other.musicPreviewUrl == _this.musicPreviewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleCreateMusicRequest;
  return Object.hash(runtimeType,_this.musicTitle,_this.musicArtist,_this.musicPreviewUrl);
}

@override
String toString() {
  final _this = this as ScheduleCreateMusicRequest;
  return 'ScheduleCreateMusicRequest(musicTitle: ${_this.musicTitle}, musicArtist: ${_this.musicArtist}, musicPreviewUrl: ${_this.musicPreviewUrl})';
}


}

/// @nodoc
abstract mixin class $ScheduleCreateMusicRequestCopyWith<$Res>  {
  factory $ScheduleCreateMusicRequestCopyWith(ScheduleCreateMusicRequest value, $Res Function(ScheduleCreateMusicRequest) _then) = _$ScheduleCreateMusicRequestCopyWithImpl;
@useResult
$Res call({
 String? musicTitle, String? musicArtist, String? musicPreviewUrl
});




}
/// @nodoc
class _$ScheduleCreateMusicRequestCopyWithImpl<$Res>
    implements $ScheduleCreateMusicRequestCopyWith<$Res> {
  _$ScheduleCreateMusicRequestCopyWithImpl(this._self, this._then);

  final ScheduleCreateMusicRequest _self;
  final $Res Function(ScheduleCreateMusicRequest) _then;

/// Create a copy of ScheduleCreateMusicRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? musicTitle = freezed,Object? musicArtist = freezed,Object? musicPreviewUrl = freezed,}) {
  return _then(ScheduleCreateMusicRequest(
musicTitle: freezed == musicTitle ? _self.musicTitle : musicTitle // ignore: cast_nullable_to_non_nullable
as String?,musicArtist: freezed == musicArtist ? _self.musicArtist : musicArtist // ignore: cast_nullable_to_non_nullable
as String?,musicPreviewUrl: freezed == musicPreviewUrl ? _self.musicPreviewUrl : musicPreviewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleCreateMusicRequest].
extension ScheduleCreateMusicRequestPatterns on ScheduleCreateMusicRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleCreateMusicRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleCreateMusicRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleCreateMusicRequest value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleCreateMusicRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleCreateMusicRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleCreateMusicRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? musicTitle,  String? musicArtist,  String? musicPreviewUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleCreateMusicRequest() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? musicTitle,  String? musicArtist,  String? musicPreviewUrl)  $default,) {final _that = this;
switch (_that) {
case _ScheduleCreateMusicRequest():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? musicTitle,  String? musicArtist,  String? musicPreviewUrl)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleCreateMusicRequest() when $default != null:
return $default(_that.musicTitle,_that.musicArtist,_that.musicPreviewUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleCreateMusicRequest implements ScheduleCreateMusicRequest {
  const _ScheduleCreateMusicRequest({this.musicTitle, this.musicArtist, this.musicPreviewUrl});
  factory _ScheduleCreateMusicRequest.fromJson(Map<String, dynamic> json) => _$ScheduleCreateMusicRequestFromJson(json);

@override final  String? musicTitle;
@override final  String? musicArtist;
@override final  String? musicPreviewUrl;

/// Create a copy of ScheduleCreateMusicRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCreateMusicRequestCopyWith<_ScheduleCreateMusicRequest> get copyWith => __$ScheduleCreateMusicRequestCopyWithImpl<_ScheduleCreateMusicRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleCreateMusicRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleCreateMusicRequest&&(identical(other.musicTitle, musicTitle) || other.musicTitle == musicTitle)&&(identical(other.musicArtist, musicArtist) || other.musicArtist == musicArtist)&&(identical(other.musicPreviewUrl, musicPreviewUrl) || other.musicPreviewUrl == musicPreviewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,musicTitle,musicArtist,musicPreviewUrl);
}

@override
String toString() {
    return 'ScheduleCreateMusicRequest(musicTitle: $musicTitle, musicArtist: $musicArtist, musicPreviewUrl: $musicPreviewUrl)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCreateMusicRequestCopyWith<$Res> implements $ScheduleCreateMusicRequestCopyWith<$Res> {
  factory _$ScheduleCreateMusicRequestCopyWith(_ScheduleCreateMusicRequest value, $Res Function(_ScheduleCreateMusicRequest) _then) = __$ScheduleCreateMusicRequestCopyWithImpl;
@override @useResult
$Res call({
 String? musicTitle, String? musicArtist, String? musicPreviewUrl
});




}
/// @nodoc
class __$ScheduleCreateMusicRequestCopyWithImpl<$Res>
    implements _$ScheduleCreateMusicRequestCopyWith<$Res> {
  __$ScheduleCreateMusicRequestCopyWithImpl(this._self, this._then);

  final _ScheduleCreateMusicRequest _self;
  final $Res Function(_ScheduleCreateMusicRequest) _then;

/// Create a copy of ScheduleCreateMusicRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? musicTitle = freezed,Object? musicArtist = freezed,Object? musicPreviewUrl = freezed,}) {
  return _then(_ScheduleCreateMusicRequest(
musicTitle: freezed == musicTitle ? _self.musicTitle : musicTitle // ignore: cast_nullable_to_non_nullable
as String?,musicArtist: freezed == musicArtist ? _self.musicArtist : musicArtist // ignore: cast_nullable_to_non_nullable
as String?,musicPreviewUrl: freezed == musicPreviewUrl ? _self.musicPreviewUrl : musicPreviewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
