// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRoomListResponse {

 bool get success; int get status; String? get message; ChatRoomListData get data;
/// Create a copy of ChatRoomListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomListResponseCopyWith<ChatRoomListResponse> get copyWith => _$ChatRoomListResponseCopyWithImpl<ChatRoomListResponse>(this as ChatRoomListResponse, _$identity);

  /// Serializes this ChatRoomListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRoomListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomListResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRoomListResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as ChatRoomListResponse;
  return 'ChatRoomListResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $ChatRoomListResponseCopyWith<$Res>  {
  factory $ChatRoomListResponseCopyWith(ChatRoomListResponse value, $Res Function(ChatRoomListResponse) _then) = _$ChatRoomListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String? message, ChatRoomListData data
});


$ChatRoomListDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ChatRoomListResponseCopyWithImpl<$Res>
    implements $ChatRoomListResponseCopyWith<$Res> {
  _$ChatRoomListResponseCopyWithImpl(this._self, this._then);

  final ChatRoomListResponse _self;
  final $Res Function(ChatRoomListResponse) _then;

/// Create a copy of ChatRoomListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(ChatRoomListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChatRoomListData,
  ));
}
/// Create a copy of ChatRoomListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatRoomListDataCopyWith<$Res> get data {
  
  return $ChatRoomListDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatRoomListResponse].
extension ChatRoomListResponsePatterns on ChatRoomListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRoomListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRoomListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRoomListResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatRoomListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRoomListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRoomListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  ChatRoomListData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRoomListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  ChatRoomListData data)  $default,) {final _that = this;
switch (_that) {
case _ChatRoomListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String? message,  ChatRoomListData data)?  $default,) {final _that = this;
switch (_that) {
case _ChatRoomListResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRoomListResponse implements ChatRoomListResponse {
  const _ChatRoomListResponse({required this.success, required this.status, this.message, required this.data});
  factory _ChatRoomListResponse.fromJson(Map<String, dynamic> json) => _$ChatRoomListResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String? message;
@override final  ChatRoomListData data;

/// Create a copy of ChatRoomListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomListResponseCopyWith<_ChatRoomListResponse> get copyWith => __$ChatRoomListResponseCopyWithImpl<_ChatRoomListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'ChatRoomListResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomListResponseCopyWith<$Res> implements $ChatRoomListResponseCopyWith<$Res> {
  factory _$ChatRoomListResponseCopyWith(_ChatRoomListResponse value, $Res Function(_ChatRoomListResponse) _then) = __$ChatRoomListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String? message, ChatRoomListData data
});


@override $ChatRoomListDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ChatRoomListResponseCopyWithImpl<$Res>
    implements _$ChatRoomListResponseCopyWith<$Res> {
  __$ChatRoomListResponseCopyWithImpl(this._self, this._then);

  final _ChatRoomListResponse _self;
  final $Res Function(_ChatRoomListResponse) _then;

/// Create a copy of ChatRoomListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(_ChatRoomListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChatRoomListData,
  ));
}

/// Create a copy of ChatRoomListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatRoomListDataCopyWith<$Res> get data {
  
  return $ChatRoomListDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ChatRoomListData {

 List<ChatRoomSummary> get chatroomList;
/// Create a copy of ChatRoomListData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomListDataCopyWith<ChatRoomListData> get copyWith => _$ChatRoomListDataCopyWithImpl<ChatRoomListData>(this as ChatRoomListData, _$identity);

  /// Serializes this ChatRoomListData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRoomListData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomListData&&const DeepCollectionEquality().equals(other.chatroomList, _this.chatroomList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRoomListData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.chatroomList));
}

@override
String toString() {
  final _this = this as ChatRoomListData;
  return 'ChatRoomListData(chatroomList: ${_this.chatroomList})';
}


}

