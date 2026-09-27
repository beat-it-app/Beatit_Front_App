// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meetit_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeetitCreateRequest {

 String get title; List<String> get candidateDates; String? get startTime; String? get endTime; bool get dateOnly; List<int> get participantUserIds;
/// Create a copy of MeetitCreateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetitCreateRequestCopyWith<MeetitCreateRequest> get copyWith => _$MeetitCreateRequestCopyWithImpl<MeetitCreateRequest>(this as MeetitCreateRequest, _$identity);

  /// Serializes this MeetitCreateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetitCreateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetitCreateRequest&&(identical(other.title, _this.title) || other.title == _this.title)&&const DeepCollectionEquality().equals(other.candidateDates, _this.candidateDates)&&(identical(other.startTime, _this.startTime) || other.startTime == _this.startTime)&&(identical(other.endTime, _this.endTime) || other.endTime == _this.endTime)&&(identical(other.dateOnly, _this.dateOnly) || other.dateOnly == _this.dateOnly)&&const DeepCollectionEquality().equals(other.participantUserIds, _this.participantUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetitCreateRequest;
  return Object.hash(runtimeType,_this.title,const DeepCollectionEquality().hash(_this.candidateDates),_this.startTime,_this.endTime,_this.dateOnly,const DeepCollectionEquality().hash(_this.participantUserIds));
}

@override
String toString() {
  final _this = this as MeetitCreateRequest;
  return 'MeetitCreateRequest(title: ${_this.title}, candidateDates: ${_this.candidateDates}, startTime: ${_this.startTime}, endTime: ${_this.endTime}, dateOnly: ${_this.dateOnly}, participantUserIds: ${_this.participantUserIds})';
}


}

/// @nodoc
abstract mixin class $MeetitCreateRequestCopyWith<$Res>  {
  factory $MeetitCreateRequestCopyWith(MeetitCreateRequest value, $Res Function(MeetitCreateRequest) _then) = _$MeetitCreateRequestCopyWithImpl;
@useResult
$Res call({
 String title, List<String> candidateDates, String? startTime, String? endTime, bool dateOnly, List<int> participantUserIds
});




}
/// @nodoc
class _$MeetitCreateRequestCopyWithImpl<$Res>
    implements $MeetitCreateRequestCopyWith<$Res> {
  _$MeetitCreateRequestCopyWithImpl(this._self, this._then);

  final MeetitCreateRequest _self;
  final $Res Function(MeetitCreateRequest) _then;

/// Create a copy of MeetitCreateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? candidateDates = null,Object? startTime = freezed,Object? endTime = freezed,Object? dateOnly = null,Object? participantUserIds = null,}) {
  return _then(MeetitCreateRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,candidateDates: null == candidateDates ? _self.candidateDates : candidateDates // ignore: cast_nullable_to_non_nullable
as List<String>,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,dateOnly: null == dateOnly ? _self.dateOnly : dateOnly // ignore: cast_nullable_to_non_nullable
as bool,participantUserIds: null == participantUserIds ? _self.participantUserIds : participantUserIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetitCreateRequest].
extension MeetitCreateRequestPatterns on MeetitCreateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetitCreateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetitCreateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetitCreateRequest value)  $default,){
final _that = this;
switch (_that) {
case _MeetitCreateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetitCreateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _MeetitCreateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  List<String> candidateDates,  String? startTime,  String? endTime,  bool dateOnly,  List<int> participantUserIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetitCreateRequest() when $default != null:
return $default(_that.title,_that.candidateDates,_that.startTime,_that.endTime,_that.dateOnly,_that.participantUserIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  List<String> candidateDates,  String? startTime,  String? endTime,  bool dateOnly,  List<int> participantUserIds)  $default,) {final _that = this;
switch (_that) {
case _MeetitCreateRequest():
return $default(_that.title,_that.candidateDates,_that.startTime,_that.endTime,_that.dateOnly,_that.participantUserIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  List<String> candidateDates,  String? startTime,  String? endTime,  bool dateOnly,  List<int> participantUserIds)?  $default,) {final _that = this;
switch (_that) {
case _MeetitCreateRequest() when $default != null:
return $default(_that.title,_that.candidateDates,_that.startTime,_that.endTime,_that.dateOnly,_that.participantUserIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetitCreateRequest implements MeetitCreateRequest {
  const _MeetitCreateRequest({required this.title, required  List<String> candidateDates, this.startTime, this.endTime, required this.dateOnly, required  List<int> participantUserIds}): _candidateDates = candidateDates,_participantUserIds = participantUserIds;
  factory _MeetitCreateRequest.fromJson(Map<String, dynamic> json) => _$MeetitCreateRequestFromJson(json);

@override final  String title;
 final  List<String> _candidateDates;
@override List<String> get candidateDates {
  if (_candidateDates is EqualUnmodifiableListView) return _candidateDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidateDates);
}

@override final  String? startTime;
@override final  String? endTime;
@override final  bool dateOnly;
 final  List<int> _participantUserIds;
@override List<int> get participantUserIds {
  if (_participantUserIds is EqualUnmodifiableListView) return _participantUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantUserIds);
}


/// Create a copy of MeetitCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetitCreateRequestCopyWith<_MeetitCreateRequest> get copyWith => __$MeetitCreateRequestCopyWithImpl<_MeetitCreateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetitCreateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetitCreateRequest&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.candidateDates, _candidateDates)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.dateOnly, dateOnly) || other.dateOnly == dateOnly)&&const DeepCollectionEquality().equals(other.participantUserIds, _participantUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_candidateDates),startTime,endTime,dateOnly,const DeepCollectionEquality().hash(_participantUserIds));
}

@override
String toString() {
    return 'MeetitCreateRequest(title: $title, candidateDates: $candidateDates, startTime: $startTime, endTime: $endTime, dateOnly: $dateOnly, participantUserIds: $participantUserIds)';
}


}

/// @nodoc
abstract mixin class _$MeetitCreateRequestCopyWith<$Res> implements $MeetitCreateRequestCopyWith<$Res> {
  factory _$MeetitCreateRequestCopyWith(_MeetitCreateRequest value, $Res Function(_MeetitCreateRequest) _then) = __$MeetitCreateRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, List<String> candidateDates, String? startTime, String? endTime, bool dateOnly, List<int> participantUserIds
});




}
/// @nodoc
class __$MeetitCreateRequestCopyWithImpl<$Res>
    implements _$MeetitCreateRequestCopyWith<$Res> {
  __$MeetitCreateRequestCopyWithImpl(this._self, this._then);

  final _MeetitCreateRequest _self;
  final $Res Function(_MeetitCreateRequest) _then;

/// Create a copy of MeetitCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? candidateDates = null,Object? startTime = freezed,Object? endTime = freezed,Object? dateOnly = null,Object? participantUserIds = null,}) {
  return _then(_MeetitCreateRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,candidateDates: null == candidateDates ? _self._candidateDates : candidateDates // ignore: cast_nullable_to_non_nullable
as List<String>,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,dateOnly: null == dateOnly ? _self.dateOnly : dateOnly // ignore: cast_nullable_to_non_nullable
as bool,participantUserIds: null == participantUserIds ? _self._participantUserIds : participantUserIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
