// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlarmListResponse {

 bool get success; int get status; String? get message; AlarmPageResponse get data;
/// Create a copy of AlarmListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmListResponseCopyWith<AlarmListResponse> get copyWith => _$AlarmListResponseCopyWithImpl<AlarmListResponse>(this as AlarmListResponse, _$identity);

  /// Serializes this AlarmListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlarmListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmListResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlarmListResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as AlarmListResponse;
  return 'AlarmListResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $AlarmListResponseCopyWith<$Res>  {
  factory $AlarmListResponseCopyWith(AlarmListResponse value, $Res Function(AlarmListResponse) _then) = _$AlarmListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String? message, AlarmPageResponse data
});


$AlarmPageResponseCopyWith<$Res> get data;

}
/// @nodoc
class _$AlarmListResponseCopyWithImpl<$Res>
    implements $AlarmListResponseCopyWith<$Res> {
  _$AlarmListResponseCopyWithImpl(this._self, this._then);

  final AlarmListResponse _self;
  final $Res Function(AlarmListResponse) _then;

/// Create a copy of AlarmListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(AlarmListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AlarmPageResponse,
  ));
}
/// Create a copy of AlarmListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlarmPageResponseCopyWith<$Res> get data {
  
  return $AlarmPageResponseCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AlarmListResponse].
extension AlarmListResponsePatterns on AlarmListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AlarmListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  AlarmPageResponse data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  AlarmPageResponse data)  $default,) {final _that = this;
switch (_that) {
case _AlarmListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String? message,  AlarmPageResponse data)?  $default,) {final _that = this;
switch (_that) {
case _AlarmListResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlarmListResponse implements AlarmListResponse {
  const _AlarmListResponse({required this.success, required this.status, this.message, required this.data});
  factory _AlarmListResponse.fromJson(Map<String, dynamic> json) => _$AlarmListResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String? message;
@override final  AlarmPageResponse data;

/// Create a copy of AlarmListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmListResponseCopyWith<_AlarmListResponse> get copyWith => __$AlarmListResponseCopyWithImpl<_AlarmListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'AlarmListResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AlarmListResponseCopyWith<$Res> implements $AlarmListResponseCopyWith<$Res> {
  factory _$AlarmListResponseCopyWith(_AlarmListResponse value, $Res Function(_AlarmListResponse) _then) = __$AlarmListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String? message, AlarmPageResponse data
});


@override $AlarmPageResponseCopyWith<$Res> get data;

}
/// @nodoc
class __$AlarmListResponseCopyWithImpl<$Res>
    implements _$AlarmListResponseCopyWith<$Res> {
  __$AlarmListResponseCopyWithImpl(this._self, this._then);

  final _AlarmListResponse _self;
  final $Res Function(_AlarmListResponse) _then;

/// Create a copy of AlarmListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(_AlarmListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AlarmPageResponse,
  ));
}

/// Create a copy of AlarmListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlarmPageResponseCopyWith<$Res> get data {
  
  return $AlarmPageResponseCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AlarmPageResponse {

 int get teamId; String get teamName; int get unreadCount; bool get hasUnread; int get page; int get size; int get totalElements; int get totalPages; bool get isLast; List<AlarmNotification> get notifications;
/// Create a copy of AlarmPageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmPageResponseCopyWith<AlarmPageResponse> get copyWith => _$AlarmPageResponseCopyWithImpl<AlarmPageResponse>(this as AlarmPageResponse, _$identity);

  /// Serializes this AlarmPageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlarmPageResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmPageResponse&&(identical(other.teamId, _this.teamId) || other.teamId == _this.teamId)&&(identical(other.teamName, _this.teamName) || other.teamName == _this.teamName)&&(identical(other.unreadCount, _this.unreadCount) || other.unreadCount == _this.unreadCount)&&(identical(other.hasUnread, _this.hasUnread) || other.hasUnread == _this.hasUnread)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.totalElements, _this.totalElements) || other.totalElements == _this.totalElements)&&(identical(other.totalPages, _this.totalPages) || other.totalPages == _this.totalPages)&&(identical(other.isLast, _this.isLast) || other.isLast == _this.isLast)&&const DeepCollectionEquality().equals(other.notifications, _this.notifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlarmPageResponse;
  return Object.hash(runtimeType,_this.teamId,_this.teamName,_this.unreadCount,_this.hasUnread,_this.page,_this.size,_this.totalElements,_this.totalPages,_this.isLast,const DeepCollectionEquality().hash(_this.notifications));
}

