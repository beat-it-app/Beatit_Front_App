// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_month_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarMonthResponse {

 bool get success; int get status; String get message; CalendarMonthData get data;
/// Create a copy of CalendarMonthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarMonthResponseCopyWith<CalendarMonthResponse> get copyWith => _$CalendarMonthResponseCopyWithImpl<CalendarMonthResponse>(this as CalendarMonthResponse, _$identity);

  /// Serializes this CalendarMonthResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CalendarMonthResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarMonthResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CalendarMonthResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as CalendarMonthResponse;
  return 'CalendarMonthResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $CalendarMonthResponseCopyWith<$Res>  {
  factory $CalendarMonthResponseCopyWith(CalendarMonthResponse value, $Res Function(CalendarMonthResponse) _then) = _$CalendarMonthResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, CalendarMonthData data
});


$CalendarMonthDataCopyWith<$Res> get data;

}
/// @nodoc
class _$CalendarMonthResponseCopyWithImpl<$Res>
    implements $CalendarMonthResponseCopyWith<$Res> {
  _$CalendarMonthResponseCopyWithImpl(this._self, this._then);

  final CalendarMonthResponse _self;
  final $Res Function(CalendarMonthResponse) _then;

/// Create a copy of CalendarMonthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(CalendarMonthResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CalendarMonthData,
  ));
}
/// Create a copy of CalendarMonthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarMonthDataCopyWith<$Res> get data {
  
  return $CalendarMonthDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CalendarMonthResponse].
extension CalendarMonthResponsePatterns on CalendarMonthResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarMonthResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarMonthResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarMonthResponse value)  $default,){
final _that = this;
switch (_that) {
case _CalendarMonthResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarMonthResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarMonthResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CalendarMonthData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarMonthResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CalendarMonthData data)  $default,) {final _that = this;
switch (_that) {
case _CalendarMonthResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  CalendarMonthData data)?  $default,) {final _that = this;
switch (_that) {
case _CalendarMonthResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarMonthResponse implements CalendarMonthResponse {
  const _CalendarMonthResponse({required this.success, required this.status, required this.message, required this.data});
  factory _CalendarMonthResponse.fromJson(Map<String, dynamic> json) => _$CalendarMonthResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  CalendarMonthData data;

/// Create a copy of CalendarMonthResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarMonthResponseCopyWith<_CalendarMonthResponse> get copyWith => __$CalendarMonthResponseCopyWithImpl<_CalendarMonthResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarMonthResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarMonthResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'CalendarMonthResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CalendarMonthResponseCopyWith<$Res> implements $CalendarMonthResponseCopyWith<$Res> {
  factory _$CalendarMonthResponseCopyWith(_CalendarMonthResponse value, $Res Function(_CalendarMonthResponse) _then) = __$CalendarMonthResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, CalendarMonthData data
});


@override $CalendarMonthDataCopyWith<$Res> get data;

}
/// @nodoc
class __$CalendarMonthResponseCopyWithImpl<$Res>
    implements _$CalendarMonthResponseCopyWith<$Res> {
  __$CalendarMonthResponseCopyWithImpl(this._self, this._then);

  final _CalendarMonthResponse _self;
  final $Res Function(_CalendarMonthResponse) _then;

/// Create a copy of CalendarMonthResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_CalendarMonthResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CalendarMonthData,
  ));
}

/// Create a copy of CalendarMonthResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarMonthDataCopyWith<$Res> get data {
  
  return $CalendarMonthDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$CalendarMonthData {

 List<CalendarSchedule> get items;
/// Create a copy of CalendarMonthData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarMonthDataCopyWith<CalendarMonthData> get copyWith => _$CalendarMonthDataCopyWithImpl<CalendarMonthData>(this as CalendarMonthData, _$identity);

  /// Serializes this CalendarMonthData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CalendarMonthData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarMonthData&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CalendarMonthData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as CalendarMonthData;
  return 'CalendarMonthData(items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $CalendarMonthDataCopyWith<$Res>  {
  factory $CalendarMonthDataCopyWith(CalendarMonthData value, $Res Function(CalendarMonthData) _then) = _$CalendarMonthDataCopyWithImpl;
@useResult
$Res call({
 List<CalendarSchedule> items
});




}
/// @nodoc
class _$CalendarMonthDataCopyWithImpl<$Res>
    implements $CalendarMonthDataCopyWith<$Res> {
  _$CalendarMonthDataCopyWithImpl(this._self, this._then);

  final CalendarMonthData _self;
  final $Res Function(CalendarMonthData) _then;

/// Create a copy of CalendarMonthData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(CalendarMonthData(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CalendarSchedule>,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarMonthData].
extension CalendarMonthDataPatterns on CalendarMonthData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarMonthData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarMonthData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarMonthData value)  $default,){
final _that = this;
switch (_that) {
case _CalendarMonthData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarMonthData value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarMonthData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CalendarSchedule> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarMonthData() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CalendarSchedule> items)  $default,) {final _that = this;
switch (_that) {
case _CalendarMonthData():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CalendarSchedule> items)?  $default,) {final _that = this;
switch (_that) {
case _CalendarMonthData() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarMonthData implements CalendarMonthData {
  const _CalendarMonthData({ List<CalendarSchedule> items = const <CalendarSchedule>[]}): _items = items;
  factory _CalendarMonthData.fromJson(Map<String, dynamic> json) => _$CalendarMonthDataFromJson(json);

 final  List<CalendarSchedule> _items;
@override@JsonKey() List<CalendarSchedule> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of CalendarMonthData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarMonthDataCopyWith<_CalendarMonthData> get copyWith => __$CalendarMonthDataCopyWithImpl<_CalendarMonthData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarMonthDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarMonthData&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'CalendarMonthData(items: $items)';
}


}

/// @nodoc
abstract mixin class _$CalendarMonthDataCopyWith<$Res> implements $CalendarMonthDataCopyWith<$Res> {
  factory _$CalendarMonthDataCopyWith(_CalendarMonthData value, $Res Function(_CalendarMonthData) _then) = __$CalendarMonthDataCopyWithImpl;
@override @useResult
$Res call({
 List<CalendarSchedule> items
});




}
/// @nodoc
class __$CalendarMonthDataCopyWithImpl<$Res>
    implements _$CalendarMonthDataCopyWith<$Res> {
  __$CalendarMonthDataCopyWithImpl(this._self, this._then);

  final _CalendarMonthData _self;
  final $Res Function(_CalendarMonthData) _then;

/// Create a copy of CalendarMonthData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_CalendarMonthData(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CalendarSchedule>,
  ));
}


}


