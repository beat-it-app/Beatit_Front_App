// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_write_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleWriteData {

 int get scheduleId; String get title; DateTime get startsAt; DateTime get endsAt; int? get locationId; DateTime get createdAt;
/// Create a copy of ScheduleWriteData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleWriteDataCopyWith<ScheduleWriteData> get copyWith => _$ScheduleWriteDataCopyWithImpl<ScheduleWriteData>(this as ScheduleWriteData, _$identity);

  /// Serializes this ScheduleWriteData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleWriteData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleWriteData&&(identical(other.scheduleId, _this.scheduleId) || other.scheduleId == _this.scheduleId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.locationId, _this.locationId) || other.locationId == _this.locationId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleWriteData;
  return Object.hash(runtimeType,_this.scheduleId,_this.title,_this.startsAt,_this.endsAt,_this.locationId,_this.createdAt);
}

@override
String toString() {
  final _this = this as ScheduleWriteData;
  return 'ScheduleWriteData(scheduleId: ${_this.scheduleId}, title: ${_this.title}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, locationId: ${_this.locationId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ScheduleWriteDataCopyWith<$Res>  {
  factory $ScheduleWriteDataCopyWith(ScheduleWriteData value, $Res Function(ScheduleWriteData) _then) = _$ScheduleWriteDataCopyWithImpl;
@useResult
$Res call({
 int scheduleId, String title, DateTime startsAt, DateTime endsAt, int? locationId, DateTime createdAt
});




}
/// @nodoc
class _$ScheduleWriteDataCopyWithImpl<$Res>
    implements $ScheduleWriteDataCopyWith<$Res> {
  _$ScheduleWriteDataCopyWithImpl(this._self, this._then);

  final ScheduleWriteData _self;
  final $Res Function(ScheduleWriteData) _then;

/// Create a copy of ScheduleWriteData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleId = null,Object? title = null,Object? startsAt = null,Object? endsAt = null,Object? locationId = freezed,Object? createdAt = null,}) {
  return _then(ScheduleWriteData(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleWriteData].
extension ScheduleWriteDataPatterns on ScheduleWriteData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleWriteData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleWriteData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleWriteData value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleWriteData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleWriteData value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleWriteData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scheduleId,  String title,  DateTime startsAt,  DateTime endsAt,  int? locationId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleWriteData() when $default != null:
return $default(_that.scheduleId,_that.title,_that.startsAt,_that.endsAt,_that.locationId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scheduleId,  String title,  DateTime startsAt,  DateTime endsAt,  int? locationId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ScheduleWriteData():
return $default(_that.scheduleId,_that.title,_that.startsAt,_that.endsAt,_that.locationId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scheduleId,  String title,  DateTime startsAt,  DateTime endsAt,  int? locationId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleWriteData() when $default != null:
return $default(_that.scheduleId,_that.title,_that.startsAt,_that.endsAt,_that.locationId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleWriteData implements ScheduleWriteData {
  const _ScheduleWriteData({required this.scheduleId, required this.title, required this.startsAt, required this.endsAt, this.locationId, required this.createdAt});
  factory _ScheduleWriteData.fromJson(Map<String, dynamic> json) => _$ScheduleWriteDataFromJson(json);

@override final  int scheduleId;
@override final  String title;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  int? locationId;
@override final  DateTime createdAt;

/// Create a copy of ScheduleWriteData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleWriteDataCopyWith<_ScheduleWriteData> get copyWith => __$ScheduleWriteDataCopyWithImpl<_ScheduleWriteData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleWriteDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleWriteData&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,scheduleId,title,startsAt,endsAt,locationId,createdAt);
}

@override
String toString() {
    return 'ScheduleWriteData(scheduleId: $scheduleId, title: $title, startsAt: $startsAt, endsAt: $endsAt, locationId: $locationId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ScheduleWriteDataCopyWith<$Res> implements $ScheduleWriteDataCopyWith<$Res> {
  factory _$ScheduleWriteDataCopyWith(_ScheduleWriteData value, $Res Function(_ScheduleWriteData) _then) = __$ScheduleWriteDataCopyWithImpl;
@override @useResult
$Res call({
 int scheduleId, String title, DateTime startsAt, DateTime endsAt, int? locationId, DateTime createdAt
});




}
/// @nodoc
class __$ScheduleWriteDataCopyWithImpl<$Res>
    implements _$ScheduleWriteDataCopyWith<$Res> {
  __$ScheduleWriteDataCopyWithImpl(this._self, this._then);

  final _ScheduleWriteData _self;
  final $Res Function(_ScheduleWriteData) _then;

/// Create a copy of ScheduleWriteData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleId = null,Object? title = null,Object? startsAt = null,Object? endsAt = null,Object? locationId = freezed,Object? createdAt = null,}) {
  return _then(_ScheduleWriteData(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
