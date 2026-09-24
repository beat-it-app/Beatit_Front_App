// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_date_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarDateResponse {

 bool get success; int get status; String get message; CalendarDateData get data;
/// Create a copy of CalendarDateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarDateResponseCopyWith<CalendarDateResponse> get copyWith => _$CalendarDateResponseCopyWithImpl<CalendarDateResponse>(this as CalendarDateResponse, _$identity);

  /// Serializes this CalendarDateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CalendarDateResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarDateResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CalendarDateResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as CalendarDateResponse;
  return 'CalendarDateResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $CalendarDateResponseCopyWith<$Res>  {
  factory $CalendarDateResponseCopyWith(CalendarDateResponse value, $Res Function(CalendarDateResponse) _then) = _$CalendarDateResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, CalendarDateData data
});


$CalendarDateDataCopyWith<$Res> get data;

}
/// @nodoc
class _$CalendarDateResponseCopyWithImpl<$Res>
    implements $CalendarDateResponseCopyWith<$Res> {
  _$CalendarDateResponseCopyWithImpl(this._self, this._then);

  final CalendarDateResponse _self;
  final $Res Function(CalendarDateResponse) _then;

/// Create a copy of CalendarDateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(CalendarDateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CalendarDateData,
  ));
}
/// Create a copy of CalendarDateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarDateDataCopyWith<$Res> get data {
  
  return $CalendarDateDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CalendarDateResponse].
extension CalendarDateResponsePatterns on CalendarDateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarDateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarDateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarDateResponse value)  $default,){
final _that = this;
switch (_that) {
case _CalendarDateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarDateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarDateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CalendarDateData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarDateResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CalendarDateData data)  $default,) {final _that = this;
switch (_that) {
case _CalendarDateResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  CalendarDateData data)?  $default,) {final _that = this;
switch (_that) {
case _CalendarDateResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarDateResponse implements CalendarDateResponse {
  const _CalendarDateResponse({required this.success, required this.status, required this.message, required this.data});
  factory _CalendarDateResponse.fromJson(Map<String, dynamic> json) => _$CalendarDateResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  CalendarDateData data;

/// Create a copy of CalendarDateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarDateResponseCopyWith<_CalendarDateResponse> get copyWith => __$CalendarDateResponseCopyWithImpl<_CalendarDateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarDateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarDateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'CalendarDateResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CalendarDateResponseCopyWith<$Res> implements $CalendarDateResponseCopyWith<$Res> {
  factory _$CalendarDateResponseCopyWith(_CalendarDateResponse value, $Res Function(_CalendarDateResponse) _then) = __$CalendarDateResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, CalendarDateData data
});


@override $CalendarDateDataCopyWith<$Res> get data;

}
/// @nodoc
class __$CalendarDateResponseCopyWithImpl<$Res>
    implements _$CalendarDateResponseCopyWith<$Res> {
  __$CalendarDateResponseCopyWithImpl(this._self, this._then);

  final _CalendarDateResponse _self;
  final $Res Function(_CalendarDateResponse) _then;

/// Create a copy of CalendarDateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_CalendarDateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CalendarDateData,
  ));
}

/// Create a copy of CalendarDateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarDateDataCopyWith<$Res> get data {
  
  return $CalendarDateDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$CalendarDateData {

 List<DateSchedule> get items;
/// Create a copy of CalendarDateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarDateDataCopyWith<CalendarDateData> get copyWith => _$CalendarDateDataCopyWithImpl<CalendarDateData>(this as CalendarDateData, _$identity);

  /// Serializes this CalendarDateData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CalendarDateData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarDateData&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CalendarDateData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as CalendarDateData;
  return 'CalendarDateData(items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $CalendarDateDataCopyWith<$Res>  {
  factory $CalendarDateDataCopyWith(CalendarDateData value, $Res Function(CalendarDateData) _then) = _$CalendarDateDataCopyWithImpl;
@useResult
$Res call({
 List<DateSchedule> items
});




}
/// @nodoc
class _$CalendarDateDataCopyWithImpl<$Res>
    implements $CalendarDateDataCopyWith<$Res> {
  _$CalendarDateDataCopyWithImpl(this._self, this._then);

  final CalendarDateData _self;
  final $Res Function(CalendarDateData) _then;

/// Create a copy of CalendarDateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(CalendarDateData(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DateSchedule>,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarDateData].
extension CalendarDateDataPatterns on CalendarDateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarDateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarDateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarDateData value)  $default,){
final _that = this;
switch (_that) {
case _CalendarDateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarDateData value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarDateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DateSchedule> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarDateData() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DateSchedule> items)  $default,) {final _that = this;
switch (_that) {
case _CalendarDateData():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DateSchedule> items)?  $default,) {final _that = this;
switch (_that) {
case _CalendarDateData() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarDateData implements CalendarDateData {
  const _CalendarDateData({ List<DateSchedule> items = const <DateSchedule>[]}): _items = items;
  factory _CalendarDateData.fromJson(Map<String, dynamic> json) => _$CalendarDateDataFromJson(json);

 final  List<DateSchedule> _items;
@override@JsonKey() List<DateSchedule> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of CalendarDateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarDateDataCopyWith<_CalendarDateData> get copyWith => __$CalendarDateDataCopyWithImpl<_CalendarDateData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarDateDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarDateData&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'CalendarDateData(items: $items)';
}


}

/// @nodoc
abstract mixin class _$CalendarDateDataCopyWith<$Res> implements $CalendarDateDataCopyWith<$Res> {
  factory _$CalendarDateDataCopyWith(_CalendarDateData value, $Res Function(_CalendarDateData) _then) = __$CalendarDateDataCopyWithImpl;
@override @useResult
$Res call({
 List<DateSchedule> items
});




}
/// @nodoc
class __$CalendarDateDataCopyWithImpl<$Res>
    implements _$CalendarDateDataCopyWith<$Res> {
  __$CalendarDateDataCopyWithImpl(this._self, this._then);

  final _CalendarDateData _self;
  final $Res Function(_CalendarDateData) _then;

/// Create a copy of CalendarDateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_CalendarDateData(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DateSchedule>,
  ));
}


}