/// @nodoc
abstract mixin class $ChatRoomListDataCopyWith<$Res>  {
  factory $ChatRoomListDataCopyWith(ChatRoomListData value, $Res Function(ChatRoomListData) _then) = _$ChatRoomListDataCopyWithImpl;
@useResult
$Res call({
 List<ChatRoomSummary> chatroomList
});




}
/// @nodoc
class _$ChatRoomListDataCopyWithImpl<$Res>
    implements $ChatRoomListDataCopyWith<$Res> {
  _$ChatRoomListDataCopyWithImpl(this._self, this._then);

  final ChatRoomListData _self;
  final $Res Function(ChatRoomListData) _then;

/// Create a copy of ChatRoomListData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatroomList = null,}) {
  return _then(ChatRoomListData(
chatroomList: null == chatroomList ? _self.chatroomList : chatroomList // ignore: cast_nullable_to_non_nullable
as List<ChatRoomSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatRoomListData].
extension ChatRoomListDataPatterns on ChatRoomListData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRoomListData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRoomListData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRoomListData value)  $default,){
final _that = this;
switch (_that) {
case _ChatRoomListData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRoomListData value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRoomListData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatRoomSummary> chatroomList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRoomListData() when $default != null:
return $default(_that.chatroomList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatRoomSummary> chatroomList)  $default,) {final _that = this;
switch (_that) {
case _ChatRoomListData():
return $default(_that.chatroomList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatRoomSummary> chatroomList)?  $default,) {final _that = this;
switch (_that) {
case _ChatRoomListData() when $default != null:
return $default(_that.chatroomList);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRoomListData implements ChatRoomListData {
  const _ChatRoomListData({ List<ChatRoomSummary> chatroomList = const <ChatRoomSummary>[]}): _chatroomList = chatroomList;
  factory _ChatRoomListData.fromJson(Map<String, dynamic> json) => _$ChatRoomListDataFromJson(json);

 final  List<ChatRoomSummary> _chatroomList;
@override@JsonKey() List<ChatRoomSummary> get chatroomList {
  if (_chatroomList is EqualUnmodifiableListView) return _chatroomList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chatroomList);
}


/// Create a copy of ChatRoomListData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomListDataCopyWith<_ChatRoomListData> get copyWith => __$ChatRoomListDataCopyWithImpl<_ChatRoomListData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomListDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomListData&&const DeepCollectionEquality().equals(other.chatroomList, _chatroomList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_chatroomList));
}

@override
String toString() {
    return 'ChatRoomListData(chatroomList: $chatroomList)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomListDataCopyWith<$Res> implements $ChatRoomListDataCopyWith<$Res> {
  factory _$ChatRoomListDataCopyWith(_ChatRoomListData value, $Res Function(_ChatRoomListData) _then) = __$ChatRoomListDataCopyWithImpl;
@override @useResult
$Res call({
 List<ChatRoomSummary> chatroomList
});




}
/// @nodoc
class __$ChatRoomListDataCopyWithImpl<$Res>
    implements _$ChatRoomListDataCopyWith<$Res> {
  __$ChatRoomListDataCopyWithImpl(this._self, this._then);

  final _ChatRoomListData _self;
  final $Res Function(_ChatRoomListData) _then;

/// Create a copy of ChatRoomListData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatroomList = null,}) {
  return _then(_ChatRoomListData(
chatroomList: null == chatroomList ? _self._chatroomList : chatroomList // ignore: cast_nullable_to_non_nullable
as List<ChatRoomSummary>,
  ));
}


}


/// @nodoc
mixin _$ChatRoomSummary {

 int get chatId; String get roomName; String? get lastMessage; DateTime? get lastMessageTime; int get unreadCount; List<String> get profileImage; int get participantCount;
/// Create a copy of ChatRoomSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomSummaryCopyWith<ChatRoomSummary> get copyWith => _$ChatRoomSummaryCopyWithImpl<ChatRoomSummary>(this as ChatRoomSummary, _$identity);

  /// Serializes this ChatRoomSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRoomSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomSummary&&(identical(other.chatId, _this.chatId) || other.chatId == _this.chatId)&&(identical(other.roomName, _this.roomName) || other.roomName == _this.roomName)&&(identical(other.lastMessage, _this.lastMessage) || other.lastMessage == _this.lastMessage)&&(identical(other.lastMessageTime, _this.lastMessageTime) || other.lastMessageTime == _this.lastMessageTime)&&(identical(other.unreadCount, _this.unreadCount) || other.unreadCount == _this.unreadCount)&&const DeepCollectionEquality().equals(other.profileImage, _this.profileImage)&&(identical(other.participantCount, _this.participantCount) || other.participantCount == _this.participantCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRoomSummary;
  return Object.hash(runtimeType,_this.chatId,_this.roomName,_this.lastMessage,_this.lastMessageTime,_this.unreadCount,const DeepCollectionEquality().hash(_this.profileImage),_this.participantCount);
}

@override
String toString() {
  final _this = this as ChatRoomSummary;
  return 'ChatRoomSummary(chatId: ${_this.chatId}, roomName: ${_this.roomName}, lastMessage: ${_this.lastMessage}, lastMessageTime: ${_this.lastMessageTime}, unreadCount: ${_this.unreadCount}, profileImage: ${_this.profileImage}, participantCount: ${_this.participantCount})';
}


}

/// @nodoc
abstract mixin class $ChatRoomSummaryCopyWith<$Res>  {
  factory $ChatRoomSummaryCopyWith(ChatRoomSummary value, $Res Function(ChatRoomSummary) _then) = _$ChatRoomSummaryCopyWithImpl;
@useResult
$Res call({
 int chatId, String roomName, String? lastMessage, DateTime? lastMessageTime, int unreadCount, List<String> profileImage, int participantCount
});




}
/// @nodoc
class _$ChatRoomSummaryCopyWithImpl<$Res>
    implements $ChatRoomSummaryCopyWith<$Res> {
  _$ChatRoomSummaryCopyWithImpl(this._self, this._then);

  final ChatRoomSummary _self;
  final $Res Function(ChatRoomSummary) _then;

/// Create a copy of ChatRoomSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatId = null,Object? roomName = null,Object? lastMessage = freezed,Object? lastMessageTime = freezed,Object? unreadCount = null,Object? profileImage = null,Object? participantCount = null,}) {
  return _then(ChatRoomSummary(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageTime: freezed == lastMessageTime ? _self.lastMessageTime : lastMessageTime // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,profileImage: null == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as List<String>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatRoomSummary].
extension ChatRoomSummaryPatterns on ChatRoomSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRoomSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRoomSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRoomSummary value)  $default,){
final _that = this;
switch (_that) {
case _ChatRoomSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRoomSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRoomSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chatId,  String roomName,  String? lastMessage,  DateTime? lastMessageTime,  int unreadCount,  List<String> profileImage,  int participantCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRoomSummary() when $default != null:
return $default(_that.chatId,_that.roomName,_that.lastMessage,_that.lastMessageTime,_that.unreadCount,_that.profileImage,_that.participantCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chatId,  String roomName,  String? lastMessage,  DateTime? lastMessageTime,  int unreadCount,  List<String> profileImage,  int participantCount)  $default,) {final _that = this;
switch (_that) {
case _ChatRoomSummary():
return $default(_that.chatId,_that.roomName,_that.lastMessage,_that.lastMessageTime,_that.unreadCount,_that.profileImage,_that.participantCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chatId,  String roomName,  String? lastMessage,  DateTime? lastMessageTime,  int unreadCount,  List<String> profileImage,  int participantCount)?  $default,) {final _that = this;
switch (_that) {
case _ChatRoomSummary() when $default != null:
return $default(_that.chatId,_that.roomName,_that.lastMessage,_that.lastMessageTime,_that.unreadCount,_that.profileImage,_that.participantCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRoomSummary implements ChatRoomSummary {
  const _ChatRoomSummary({required this.chatId, required this.roomName, this.lastMessage, this.lastMessageTime, this.unreadCount = 0,  List<String> profileImage = const <String>[], required this.participantCount}): _profileImage = profileImage;
  factory _ChatRoomSummary.fromJson(Map<String, dynamic> json) => _$ChatRoomSummaryFromJson(json);

@override final  int chatId;
@override final  String roomName;
@override final  String? lastMessage;
@override final  DateTime? lastMessageTime;
@override@JsonKey() final  int unreadCount;
 final  List<String> _profileImage;
@override@JsonKey() List<String> get profileImage {
  if (_profileImage is EqualUnmodifiableListView) return _profileImage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profileImage);
}

@override final  int participantCount;

/// Create a copy of ChatRoomSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomSummaryCopyWith<_ChatRoomSummary> get copyWith => __$ChatRoomSummaryCopyWithImpl<_ChatRoomSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomSummary&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastMessageTime, lastMessageTime) || other.lastMessageTime == lastMessageTime)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&const DeepCollectionEquality().equals(other.profileImage, _profileImage)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,chatId,roomName,lastMessage,lastMessageTime,unreadCount,const DeepCollectionEquality().hash(_profileImage),participantCount);
}

@override
String toString() {
    return 'ChatRoomSummary(chatId: $chatId, roomName: $roomName, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime, unreadCount: $unreadCount, profileImage: $profileImage, participantCount: $participantCount)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomSummaryCopyWith<$Res> implements $ChatRoomSummaryCopyWith<$Res> {
  factory _$ChatRoomSummaryCopyWith(_ChatRoomSummary value, $Res Function(_ChatRoomSummary) _then) = __$ChatRoomSummaryCopyWithImpl;
@override @useResult
$Res call({
 int chatId, String roomName, String? lastMessage, DateTime? lastMessageTime, int unreadCount, List<String> profileImage, int participantCount
});




}
/// @nodoc
class __$ChatRoomSummaryCopyWithImpl<$Res>
    implements _$ChatRoomSummaryCopyWith<$Res> {
  __$ChatRoomSummaryCopyWithImpl(this._self, this._then);

  final _ChatRoomSummary _self;
  final $Res Function(_ChatRoomSummary) _then;

/// Create a copy of ChatRoomSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,Object? roomName = null,Object? lastMessage = freezed,Object? lastMessageTime = freezed,Object? unreadCount = null,Object? profileImage = null,Object? participantCount = null,}) {
  return _then(_ChatRoomSummary(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageTime: freezed == lastMessageTime ? _self.lastMessageTime : lastMessageTime // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,profileImage: null == profileImage ? _self._profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as List<String>,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChatRoomCreateRequest {

 String get roomName; List<int> get participantIds; String get firstMessageContent;
/// Create a copy of ChatRoomCreateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomCreateRequestCopyWith<ChatRoomCreateRequest> get copyWith => _$ChatRoomCreateRequestCopyWithImpl<ChatRoomCreateRequest>(this as ChatRoomCreateRequest, _$identity);

  /// Serializes this ChatRoomCreateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRoomCreateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomCreateRequest&&(identical(other.roomName, _this.roomName) || other.roomName == _this.roomName)&&const DeepCollectionEquality().equals(other.participantIds, _this.participantIds)&&(identical(other.firstMessageContent, _this.firstMessageContent) || other.firstMessageContent == _this.firstMessageContent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRoomCreateRequest;
  return Object.hash(runtimeType,_this.roomName,const DeepCollectionEquality().hash(_this.participantIds),_this.firstMessageContent);
}

@override
String toString() {
  final _this = this as ChatRoomCreateRequest;
  return 'ChatRoomCreateRequest(roomName: ${_this.roomName}, participantIds: ${_this.participantIds}, firstMessageContent: ${_this.firstMessageContent})';
}


}

/// @nodoc
abstract mixin class $ChatRoomCreateRequestCopyWith<$Res>  {
  factory $ChatRoomCreateRequestCopyWith(ChatRoomCreateRequest value, $Res Function(ChatRoomCreateRequest) _then) = _$ChatRoomCreateRequestCopyWithImpl;
@useResult
$Res call({
 String roomName, List<int> participantIds, String firstMessageContent
});




}
/// @nodoc
class _$ChatRoomCreateRequestCopyWithImpl<$Res>
    implements $ChatRoomCreateRequestCopyWith<$Res> {
  _$ChatRoomCreateRequestCopyWithImpl(this._self, this._then);

  final ChatRoomCreateRequest _self;
  final $Res Function(ChatRoomCreateRequest) _then;

/// Create a copy of ChatRoomCreateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomName = null,Object? participantIds = null,Object? firstMessageContent = null,}) {
  return _then(ChatRoomCreateRequest(
roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<int>,firstMessageContent: null == firstMessageContent ? _self.firstMessageContent : firstMessageContent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatRoomCreateRequest].
extension ChatRoomCreateRequestPatterns on ChatRoomCreateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRoomCreateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRoomCreateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRoomCreateRequest value)  $default,){
final _that = this;
switch (_that) {
case _ChatRoomCreateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRoomCreateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRoomCreateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String roomName,  List<int> participantIds,  String firstMessageContent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRoomCreateRequest() when $default != null:
return $default(_that.roomName,_that.participantIds,_that.firstMessageContent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String roomName,  List<int> participantIds,  String firstMessageContent)  $default,) {final _that = this;
switch (_that) {
case _ChatRoomCreateRequest():
return $default(_that.roomName,_that.participantIds,_that.firstMessageContent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String roomName,  List<int> participantIds,  String firstMessageContent)?  $default,) {final _that = this;
switch (_that) {
case _ChatRoomCreateRequest() when $default != null:
return $default(_that.roomName,_that.participantIds,_that.firstMessageContent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRoomCreateRequest implements ChatRoomCreateRequest {
  const _ChatRoomCreateRequest({required this.roomName, required  List<int> participantIds, required this.firstMessageContent}): _participantIds = participantIds;
  factory _ChatRoomCreateRequest.fromJson(Map<String, dynamic> json) => _$ChatRoomCreateRequestFromJson(json);

@override final  String roomName;
 final  List<int> _participantIds;
@override List<int> get participantIds {
  if (_participantIds is EqualUnmodifiableListView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantIds);
}

@override final  String firstMessageContent;

/// Create a copy of ChatRoomCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomCreateRequestCopyWith<_ChatRoomCreateRequest> get copyWith => __$ChatRoomCreateRequestCopyWithImpl<_ChatRoomCreateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomCreateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomCreateRequest&&(identical(other.roomName, roomName) || other.roomName == roomName)&&const DeepCollectionEquality().equals(other.participantIds, _participantIds)&&(identical(other.firstMessageContent, firstMessageContent) || other.firstMessageContent == firstMessageContent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,roomName,const DeepCollectionEquality().hash(_participantIds),firstMessageContent);
}

@override
String toString() {
    return 'ChatRoomCreateRequest(roomName: $roomName, participantIds: $participantIds, firstMessageContent: $firstMessageContent)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomCreateRequestCopyWith<$Res> implements $ChatRoomCreateRequestCopyWith<$Res> {
  factory _$ChatRoomCreateRequestCopyWith(_ChatRoomCreateRequest value, $Res Function(_ChatRoomCreateRequest) _then) = __$ChatRoomCreateRequestCopyWithImpl;
@override @useResult
$Res call({
 String roomName, List<int> participantIds, String firstMessageContent
});




}
/// @nodoc
class __$ChatRoomCreateRequestCopyWithImpl<$Res>
    implements _$ChatRoomCreateRequestCopyWith<$Res> {
  __$ChatRoomCreateRequestCopyWithImpl(this._self, this._then);

  final _ChatRoomCreateRequest _self;
  final $Res Function(_ChatRoomCreateRequest) _then;

/// Create a copy of ChatRoomCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomName = null,Object? participantIds = null,Object? firstMessageContent = null,}) {
  return _then(_ChatRoomCreateRequest(
roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<int>,firstMessageContent: null == firstMessageContent ? _self.firstMessageContent : firstMessageContent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ChatRoomCreateResponse {

 bool get success; int get status; String? get message; ChatRoomCreateData get data;
/// Create a copy of ChatRoomCreateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomCreateResponseCopyWith<ChatRoomCreateResponse> get copyWith => _$ChatRoomCreateResponseCopyWithImpl<ChatRoomCreateResponse>(this as ChatRoomCreateResponse, _$identity);

  /// Serializes this ChatRoomCreateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRoomCreateResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomCreateResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRoomCreateResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as ChatRoomCreateResponse;
  return 'ChatRoomCreateResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $ChatRoomCreateResponseCopyWith<$Res>  {
  factory $ChatRoomCreateResponseCopyWith(ChatRoomCreateResponse value, $Res Function(ChatRoomCreateResponse) _then) = _$ChatRoomCreateResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String? message, ChatRoomCreateData data
});


$ChatRoomCreateDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ChatRoomCreateResponseCopyWithImpl<$Res>
    implements $ChatRoomCreateResponseCopyWith<$Res> {
  _$ChatRoomCreateResponseCopyWithImpl(this._self, this._then);

  final ChatRoomCreateResponse _self;
  final $Res Function(ChatRoomCreateResponse) _then;

/// Create a copy of ChatRoomCreateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(ChatRoomCreateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChatRoomCreateData,
  ));
}
/// Create a copy of ChatRoomCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatRoomCreateDataCopyWith<$Res> get data {
  
  return $ChatRoomCreateDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatRoomCreateResponse].
extension ChatRoomCreateResponsePatterns on ChatRoomCreateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRoomCreateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRoomCreateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRoomCreateResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatRoomCreateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRoomCreateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRoomCreateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  ChatRoomCreateData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRoomCreateResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  ChatRoomCreateData data)  $default,) {final _that = this;
switch (_that) {
case _ChatRoomCreateResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String? message,  ChatRoomCreateData data)?  $default,) {final _that = this;
switch (_that) {
case _ChatRoomCreateResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRoomCreateResponse implements ChatRoomCreateResponse {
  const _ChatRoomCreateResponse({required this.success, required this.status, this.message, required this.data});
  factory _ChatRoomCreateResponse.fromJson(Map<String, dynamic> json) => _$ChatRoomCreateResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String? message;
@override final  ChatRoomCreateData data;

/// Create a copy of ChatRoomCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomCreateResponseCopyWith<_ChatRoomCreateResponse> get copyWith => __$ChatRoomCreateResponseCopyWithImpl<_ChatRoomCreateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomCreateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomCreateResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'ChatRoomCreateResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomCreateResponseCopyWith<$Res> implements $ChatRoomCreateResponseCopyWith<$Res> {
  factory _$ChatRoomCreateResponseCopyWith(_ChatRoomCreateResponse value, $Res Function(_ChatRoomCreateResponse) _then) = __$ChatRoomCreateResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String? message, ChatRoomCreateData data
});


@override $ChatRoomCreateDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ChatRoomCreateResponseCopyWithImpl<$Res>
    implements _$ChatRoomCreateResponseCopyWith<$Res> {
  __$ChatRoomCreateResponseCopyWithImpl(this._self, this._then);

  final _ChatRoomCreateResponse _self;
  final $Res Function(_ChatRoomCreateResponse) _then;

/// Create a copy of ChatRoomCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(_ChatRoomCreateResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChatRoomCreateData,
  ));
}

/// Create a copy of ChatRoomCreateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatRoomCreateDataCopyWith<$Res> get data {
  
  return $ChatRoomCreateDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ChatRoomCreateData {

 int get chatId; String get roomName; DateTime get createdAt;
/// Create a copy of ChatRoomCreateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomCreateDataCopyWith<ChatRoomCreateData> get copyWith => _$ChatRoomCreateDataCopyWithImpl<ChatRoomCreateData>(this as ChatRoomCreateData, _$identity);

  /// Serializes this ChatRoomCreateData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRoomCreateData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomCreateData&&(identical(other.chatId, _this.chatId) || other.chatId == _this.chatId)&&(identical(other.roomName, _this.roomName) || other.roomName == _this.roomName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRoomCreateData;
  return Object.hash(runtimeType,_this.chatId,_this.roomName,_this.createdAt);
}

@override
String toString() {
  final _this = this as ChatRoomCreateData;
  return 'ChatRoomCreateData(chatId: ${_this.chatId}, roomName: ${_this.roomName}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ChatRoomCreateDataCopyWith<$Res>  {
  factory $ChatRoomCreateDataCopyWith(ChatRoomCreateData value, $Res Function(ChatRoomCreateData) _then) = _$ChatRoomCreateDataCopyWithImpl;
@useResult
$Res call({
 int chatId, String roomName, DateTime createdAt
});




}
/// @nodoc
class _$ChatRoomCreateDataCopyWithImpl<$Res>
    implements $ChatRoomCreateDataCopyWith<$Res> {
  _$ChatRoomCreateDataCopyWithImpl(this._self, this._then);

  final ChatRoomCreateData _self;
  final $Res Function(ChatRoomCreateData) _then;

/// Create a copy of ChatRoomCreateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatId = null,Object? roomName = null,Object? createdAt = null,}) {
  return _then(ChatRoomCreateData(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatRoomCreateData].
extension ChatRoomCreateDataPatterns on ChatRoomCreateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRoomCreateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRoomCreateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRoomCreateData value)  $default,){
final _that = this;
switch (_that) {
case _ChatRoomCreateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRoomCreateData value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRoomCreateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chatId,  String roomName,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRoomCreateData() when $default != null:
return $default(_that.chatId,_that.roomName,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chatId,  String roomName,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ChatRoomCreateData():
return $default(_that.chatId,_that.roomName,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chatId,  String roomName,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatRoomCreateData() when $default != null:
return $default(_that.chatId,_that.roomName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRoomCreateData implements ChatRoomCreateData {
  const _ChatRoomCreateData({required this.chatId, required this.roomName, required this.createdAt});
  factory _ChatRoomCreateData.fromJson(Map<String, dynamic> json) => _$ChatRoomCreateDataFromJson(json);

@override final  int chatId;
@override final  String roomName;
@override final  DateTime createdAt;

/// Create a copy of ChatRoomCreateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomCreateDataCopyWith<_ChatRoomCreateData> get copyWith => __$ChatRoomCreateDataCopyWithImpl<_ChatRoomCreateData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomCreateDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomCreateData&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,chatId,roomName,createdAt);
}

@override
String toString() {
    return 'ChatRoomCreateData(chatId: $chatId, roomName: $roomName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomCreateDataCopyWith<$Res> implements $ChatRoomCreateDataCopyWith<$Res> {
  factory _$ChatRoomCreateDataCopyWith(_ChatRoomCreateData value, $Res Function(_ChatRoomCreateData) _then) = __$ChatRoomCreateDataCopyWithImpl;
@override @useResult
$Res call({
 int chatId, String roomName, DateTime createdAt
});




}
/// @nodoc
class __$ChatRoomCreateDataCopyWithImpl<$Res>
    implements _$ChatRoomCreateDataCopyWith<$Res> {
  __$ChatRoomCreateDataCopyWithImpl(this._self, this._then);

  final _ChatRoomCreateData _self;
  final $Res Function(_ChatRoomCreateData) _then;

/// Create a copy of ChatRoomCreateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,Object? roomName = null,Object? createdAt = null,}) {
  return _then(_ChatRoomCreateData(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChatRoomUpdateRequest {

 String get roomName;
/// Create a copy of ChatRoomUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomUpdateRequestCopyWith<ChatRoomUpdateRequest> get copyWith => _$ChatRoomUpdateRequestCopyWithImpl<ChatRoomUpdateRequest>(this as ChatRoomUpdateRequest, _$identity);

  /// Serializes this ChatRoomUpdateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRoomUpdateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomUpdateRequest&&(identical(other.roomName, _this.roomName) || other.roomName == _this.roomName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRoomUpdateRequest;
  return Object.hash(runtimeType,_this.roomName);
}

@override
String toString() {
  final _this = this as ChatRoomUpdateRequest;
  return 'ChatRoomUpdateRequest(roomName: ${_this.roomName})';
}


}

/// @nodoc
abstract mixin class $ChatRoomUpdateRequestCopyWith<$Res>  {
  factory $ChatRoomUpdateRequestCopyWith(ChatRoomUpdateRequest value, $Res Function(ChatRoomUpdateRequest) _then) = _$ChatRoomUpdateRequestCopyWithImpl;
@useResult
$Res call({
 String roomName
});




}
/// @nodoc
class _$ChatRoomUpdateRequestCopyWithImpl<$Res>
    implements $ChatRoomUpdateRequestCopyWith<$Res> {
  _$ChatRoomUpdateRequestCopyWithImpl(this._self, this._then);

  final ChatRoomUpdateRequest _self;
  final $Res Function(ChatRoomUpdateRequest) _then;

/// Create a copy of ChatRoomUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomName = null,}) {
  return _then(ChatRoomUpdateRequest(
roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatRoomUpdateRequest].
extension ChatRoomUpdateRequestPatterns on ChatRoomUpdateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRoomUpdateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRoomUpdateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRoomUpdateRequest value)  $default,){
final _that = this;
switch (_that) {
case _ChatRoomUpdateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRoomUpdateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRoomUpdateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String roomName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRoomUpdateRequest() when $default != null:
return $default(_that.roomName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String roomName)  $default,) {final _that = this;
switch (_that) {
case _ChatRoomUpdateRequest():
return $default(_that.roomName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String roomName)?  $default,) {final _that = this;
switch (_that) {
case _ChatRoomUpdateRequest() when $default != null:
return $default(_that.roomName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRoomUpdateRequest implements ChatRoomUpdateRequest {
  const _ChatRoomUpdateRequest({required this.roomName});
  factory _ChatRoomUpdateRequest.fromJson(Map<String, dynamic> json) => _$ChatRoomUpdateRequestFromJson(json);

@override final  String roomName;

/// Create a copy of ChatRoomUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomUpdateRequestCopyWith<_ChatRoomUpdateRequest> get copyWith => __$ChatRoomUpdateRequestCopyWithImpl<_ChatRoomUpdateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomUpdateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomUpdateRequest&&(identical(other.roomName, roomName) || other.roomName == roomName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,roomName);
}

@override
String toString() {
    return 'ChatRoomUpdateRequest(roomName: $roomName)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomUpdateRequestCopyWith<$Res> implements $ChatRoomUpdateRequestCopyWith<$Res> {
  factory _$ChatRoomUpdateRequestCopyWith(_ChatRoomUpdateRequest value, $Res Function(_ChatRoomUpdateRequest) _then) = __$ChatRoomUpdateRequestCopyWithImpl;
@override @useResult
$Res call({
 String roomName
});




}
/// @nodoc
class __$ChatRoomUpdateRequestCopyWithImpl<$Res>
    implements _$ChatRoomUpdateRequestCopyWith<$Res> {
  __$ChatRoomUpdateRequestCopyWithImpl(this._self, this._then);

  final _ChatRoomUpdateRequest _self;
  final $Res Function(_ChatRoomUpdateRequest) _then;

/// Create a copy of ChatRoomUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomName = null,}) {
  return _then(_ChatRoomUpdateRequest(
roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ChatRoomUpdateData {

 int get chatId; String get roomName; DateTime get updatedAt;
/// Create a copy of ChatRoomUpdateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomUpdateDataCopyWith<ChatRoomUpdateData> get copyWith => _$ChatRoomUpdateDataCopyWithImpl<ChatRoomUpdateData>(this as ChatRoomUpdateData, _$identity);

  /// Serializes this ChatRoomUpdateData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRoomUpdateData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomUpdateData&&(identical(other.chatId, _this.chatId) || other.chatId == _this.chatId)&&(identical(other.roomName, _this.roomName) || other.roomName == _this.roomName)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRoomUpdateData;
  return Object.hash(runtimeType,_this.chatId,_this.roomName,_this.updatedAt);
}

@override
String toString() {
  final _this = this as ChatRoomUpdateData;
  return 'ChatRoomUpdateData(chatId: ${_this.chatId}, roomName: ${_this.roomName}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $ChatRoomUpdateDataCopyWith<$Res>  {
  factory $ChatRoomUpdateDataCopyWith(ChatRoomUpdateData value, $Res Function(ChatRoomUpdateData) _then) = _$ChatRoomUpdateDataCopyWithImpl;
@useResult
$Res call({
 int chatId, String roomName, DateTime updatedAt
});




}
/// @nodoc
class _$ChatRoomUpdateDataCopyWithImpl<$Res>
    implements $ChatRoomUpdateDataCopyWith<$Res> {
  _$ChatRoomUpdateDataCopyWithImpl(this._self, this._then);

  final ChatRoomUpdateData _self;
  final $Res Function(ChatRoomUpdateData) _then;

/// Create a copy of ChatRoomUpdateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatId = null,Object? roomName = null,Object? updatedAt = null,}) {
  return _then(ChatRoomUpdateData(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatRoomUpdateData].
extension ChatRoomUpdateDataPatterns on ChatRoomUpdateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRoomUpdateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRoomUpdateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRoomUpdateData value)  $default,){
final _that = this;
switch (_that) {
case _ChatRoomUpdateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRoomUpdateData value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRoomUpdateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chatId,  String roomName,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRoomUpdateData() when $default != null:
return $default(_that.chatId,_that.roomName,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chatId,  String roomName,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ChatRoomUpdateData():
return $default(_that.chatId,_that.roomName,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chatId,  String roomName,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatRoomUpdateData() when $default != null:
return $default(_that.chatId,_that.roomName,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRoomUpdateData implements ChatRoomUpdateData {
  const _ChatRoomUpdateData({required this.chatId, required this.roomName, required this.updatedAt});
  factory _ChatRoomUpdateData.fromJson(Map<String, dynamic> json) => _$ChatRoomUpdateDataFromJson(json);

@override final  int chatId;
@override final  String roomName;
@override final  DateTime updatedAt;

/// Create a copy of ChatRoomUpdateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomUpdateDataCopyWith<_ChatRoomUpdateData> get copyWith => __$ChatRoomUpdateDataCopyWithImpl<_ChatRoomUpdateData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomUpdateDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomUpdateData&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,chatId,roomName,updatedAt);
}

@override
String toString() {
    return 'ChatRoomUpdateData(chatId: $chatId, roomName: $roomName, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomUpdateDataCopyWith<$Res> implements $ChatRoomUpdateDataCopyWith<$Res> {
  factory _$ChatRoomUpdateDataCopyWith(_ChatRoomUpdateData value, $Res Function(_ChatRoomUpdateData) _then) = __$ChatRoomUpdateDataCopyWithImpl;
@override @useResult
$Res call({
 int chatId, String roomName, DateTime updatedAt
});




}
/// @nodoc
class __$ChatRoomUpdateDataCopyWithImpl<$Res>
    implements _$ChatRoomUpdateDataCopyWith<$Res> {
  __$ChatRoomUpdateDataCopyWithImpl(this._self, this._then);

  final _ChatRoomUpdateData _self;
  final $Res Function(_ChatRoomUpdateData) _then;

/// Create a copy of ChatRoomUpdateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,Object? roomName = null,Object? updatedAt = null,}) {
  return _then(_ChatRoomUpdateData(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,roomName: null == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