@override
String toString() {
  final _this = this as AlarmPageResponse;
  return 'AlarmPageResponse(teamId: ${_this.teamId}, teamName: ${_this.teamName}, unreadCount: ${_this.unreadCount}, hasUnread: ${_this.hasUnread}, page: ${_this.page}, size: ${_this.size}, totalElements: ${_this.totalElements}, totalPages: ${_this.totalPages}, isLast: ${_this.isLast}, notifications: ${_this.notifications})';
}


}

/// @nodoc
abstract mixin class $AlarmPageResponseCopyWith<$Res>  {
  factory $AlarmPageResponseCopyWith(AlarmPageResponse value, $Res Function(AlarmPageResponse) _then) = _$AlarmPageResponseCopyWithImpl;
@useResult
$Res call({
 int teamId, String teamName, int unreadCount, bool hasUnread, int page, int size, int totalElements, int totalPages, bool isLast, List<AlarmNotification> notifications
});




}
/// @nodoc
class _$AlarmPageResponseCopyWithImpl<$Res>
    implements $AlarmPageResponseCopyWith<$Res> {
  _$AlarmPageResponseCopyWithImpl(this._self, this._then);

  final AlarmPageResponse _self;
  final $Res Function(AlarmPageResponse) _then;

/// Create a copy of AlarmPageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamId = null,Object? teamName = null,Object? unreadCount = null,Object? hasUnread = null,Object? page = null,Object? size = null,Object? totalElements = null,Object? totalPages = null,Object? isLast = null,Object? notifications = null,}) {
  return _then(AlarmPageResponse(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as int,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,hasUnread: null == hasUnread ? _self.hasUnread : hasUnread // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,isLast: null == isLast ? _self.isLast : isLast // ignore: cast_nullable_to_non_nullable
as bool,notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<AlarmNotification>,
  ));
}

}