/// @nodoc
mixin _$DateSchedule {

 int get scheduleId; String get title; String get content; DateTime get startsAt; DateTime get endsAt; int? get locationId;
/// Create a copy of DateSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateScheduleCopyWith<DateSchedule> get copyWith => _$DateScheduleCopyWithImpl<DateSchedule>(this as DateSchedule, _$identity);

  /// Serializes this DateSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DateSchedule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateSchedule&&(identical(other.scheduleId, _this.scheduleId) || other.scheduleId == _this.scheduleId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.locationId, _this.locationId) || other.locationId == _this.locationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DateSchedule;
  return Object.hash(runtimeType,_this.scheduleId,_this.title,_this.content,_this.startsAt,_this.endsAt,_this.locationId);
}

@override
String toString() {
  final _this = this as DateSchedule;
  return 'DateSchedule(scheduleId: ${_this.scheduleId}, title: ${_this.title}, content: ${_this.content}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, locationId: ${_this.locationId})';
}


}

/// @nodoc
abstract mixin class $DateScheduleCopyWith<$Res>  {
  factory $DateScheduleCopyWith(DateSchedule value, $Res Function(DateSchedule) _then) = _$DateScheduleCopyWithImpl;
@useResult
$Res call({
 int scheduleId, String title, String content, DateTime startsAt, DateTime endsAt, int? locationId
});




}
/// @nodoc
class _$DateScheduleCopyWithImpl<$Res>
    implements $DateScheduleCopyWith<$Res> {
  _$DateScheduleCopyWithImpl(this._self, this._then);

  final DateSchedule _self;
  final $Res Function(DateSchedule) _then;

/// Create a copy of DateSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleId = null,Object? title = null,Object? content = null,Object? startsAt = null,Object? endsAt = null,Object? locationId = freezed,}) {
  return _then(DateSchedule(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DateSchedule].
extension DateSchedulePatterns on DateSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateSchedule value)  $default,){
final _that = this;
switch (_that) {
case _DateSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _DateSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int scheduleId,  String title,  String content,  DateTime startsAt,  DateTime endsAt,  int? locationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateSchedule() when $default != null:
return $default(_that.scheduleId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.locationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int scheduleId,  String title,  String content,  DateTime startsAt,  DateTime endsAt,  int? locationId)  $default,) {final _that = this;
switch (_that) {
case _DateSchedule():
return $default(_that.scheduleId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.locationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int scheduleId,  String title,  String content,  DateTime startsAt,  DateTime endsAt,  int? locationId)?  $default,) {final _that = this;
switch (_that) {
case _DateSchedule() when $default != null:
return $default(_that.scheduleId,_that.title,_that.content,_that.startsAt,_that.endsAt,_that.locationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DateSchedule implements DateSchedule {
  const _DateSchedule({required this.scheduleId, required this.title, required this.content, required this.startsAt, required this.endsAt, this.locationId});
  factory _DateSchedule.fromJson(Map<String, dynamic> json) => _$DateScheduleFromJson(json);

@override final  int scheduleId;
@override final  String title;
@override final  String content;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  int? locationId;

/// Create a copy of DateSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateScheduleCopyWith<_DateSchedule> get copyWith => __$DateScheduleCopyWithImpl<_DateSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DateScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateSchedule&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.locationId, locationId) || other.locationId == locationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,scheduleId,title,content,startsAt,endsAt,locationId);
}

@override
String toString() {
    return 'DateSchedule(scheduleId: $scheduleId, title: $title, content: $content, startsAt: $startsAt, endsAt: $endsAt, locationId: $locationId)';
}


}

/// @nodoc
abstract mixin class _$DateScheduleCopyWith<$Res> implements $DateScheduleCopyWith<$Res> {
  factory _$DateScheduleCopyWith(_DateSchedule value, $Res Function(_DateSchedule) _then) = __$DateScheduleCopyWithImpl;
@override @useResult
$Res call({
 int scheduleId, String title, String content, DateTime startsAt, DateTime endsAt, int? locationId
});




}
/// @nodoc
class __$DateScheduleCopyWithImpl<$Res>
    implements _$DateScheduleCopyWith<$Res> {
  __$DateScheduleCopyWithImpl(this._self, this._then);

  final _DateSchedule _self;
  final $Res Function(_DateSchedule) _then;

/// Create a copy of DateSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleId = null,Object? title = null,Object? content = null,Object? startsAt = null,Object? endsAt = null,Object? locationId = freezed,}) {
  return _then(_DateSchedule(
scheduleId: null == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
