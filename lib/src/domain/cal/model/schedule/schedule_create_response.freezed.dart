// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_create_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleCreateResponse {

 bool get success; int get status; String get message; ScheduleWriteData get data;
/// Create a copy of ScheduleCreateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCreateResponseCopyWith<ScheduleCreateResponse> get copyWith => _$ScheduleCreateResponseCopyWithImpl<ScheduleCreateResponse>(this as ScheduleCreateResponse, _$identity);

  /// Serializes this ScheduleCreateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleCreateResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleCreateResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleCreateResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as ScheduleCreateResponse;
  return 'ScheduleCreateResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $ScheduleCreateResponseCopyWith<$Res>  {
  factory $ScheduleCreateResponseCopyWith(ScheduleCreateResponse value, $Res Function(ScheduleCreateResponse) _then) = _$ScheduleCreateResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, ScheduleWriteData data
});


$ScheduleWriteDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ScheduleCreateResponseCopyWithImpl<$Res>
    implements $ScheduleCreateResponseCopyWith<$Res> {
  _$ScheduleCreateResponseCopyWithImpl(this._self, this._then);

  final ScheduleCreateResponse _self;
  final $Res Function(ScheduleCreateResponse) _then;

/// Create a copy of ScheduleCreateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(ScheduleCreateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ScheduleWriteData,
  ));
}
/// Create a copy of ScheduleCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleWriteDataCopyWith<$Res> get data {
  
  return $ScheduleWriteDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleCreateResponse].
extension ScheduleCreateResponsePatterns on ScheduleCreateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleCreateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleCreateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleCreateResponse value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleCreateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleCreateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleCreateResponse() when $default != null:
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
case _ScheduleCreateResponse() when $default != null:
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
case _ScheduleCreateResponse():
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
case _ScheduleCreateResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleCreateResponse implements ScheduleCreateResponse {
  const _ScheduleCreateResponse({required this.success, required this.status, required this.message, required this.data});
  factory _ScheduleCreateResponse.fromJson(Map<String, dynamic> json) => _$ScheduleCreateResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  ScheduleWriteData data;

/// Create a copy of ScheduleCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCreateResponseCopyWith<_ScheduleCreateResponse> get copyWith => __$ScheduleCreateResponseCopyWithImpl<_ScheduleCreateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleCreateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleCreateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'ScheduleCreateResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCreateResponseCopyWith<$Res> implements $ScheduleCreateResponseCopyWith<$Res> {
  factory _$ScheduleCreateResponseCopyWith(_ScheduleCreateResponse value, $Res Function(_ScheduleCreateResponse) _then) = __$ScheduleCreateResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, ScheduleWriteData data
});


@override $ScheduleWriteDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ScheduleCreateResponseCopyWithImpl<$Res>
    implements _$ScheduleCreateResponseCopyWith<$Res> {
  __$ScheduleCreateResponseCopyWithImpl(this._self, this._then);

  final _ScheduleCreateResponse _self;
  final $Res Function(_ScheduleCreateResponse) _then;

/// Create a copy of ScheduleCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_ScheduleCreateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ScheduleWriteData,
  ));
}

/// Create a copy of ScheduleCreateResponse
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