/// Adds pattern-matching-related methods to [AlarmPageResponse].
extension AlarmPageResponsePatterns on AlarmPageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmPageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmPageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmPageResponse value)  $default,){
final _that = this;
switch (_that) {
case _AlarmPageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmPageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmPageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int teamId,  String teamName,  int unreadCount,  bool hasUnread,  int page,  int size,  int totalElements,  int totalPages,  bool isLast,  List<AlarmNotification> notifications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmPageResponse() when $default != null:
return $default(_that.teamId,_that.teamName,_that.unreadCount,_that.hasUnread,_that.page,_that.size,_that.totalElements,_that.totalPages,_that.isLast,_that.notifications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int teamId,  String teamName,  int unreadCount,  bool hasUnread,  int page,  int size,  int totalElements,  int totalPages,  bool isLast,  List<AlarmNotification> notifications)  $default,) {final _that = this;
switch (_that) {
case _AlarmPageResponse():
return $default(_that.teamId,_that.teamName,_that.unreadCount,_that.hasUnread,_that.page,_that.size,_that.totalElements,_that.totalPages,_that.isLast,_that.notifications);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int teamId,  String teamName,  int unreadCount,  bool hasUnread,  int page,  int size,  int totalElements,  int totalPages,  bool isLast,  List<AlarmNotification> notifications)?  $default,) {final _that = this;
switch (_that) {
case _AlarmPageResponse() when $default != null:
return $default(_that.teamId,_that.teamName,_that.unreadCount,_that.hasUnread,_that.page,_that.size,_that.totalElements,_that.totalPages,_that.isLast,_that.notifications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlarmPageResponse implements AlarmPageResponse {
  const _AlarmPageResponse({required this.teamId, required this.teamName, required this.unreadCount, required this.hasUnread, required this.page, required this.size, required this.totalElements, required this.totalPages, required this.isLast,  List<AlarmNotification> notifications = const <AlarmNotification>[]}): _notifications = notifications;
  factory _AlarmPageResponse.fromJson(Map<String, dynamic> json) => _$AlarmPageResponseFromJson(json);

@override final  int teamId;
@override final  String teamName;
@override final  int unreadCount;
@override final  bool hasUnread;
@override final  int page;
@override final  int size;
@override final  int totalElements;
@override final  int totalPages;
@override final  bool isLast;
 final  List<AlarmNotification> _notifications;
@override@JsonKey() List<AlarmNotification> get notifications {
  if (_notifications is EqualUnmodifiableListView) return _notifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notifications);
}


/// Create a copy of AlarmPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmPageResponseCopyWith<_AlarmPageResponse> get copyWith => __$AlarmPageResponseCopyWithImpl<_AlarmPageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmPageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmPageResponse&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.hasUnread, hasUnread) || other.hasUnread == hasUnread)&&(identical(other.page, page) || other.page == page)&&(identical(other.size, size) || other.size == size)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.isLast, isLast) || other.isLast == isLast)&&const DeepCollectionEquality().equals(other.notifications, _notifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,teamId,teamName,unreadCount,hasUnread,page,size,totalElements,totalPages,isLast,const DeepCollectionEquality().hash(_notifications));
}

@override
String toString() {
    return 'AlarmPageResponse(teamId: $teamId, teamName: $teamName, unreadCount: $unreadCount, hasUnread: $hasUnread, page: $page, size: $size, totalElements: $totalElements, totalPages: $totalPages, isLast: $isLast, notifications: $notifications)';
}


}

/// @nodoc
abstract mixin class _$AlarmPageResponseCopyWith<$Res> implements $AlarmPageResponseCopyWith<$Res> {
  factory _$AlarmPageResponseCopyWith(_AlarmPageResponse value, $Res Function(_AlarmPageResponse) _then) = __$AlarmPageResponseCopyWithImpl;
@override @useResult
$Res call({
 int teamId, String teamName, int unreadCount, bool hasUnread, int page, int size, int totalElements, int totalPages, bool isLast, List<AlarmNotification> notifications
});




}
/// @nodoc
class __$AlarmPageResponseCopyWithImpl<$Res>
    implements _$AlarmPageResponseCopyWith<$Res> {
  __$AlarmPageResponseCopyWithImpl(this._self, this._then);

  final _AlarmPageResponse _self;
  final $Res Function(_AlarmPageResponse) _then;

/// Create a copy of AlarmPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamId = null,Object? teamName = null,Object? unreadCount = null,Object? hasUnread = null,Object? page = null,Object? size = null,Object? totalElements = null,Object? totalPages = null,Object? isLast = null,Object? notifications = null,}) {
  return _then(_AlarmPageResponse(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as int,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,hasUnread: null == hasUnread ? _self.hasUnread : hasUnread // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,isLast: null == isLast ? _self.isLast : isLast // ignore: cast_nullable_to_non_nullable
as bool,notifications: null == notifications ? _self._notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<AlarmNotification>,
  ));
}


}


/// @nodoc
mixin _$AlarmNotification {

@JsonKey(name: 'notificationId') int get id; String get category; String get type; String get title; String get content; String? get directTo; int? get targetId; bool get isRead; DateTime get createdAt;
/// Create a copy of AlarmNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmNotificationCopyWith<AlarmNotification> get copyWith => _$AlarmNotificationCopyWithImpl<AlarmNotification>(this as AlarmNotification, _$identity);

  /// Serializes this AlarmNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlarmNotification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmNotification&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.directTo, _this.directTo) || other.directTo == _this.directTo)&&(identical(other.targetId, _this.targetId) || other.targetId == _this.targetId)&&(identical(other.isRead, _this.isRead) || other.isRead == _this.isRead)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlarmNotification;
  return Object.hash(runtimeType,_this.id,_this.category,_this.type,_this.title,_this.content,_this.directTo,_this.targetId,_this.isRead,_this.createdAt);
}

@override
String toString() {
  final _this = this as AlarmNotification;
  return 'AlarmNotification(id: ${_this.id}, category: ${_this.category}, type: ${_this.type}, title: ${_this.title}, content: ${_this.content}, directTo: ${_this.directTo}, targetId: ${_this.targetId}, isRead: ${_this.isRead}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $AlarmNotificationCopyWith<$Res>  {
  factory $AlarmNotificationCopyWith(AlarmNotification value, $Res Function(AlarmNotification) _then) = _$AlarmNotificationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'notificationId') int id, String category, String type, String title, String content, String? directTo, int? targetId, bool isRead, DateTime createdAt
});




}
/// @nodoc
class _$AlarmNotificationCopyWithImpl<$Res>
    implements $AlarmNotificationCopyWith<$Res> {
  _$AlarmNotificationCopyWithImpl(this._self, this._then);

  final AlarmNotification _self;
  final $Res Function(AlarmNotification) _then;

/// Create a copy of AlarmNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? type = null,Object? title = null,Object? content = null,Object? directTo = freezed,Object? targetId = freezed,Object? isRead = null,Object? createdAt = null,}) {
  return _then(AlarmNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,directTo: freezed == directTo ? _self.directTo : directTo // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as int?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AlarmNotification].
extension AlarmNotificationPatterns on AlarmNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmNotification value)  $default,){
final _that = this;
switch (_that) {
case _AlarmNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmNotification value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'notificationId')  int id,  String category,  String type,  String title,  String content,  String? directTo,  int? targetId,  bool isRead,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmNotification() when $default != null:
return $default(_that.id,_that.category,_that.type,_that.title,_that.content,_that.directTo,_that.targetId,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'notificationId')  int id,  String category,  String type,  String title,  String content,  String? directTo,  int? targetId,  bool isRead,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AlarmNotification():
return $default(_that.id,_that.category,_that.type,_that.title,_that.content,_that.directTo,_that.targetId,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'notificationId')  int id,  String category,  String type,  String title,  String content,  String? directTo,  int? targetId,  bool isRead,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AlarmNotification() when $default != null:
return $default(_that.id,_that.category,_that.type,_that.title,_that.content,_that.directTo,_that.targetId,_that.isRead,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlarmNotification implements AlarmNotification {
  const _AlarmNotification({@JsonKey(name: 'notificationId') required this.id, required this.category, required this.type, required this.title, required this.content, this.directTo, this.targetId, required this.isRead, required this.createdAt});
  factory _AlarmNotification.fromJson(Map<String, dynamic> json) => _$AlarmNotificationFromJson(json);

@override@JsonKey(name: 'notificationId') final  int id;
@override final  String category;
@override final  String type;
@override final  String title;
@override final  String content;
@override final  String? directTo;
@override final  int? targetId;
@override final  bool isRead;
@override final  DateTime createdAt;

/// Create a copy of AlarmNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmNotificationCopyWith<_AlarmNotification> get copyWith => __$AlarmNotificationCopyWithImpl<_AlarmNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.directTo, directTo) || other.directTo == directTo)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,category,type,title,content,directTo,targetId,isRead,createdAt);
}

@override
String toString() {
    return 'AlarmNotification(id: $id, category: $category, type: $type, title: $title, content: $content, directTo: $directTo, targetId: $targetId, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AlarmNotificationCopyWith<$Res> implements $AlarmNotificationCopyWith<$Res> {
  factory _$AlarmNotificationCopyWith(_AlarmNotification value, $Res Function(_AlarmNotification) _then) = __$AlarmNotificationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'notificationId') int id, String category, String type, String title, String content, String? directTo, int? targetId, bool isRead, DateTime createdAt
});




}
/// @nodoc
class __$AlarmNotificationCopyWithImpl<$Res>
    implements _$AlarmNotificationCopyWith<$Res> {
  __$AlarmNotificationCopyWithImpl(this._self, this._then);

  final _AlarmNotification _self;
  final $Res Function(_AlarmNotification) _then;

/// Create a copy of AlarmNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? type = null,Object? title = null,Object? content = null,Object? directTo = freezed,Object? targetId = freezed,Object? isRead = null,Object? createdAt = null,}) {
  return _then(_AlarmNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,directTo: freezed == directTo ? _self.directTo : directTo // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as int?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AlarmActionResponse {

 bool get success; int get status; String? get message; AlarmClickResponse get data;
/// Create a copy of AlarmActionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmActionResponseCopyWith<AlarmActionResponse> get copyWith => _$AlarmActionResponseCopyWithImpl<AlarmActionResponse>(this as AlarmActionResponse, _$identity);

  /// Serializes this AlarmActionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlarmActionResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmActionResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlarmActionResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as AlarmActionResponse;
  return 'AlarmActionResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $AlarmActionResponseCopyWith<$Res>  {
  factory $AlarmActionResponseCopyWith(AlarmActionResponse value, $Res Function(AlarmActionResponse) _then) = _$AlarmActionResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String? message, AlarmClickResponse data
});


