// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'find_id_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FindIdentifierResponse {

 bool get success; int get status; String get message; FindIdentifierData get data;
/// Create a copy of FindIdentifierResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FindIdentifierResponseCopyWith<FindIdentifierResponse> get copyWith => _$FindIdentifierResponseCopyWithImpl<FindIdentifierResponse>(this as FindIdentifierResponse, _$identity);

  /// Serializes this FindIdentifierResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FindIdentifierResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,status,message,data);

@override
String toString() {
  return 'FindIdentifierResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $FindIdentifierResponseCopyWith<$Res>  {
  factory $FindIdentifierResponseCopyWith(FindIdentifierResponse value, $Res Function(FindIdentifierResponse) _then) = _$FindIdentifierResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, FindIdentifierData data
});


$FindIdentifierDataCopyWith<$Res> get data;

}
/// @nodoc
class _$FindIdentifierResponseCopyWithImpl<$Res>
    implements $FindIdentifierResponseCopyWith<$Res> {
  _$FindIdentifierResponseCopyWithImpl(this._self, this._then);

  final FindIdentifierResponse _self;
  final $Res Function(FindIdentifierResponse) _then;

/// Create a copy of FindIdentifierResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(FindIdentifierResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as FindIdentifierData,
  ));
}
/// Create a copy of FindIdentifierResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FindIdentifierDataCopyWith<$Res> get data {
  
  return $FindIdentifierDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [FindIdentifierResponse].
extension FindIdentifierResponsePatterns on FindIdentifierResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FindIdentifierResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FindIdentifierResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FindIdentifierResponse value)  $default,){
final _that = this;
switch (_that) {
case _FindIdentifierResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FindIdentifierResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FindIdentifierResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  FindIdentifierData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FindIdentifierResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  FindIdentifierData data)  $default,) {final _that = this;
switch (_that) {
case _FindIdentifierResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  FindIdentifierData data)?  $default,) {final _that = this;
switch (_that) {
case _FindIdentifierResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FindIdentifierResponse implements FindIdentifierResponse {
  const _FindIdentifierResponse({required this.success, required this.status, required this.message, required this.data});
  factory _FindIdentifierResponse.fromJson(Map<String, dynamic> json) => _$FindIdentifierResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  FindIdentifierData data;

/// Create a copy of FindIdentifierResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FindIdentifierResponseCopyWith<_FindIdentifierResponse> get copyWith => __$FindIdentifierResponseCopyWithImpl<_FindIdentifierResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FindIdentifierResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FindIdentifierResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,status,message,data);

@override
String toString() {
  return 'FindIdentifierResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$FindIdentifierResponseCopyWith<$Res> implements $FindIdentifierResponseCopyWith<$Res> {
  factory _$FindIdentifierResponseCopyWith(_FindIdentifierResponse value, $Res Function(_FindIdentifierResponse) _then) = __$FindIdentifierResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, FindIdentifierData data
});


@override $FindIdentifierDataCopyWith<$Res> get data;

}
/// @nodoc
class __$FindIdentifierResponseCopyWithImpl<$Res>
    implements _$FindIdentifierResponseCopyWith<$Res> {
  __$FindIdentifierResponseCopyWithImpl(this._self, this._then);

  final _FindIdentifierResponse _self;
  final $Res Function(_FindIdentifierResponse) _then;

/// Create a copy of FindIdentifierResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_FindIdentifierResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as FindIdentifierData,
  ));
}

/// Create a copy of FindIdentifierResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FindIdentifierDataCopyWith<$Res> get data {
  
  return $FindIdentifierDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$FindIdentifierData {

 String get identifier;
/// Create a copy of FindIdentifierData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FindIdentifierDataCopyWith<FindIdentifierData> get copyWith => _$FindIdentifierDataCopyWithImpl<FindIdentifierData>(this as FindIdentifierData, _$identity);

  /// Serializes this FindIdentifierData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FindIdentifierData&&(identical(other.identifier, identifier) || other.identifier == identifier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,identifier);

@override
String toString() {
  return 'FindIdentifierData(identifier: $identifier)';
}


}

/// @nodoc
abstract mixin class $FindIdentifierDataCopyWith<$Res>  {
  factory $FindIdentifierDataCopyWith(FindIdentifierData value, $Res Function(FindIdentifierData) _then) = _$FindIdentifierDataCopyWithImpl;
@useResult
$Res call({
 String identifier
});




}
/// @nodoc
class _$FindIdentifierDataCopyWithImpl<$Res>
    implements $FindIdentifierDataCopyWith<$Res> {
  _$FindIdentifierDataCopyWithImpl(this._self, this._then);

  final FindIdentifierData _self;
  final $Res Function(FindIdentifierData) _then;

/// Create a copy of FindIdentifierData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? identifier = null,}) {
  return _then(FindIdentifierData(
identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FindIdentifierData].
extension FindIdentifierDataPatterns on FindIdentifierData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FindIdentifierData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FindIdentifierData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FindIdentifierData value)  $default,){
final _that = this;
switch (_that) {
case _FindIdentifierData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FindIdentifierData value)?  $default,){
final _that = this;
switch (_that) {
case _FindIdentifierData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String identifier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FindIdentifierData() when $default != null:
return $default(_that.identifier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String identifier)  $default,) {final _that = this;
switch (_that) {
case _FindIdentifierData():
return $default(_that.identifier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String identifier)?  $default,) {final _that = this;
switch (_that) {
case _FindIdentifierData() when $default != null:
return $default(_that.identifier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FindIdentifierData implements FindIdentifierData {
  const _FindIdentifierData({required this.identifier});
  factory _FindIdentifierData.fromJson(Map<String, dynamic> json) => _$FindIdentifierDataFromJson(json);

@override final  String identifier;

/// Create a copy of FindIdentifierData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FindIdentifierDataCopyWith<_FindIdentifierData> get copyWith => __$FindIdentifierDataCopyWithImpl<_FindIdentifierData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FindIdentifierDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FindIdentifierData&&(identical(other.identifier, identifier) || other.identifier == identifier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,identifier);

@override
String toString() {
  return 'FindIdentifierData(identifier: $identifier)';
}


}

/// @nodoc
abstract mixin class _$FindIdentifierDataCopyWith<$Res> implements $FindIdentifierDataCopyWith<$Res> {
  factory _$FindIdentifierDataCopyWith(_FindIdentifierData value, $Res Function(_FindIdentifierData) _then) = __$FindIdentifierDataCopyWithImpl;
@override @useResult
$Res call({
 String identifier
});




}
/// @nodoc
class __$FindIdentifierDataCopyWithImpl<$Res>
    implements _$FindIdentifierDataCopyWith<$Res> {
  __$FindIdentifierDataCopyWithImpl(this._self, this._then);

  final _FindIdentifierData _self;
  final $Res Function(_FindIdentifierData) _then;

/// Create a copy of FindIdentifierData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? identifier = null,}) {
  return _then(_FindIdentifierData(
identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