/// @nodoc
mixin _$CalendarSchedule {

 int get scheduleId; String get title; DateTime get startsAt; DateTime get endsAt;
/// Create a copy of CalendarSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarScheduleCopyWith<CalendarSchedule> get copyWith => _$CalendarScheduleCopyWithImpl<CalendarSchedule>(this as CalendarSchedule, _$identity);

  /// Serializes this CalendarSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CalendarSchedule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarSchedule&&(identical(other.scheduleId, _this.scheduleId) || other.scheduleId == _this.scheduleId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CalendarSchedule;
  return Object.hash(runtimeType,_this.scheduleId,_this.title,_this.startsAt,_this.endsAt);
}

@override
String toString() {
  final _this = this as CalendarSchedule;
  return 'CalendarSchedule(scheduleId: ${_this.scheduleId}, title: ${_this.title}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt})';
}


}

/// @nodoc
abstract mixin class $CalendarScheduleCopyWith<$Res>  {
  factory $CalendarScheduleCopyWith(CalendarSchedule value, $Res Function(CalendarSchedule) _then) = _$CalendarScheduleCopyWithImpl;
@useResult
$Res call({
 int scheduleId, String title, DateTime startsAt, DateTime endsAt
});




}
/// @nodoc
class _$CalendarScheduleCopyWithImpl<$Res>
    implements $CalendarScheduleCopyWith<$Res> {
  _$CalendarScheduleCopyWithImpl(this._self, this._then);

  final CalendarSchedule _self;
  final $Res Function(CalendarSchedule) _then;

/// Create a copy of CalendarSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleId = null,Object? title = null,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(CalendarSchedule(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarSchedule].
extension CalendarSchedulePatterns on CalendarSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarSchedule value)  $default,){
final _that = this;
switch (_that) {
case _CalendarSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scheduleId,  String title,  DateTime startsAt,  DateTime endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarSchedule() when $default != null:
return $default(_that.scheduleId,_that.title,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scheduleId,  String title,  DateTime startsAt,  DateTime endsAt)  $default,) {final _that = this;
switch (_that) {
case _CalendarSchedule():
return $default(_that.scheduleId,_that.title,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scheduleId,  String title,  DateTime startsAt,  DateTime endsAt)?  $default,) {final _that = this;
switch (_that) {
case _CalendarSchedule() when $default != null:
return $default(_that.scheduleId,_that.title,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarSchedule implements CalendarSchedule {
  const _CalendarSchedule({required this.scheduleId, required this.title, required this.startsAt, required this.endsAt});
  factory _CalendarSchedule.fromJson(Map<String, dynamic> json) => _$CalendarScheduleFromJson(json);

@override final  int scheduleId;
@override final  String title;
@override final  DateTime startsAt;
@override final  DateTime endsAt;

/// Create a copy of CalendarSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarScheduleCopyWith<_CalendarSchedule> get copyWith => __$CalendarScheduleCopyWithImpl<_CalendarSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarSchedule&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,scheduleId,title,startsAt,endsAt);
}

@override
String toString() {
    return 'CalendarSchedule(scheduleId: $scheduleId, title: $title, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$CalendarScheduleCopyWith<$Res> implements $CalendarScheduleCopyWith<$Res> {
  factory _$CalendarScheduleCopyWith(_CalendarSchedule value, $Res Function(_CalendarSchedule) _then) = __$CalendarScheduleCopyWithImpl;
@override @useResult
$Res call({
 int scheduleId, String title, DateTime startsAt, DateTime endsAt
});




}
/// @nodoc
class __$CalendarScheduleCopyWithImpl<$Res>
    implements _$CalendarScheduleCopyWith<$Res> {
  __$CalendarScheduleCopyWithImpl(this._self, this._then);

  final _CalendarSchedule _self;
  final $Res Function(_CalendarSchedule) _then;

/// Create a copy of CalendarSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleId = null,Object? title = null,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(_CalendarSchedule(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