$AlarmClickResponseCopyWith<$Res> get data;

}
/// @nodoc
class _$AlarmActionResponseCopyWithImpl<$Res>
    implements $AlarmActionResponseCopyWith<$Res> {
  _$AlarmActionResponseCopyWithImpl(this._self, this._then);

  final AlarmActionResponse _self;
  final $Res Function(AlarmActionResponse) _then;

/// Create a copy of AlarmActionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(AlarmActionResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AlarmClickResponse,
  ));
}
/// Create a copy of AlarmActionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlarmClickResponseCopyWith<$Res> get data {
  
  return $AlarmClickResponseCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AlarmActionResponse].
extension AlarmActionResponsePatterns on AlarmActionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmActionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmActionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmActionResponse value)  $default,){
final _that = this;
switch (_that) {
case _AlarmActionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmActionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmActionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  AlarmClickResponse data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmActionResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  AlarmClickResponse data)  $default,) {final _that = this;
switch (_that) {
case _AlarmActionResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String? message,  AlarmClickResponse data)?  $default,) {final _that = this;
switch (_that) {
case _AlarmActionResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlarmActionResponse implements AlarmActionResponse {
  const _AlarmActionResponse({required this.success, required this.status, this.message, required this.data});
  factory _AlarmActionResponse.fromJson(Map<String, dynamic> json) => _$AlarmActionResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String? message;
@override final  AlarmClickResponse data;

/// Create a copy of AlarmActionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmActionResponseCopyWith<_AlarmActionResponse> get copyWith => __$AlarmActionResponseCopyWithImpl<_AlarmActionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmActionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmActionResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'AlarmActionResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AlarmActionResponseCopyWith<$Res> implements $AlarmActionResponseCopyWith<$Res> {
  factory _$AlarmActionResponseCopyWith(_AlarmActionResponse value, $Res Function(_AlarmActionResponse) _then) = __$AlarmActionResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String? message, AlarmClickResponse data
});


@override $AlarmClickResponseCopyWith<$Res> get data;

}
/// @nodoc
class __$AlarmActionResponseCopyWithImpl<$Res>
    implements _$AlarmActionResponseCopyWith<$Res> {
  __$AlarmActionResponseCopyWithImpl(this._self, this._then);

  final _AlarmActionResponse _self;
  final $Res Function(_AlarmActionResponse) _then;

/// Create a copy of AlarmActionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(_AlarmActionResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AlarmClickResponse,
  ));
}

