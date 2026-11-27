// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_update_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleUpdateResponse {

 bool get success; int get status; String get message; ScheduleWriteData get data;
/// Create a copy of ScheduleUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleUpdateResponseCopyWith<ScheduleUpdateResponse> get copyWith => _$ScheduleUpdateResponseCopyWithImpl<ScheduleUpdateResponse>(this as ScheduleUpdateResponse, _$identity);

  /// Serializes this ScheduleUpdateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleUpdateResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleUpdateResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleUpdateResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as ScheduleUpdateResponse;
  return 'ScheduleUpdateResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $ScheduleUpdateResponseCopyWith<$Res>  {
  factory $ScheduleUpdateResponseCopyWith(ScheduleUpdateResponse value, $Res Function(ScheduleUpdateResponse) _then) = _$ScheduleUpdateResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, ScheduleWriteData data
});


$ScheduleWriteDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ScheduleUpdateResponseCopyWithImpl<$Res>
    implements $ScheduleUpdateResponseCopyWith<$Res> {
  _$ScheduleUpdateResponseCopyWithImpl(this._self, this._then);

  final ScheduleUpdateResponse _self;
  final $Res Function(ScheduleUpdateResponse) _then;

/// Create a copy of ScheduleUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(ScheduleUpdateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ScheduleWriteData,
  ));
}
/// Create a copy of ScheduleUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleWriteDataCopyWith<$Res> get data {
  
  return $ScheduleWriteDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleUpdateResponse].
extension ScheduleUpdateResponsePatterns on ScheduleUpdateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleUpdateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleUpdateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleUpdateResponse value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleUpdateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleUpdateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleUpdateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  ScheduleWriteData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleUpdateResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  ScheduleWriteData data)  $default,) {final _that = this;
switch (_that) {
case _ScheduleUpdateResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  ScheduleWriteData data)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleUpdateResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleUpdateResponse implements ScheduleUpdateResponse {
  const _ScheduleUpdateResponse({required this.success, required this.status, required this.message, required this.data});
  factory _ScheduleUpdateResponse.fromJson(Map<String, dynamic> json) => _$ScheduleUpdateResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  ScheduleWriteData data;

/// Create a copy of ScheduleUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleUpdateResponseCopyWith<_ScheduleUpdateResponse> get copyWith => __$ScheduleUpdateResponseCopyWithImpl<_ScheduleUpdateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleUpdateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleUpdateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'ScheduleUpdateResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ScheduleUpdateResponseCopyWith<$Res> implements $ScheduleUpdateResponseCopyWith<$Res> {
  factory _$ScheduleUpdateResponseCopyWith(_ScheduleUpdateResponse value, $Res Function(_ScheduleUpdateResponse) _then) = __$ScheduleUpdateResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, ScheduleWriteData data
});


@override $ScheduleWriteDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ScheduleUpdateResponseCopyWithImpl<$Res>
    implements _$ScheduleUpdateResponseCopyWith<$Res> {
  __$ScheduleUpdateResponseCopyWithImpl(this._self, this._then);

  final _ScheduleUpdateResponse _self;
  final $Res Function(_ScheduleUpdateResponse) _then;

/// Create a copy of ScheduleUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_ScheduleUpdateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ScheduleWriteData,
  ));
}

/// Create a copy of ScheduleUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleWriteDataCopyWith<$Res> get data {
  
  return $ScheduleWriteDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