/// Create a copy of AlarmActionResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlarmClickResponseCopyWith<$Res> get data {
  
  return $AlarmClickResponseCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AlarmClickResponse {

 int get notificationId; int get targetTeamId; String get targetTeamName; String? get directTo; int? get targetId; bool get isRead;
/// Create a copy of AlarmClickResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmClickResponseCopyWith<AlarmClickResponse> get copyWith => _$AlarmClickResponseCopyWithImpl<AlarmClickResponse>(this as AlarmClickResponse, _$identity);

  /// Serializes this AlarmClickResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlarmClickResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmClickResponse&&(identical(other.notificationId, _this.notificationId) || other.notificationId == _this.notificationId)&&(identical(other.targetTeamId, _this.targetTeamId) || other.targetTeamId == _this.targetTeamId)&&(identical(other.targetTeamName, _this.targetTeamName) || other.targetTeamName == _this.targetTeamName)&&(identical(other.directTo, _this.directTo) || other.directTo == _this.directTo)&&(identical(other.targetId, _this.targetId) || other.targetId == _this.targetId)&&(identical(other.isRead, _this.isRead) || other.isRead == _this.isRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlarmClickResponse;
  return Object.hash(runtimeType,_this.notificationId,_this.targetTeamId,_this.targetTeamName,_this.directTo,_this.targetId,_this.isRead);
}

@override
String toString() {
  final _this = this as AlarmClickResponse;
  return 'AlarmClickResponse(notificationId: ${_this.notificationId}, targetTeamId: ${_this.targetTeamId}, targetTeamName: ${_this.targetTeamName}, directTo: ${_this.directTo}, targetId: ${_this.targetId}, isRead: ${_this.isRead})';
}


}

/// @nodoc
abstract mixin class $AlarmClickResponseCopyWith<$Res>  {
  factory $AlarmClickResponseCopyWith(AlarmClickResponse value, $Res Function(AlarmClickResponse) _then) = _$AlarmClickResponseCopyWithImpl;
@useResult
$Res call({
 int notificationId, int targetTeamId, String targetTeamName, String? directTo, int? targetId, bool isRead
});




}
/// @nodoc
class _$AlarmClickResponseCopyWithImpl<$Res>
    implements $AlarmClickResponseCopyWith<$Res> {
  _$AlarmClickResponseCopyWithImpl(this._self, this._then);

  final AlarmClickResponse _self;
  final $Res Function(AlarmClickResponse) _then;

/// Create a copy of AlarmClickResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationId = null,Object? targetTeamId = null,Object? targetTeamName = null,Object? directTo = freezed,Object? targetId = freezed,Object? isRead = null,}) {
  return _then(AlarmClickResponse(
notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,targetTeamId: null == targetTeamId ? _self.targetTeamId : targetTeamId // ignore: cast_nullable_to_non_nullable
as int,targetTeamName: null == targetTeamName ? _self.targetTeamName : targetTeamName // ignore: cast_nullable_to_non_nullable
as String,directTo: freezed == directTo ? _self.directTo : directTo // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as int?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AlarmClickResponse].
extension AlarmClickResponsePatterns on AlarmClickResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmClickResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmClickResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmClickResponse value)  $default,){
final _that = this;
switch (_that) {
case _AlarmClickResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmClickResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmClickResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int notificationId,  int targetTeamId,  String targetTeamName,  String? directTo,  int? targetId,  bool isRead)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmClickResponse() when $default != null:
return $default(_that.notificationId,_that.targetTeamId,_that.targetTeamName,_that.directTo,_that.targetId,_that.isRead);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int notificationId,  int targetTeamId,  String targetTeamName,  String? directTo,  int? targetId,  bool isRead)  $default,) {final _that = this;
switch (_that) {
case _AlarmClickResponse():
return $default(_that.notificationId,_that.targetTeamId,_that.targetTeamName,_that.directTo,_that.targetId,_that.isRead);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int notificationId,  int targetTeamId,  String targetTeamName,  String? directTo,  int? targetId,  bool isRead)?  $default,) {final _that = this;
switch (_that) {
case _AlarmClickResponse() when $default != null:
return $default(_that.notificationId,_that.targetTeamId,_that.targetTeamName,_that.directTo,_that.targetId,_that.isRead);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlarmClickResponse implements AlarmClickResponse {
  const _AlarmClickResponse({required this.notificationId, required this.targetTeamId, required this.targetTeamName, this.directTo, this.targetId, required this.isRead});
  factory _AlarmClickResponse.fromJson(Map<String, dynamic> json) => _$AlarmClickResponseFromJson(json);

@override final  int notificationId;
@override final  int targetTeamId;
@override final  String targetTeamName;
@override final  String? directTo;
@override final  int? targetId;
@override final  bool isRead;

/// Create a copy of AlarmClickResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmClickResponseCopyWith<_AlarmClickResponse> get copyWith => __$AlarmClickResponseCopyWithImpl<_AlarmClickResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmClickResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmClickResponse&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.targetTeamId, targetTeamId) || other.targetTeamId == targetTeamId)&&(identical(other.targetTeamName, targetTeamName) || other.targetTeamName == targetTeamName)&&(identical(other.directTo, directTo) || other.directTo == directTo)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,notificationId,targetTeamId,targetTeamName,directTo,targetId,isRead);
}

@override
String toString() {
    return 'AlarmClickResponse(notificationId: $notificationId, targetTeamId: $targetTeamId, targetTeamName: $targetTeamName, directTo: $directTo, targetId: $targetId, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class _$AlarmClickResponseCopyWith<$Res> implements $AlarmClickResponseCopyWith<$Res> {
  factory _$AlarmClickResponseCopyWith(_AlarmClickResponse value, $Res Function(_AlarmClickResponse) _then) = __$AlarmClickResponseCopyWithImpl;
@override @useResult
$Res call({
 int notificationId, int targetTeamId, String targetTeamName, String? directTo, int? targetId, bool isRead
});




}
/// @nodoc
class __$AlarmClickResponseCopyWithImpl<$Res>
    implements _$AlarmClickResponseCopyWith<$Res> {
  __$AlarmClickResponseCopyWithImpl(this._self, this._then);

  final _AlarmClickResponse _self;
  final $Res Function(_AlarmClickResponse) _then;

/// Create a copy of AlarmClickResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationId = null,Object? targetTeamId = null,Object? targetTeamName = null,Object? directTo = freezed,Object? targetId = freezed,Object? isRead = null,}) {
  return _then(_AlarmClickResponse(
notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,targetTeamId: null == targetTeamId ? _self.targetTeamId : targetTeamId // ignore: cast_nullable_to_non_nullable
as int,targetTeamName: null == targetTeamName ? _self.targetTeamName : targetTeamName // ignore: cast_nullable_to_non_nullable
as String,directTo: freezed == directTo ? _self.directTo : directTo // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as int?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AlarmReadAllResponse {

 bool get success; int get status; String? get message;
/// Create a copy of AlarmReadAllResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmReadAllResponseCopyWith<AlarmReadAllResponse> get copyWith => _$AlarmReadAllResponseCopyWithImpl<AlarmReadAllResponse>(this as AlarmReadAllResponse, _$identity);

  /// Serializes this AlarmReadAllResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlarmReadAllResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmReadAllResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlarmReadAllResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message);
}

@override
String toString() {
  final _this = this as AlarmReadAllResponse;
  return 'AlarmReadAllResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $AlarmReadAllResponseCopyWith<$Res>  {
  factory $AlarmReadAllResponseCopyWith(AlarmReadAllResponse value, $Res Function(AlarmReadAllResponse) _then) = _$AlarmReadAllResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String? message
});




}
/// @nodoc
class _$AlarmReadAllResponseCopyWithImpl<$Res>
    implements $AlarmReadAllResponseCopyWith<$Res> {
  _$AlarmReadAllResponseCopyWithImpl(this._self, this._then);

  final AlarmReadAllResponse _self;
  final $Res Function(AlarmReadAllResponse) _then;

/// Create a copy of AlarmReadAllResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = freezed,}) {
  return _then(AlarmReadAllResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AlarmReadAllResponse].
extension AlarmReadAllResponsePatterns on AlarmReadAllResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmReadAllResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmReadAllResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmReadAllResponse value)  $default,){
final _that = this;
switch (_that) {
case _AlarmReadAllResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmReadAllResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmReadAllResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmReadAllResponse() when $default != null:
return $default(_that.success,_that.status,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String? message)  $default,) {final _that = this;
switch (_that) {
case _AlarmReadAllResponse():
return $default(_that.success,_that.status,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _AlarmReadAllResponse() when $default != null:
return $default(_that.success,_that.status,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlarmReadAllResponse implements AlarmReadAllResponse {
  const _AlarmReadAllResponse({required this.success, required this.status, this.message});
  factory _AlarmReadAllResponse.fromJson(Map<String, dynamic> json) => _$AlarmReadAllResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String? message;

/// Create a copy of AlarmReadAllResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmReadAllResponseCopyWith<_AlarmReadAllResponse> get copyWith => __$AlarmReadAllResponseCopyWithImpl<_AlarmReadAllResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmReadAllResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmReadAllResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message);
}

@override
String toString() {
    return 'AlarmReadAllResponse(success: $success, status: $status, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AlarmReadAllResponseCopyWith<$Res> implements $AlarmReadAllResponseCopyWith<$Res> {
  factory _$AlarmReadAllResponseCopyWith(_AlarmReadAllResponse value, $Res Function(_AlarmReadAllResponse) _then) = __$AlarmReadAllResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String? message
});




}
/// @nodoc
class __$AlarmReadAllResponseCopyWithImpl<$Res>
    implements _$AlarmReadAllResponseCopyWith<$Res> {
  __$AlarmReadAllResponseCopyWithImpl(this._self, this._then);

  final _AlarmReadAllResponse _self;
  final $Res Function(_AlarmReadAllResponse) _then;

/// Create a copy of AlarmReadAllResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = freezed,}) {
  return _then(_AlarmReadAllResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
