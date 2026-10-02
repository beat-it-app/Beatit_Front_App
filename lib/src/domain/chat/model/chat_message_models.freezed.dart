// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRoomDetailResponse {

 bool get success; int get status; String? get message; ChatRoomDetailData get data;
/// Create a copy of ChatRoomDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomDetailResponseCopyWith<ChatRoomDetailResponse> get copyWith => _$ChatRoomDetailResponseCopyWithImpl<ChatRoomDetailResponse>(this as ChatRoomDetailResponse, _$identity);

  /// Serializes this ChatRoomDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRoomDetailResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomDetailResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRoomDetailResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as ChatRoomDetailResponse;
  return 'ChatRoomDetailResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $ChatRoomDetailResponseCopyWith<$Res>  {
  factory $ChatRoomDetailResponseCopyWith(ChatRoomDetailResponse value, $Res Function(ChatRoomDetailResponse) _then) = _$ChatRoomDetailResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String? message, ChatRoomDetailData data
});


$ChatRoomDetailDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ChatRoomDetailResponseCopyWithImpl<$Res>
    implements $ChatRoomDetailResponseCopyWith<$Res> {
  _$ChatRoomDetailResponseCopyWithImpl(this._self, this._then);

  final ChatRoomDetailResponse _self;
  final $Res Function(ChatRoomDetailResponse) _then;

/// Create a copy of ChatRoomDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(ChatRoomDetailResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChatRoomDetailData,
  ));
}
/// Create a copy of ChatRoomDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatRoomDetailDataCopyWith<$Res> get data {
  
  return $ChatRoomDetailDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatRoomDetailResponse].
extension ChatRoomDetailResponsePatterns on ChatRoomDetailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRoomDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRoomDetailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRoomDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatRoomDetailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRoomDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRoomDetailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  ChatRoomDetailData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRoomDetailResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  ChatRoomDetailData data)  $default,) {final _that = this;
switch (_that) {
case _ChatRoomDetailResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String? message,  ChatRoomDetailData data)?  $default,) {final _that = this;
switch (_that) {
case _ChatRoomDetailResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRoomDetailResponse implements ChatRoomDetailResponse {
  const _ChatRoomDetailResponse({required this.success, required this.status, this.message, required this.data});
  factory _ChatRoomDetailResponse.fromJson(Map<String, dynamic> json) => _$ChatRoomDetailResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String? message;
@override final  ChatRoomDetailData data;

/// Create a copy of ChatRoomDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomDetailResponseCopyWith<_ChatRoomDetailResponse> get copyWith => __$ChatRoomDetailResponseCopyWithImpl<_ChatRoomDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomDetailResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'ChatRoomDetailResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomDetailResponseCopyWith<$Res> implements $ChatRoomDetailResponseCopyWith<$Res> {
  factory _$ChatRoomDetailResponseCopyWith(_ChatRoomDetailResponse value, $Res Function(_ChatRoomDetailResponse) _then) = __$ChatRoomDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String? message, ChatRoomDetailData data
});


@override $ChatRoomDetailDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ChatRoomDetailResponseCopyWithImpl<$Res>
    implements _$ChatRoomDetailResponseCopyWith<$Res> {
  __$ChatRoomDetailResponseCopyWithImpl(this._self, this._then);

  final _ChatRoomDetailResponse _self;
  final $Res Function(_ChatRoomDetailResponse) _then;

/// Create a copy of ChatRoomDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(_ChatRoomDetailResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChatRoomDetailData,
  ));
}

/// Create a copy of ChatRoomDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatRoomDetailDataCopyWith<$Res> get data {
  
  return $ChatRoomDetailDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ChatRoomDetailData {

 String get chatroomName; int get participantCount; List<ChatMessage> get messages; bool get hasNext;
/// Create a copy of ChatRoomDetailData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatRoomDetailDataCopyWith<ChatRoomDetailData> get copyWith => _$ChatRoomDetailDataCopyWithImpl<ChatRoomDetailData>(this as ChatRoomDetailData, _$identity);

  /// Serializes this ChatRoomDetailData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatRoomDetailData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRoomDetailData&&(identical(other.chatroomName, _this.chatroomName) || other.chatroomName == _this.chatroomName)&&(identical(other.participantCount, _this.participantCount) || other.participantCount == _this.participantCount)&&const DeepCollectionEquality().equals(other.messages, _this.messages)&&(identical(other.hasNext, _this.hasNext) || other.hasNext == _this.hasNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatRoomDetailData;
  return Object.hash(runtimeType,_this.chatroomName,_this.participantCount,const DeepCollectionEquality().hash(_this.messages),_this.hasNext);
}

@override
String toString() {
  final _this = this as ChatRoomDetailData;
  return 'ChatRoomDetailData(chatroomName: ${_this.chatroomName}, participantCount: ${_this.participantCount}, messages: ${_this.messages}, hasNext: ${_this.hasNext})';
}


}

/// @nodoc
abstract mixin class $ChatRoomDetailDataCopyWith<$Res>  {
  factory $ChatRoomDetailDataCopyWith(ChatRoomDetailData value, $Res Function(ChatRoomDetailData) _then) = _$ChatRoomDetailDataCopyWithImpl;
@useResult
$Res call({
 String chatroomName, int participantCount, List<ChatMessage> messages, bool hasNext
});




}
/// @nodoc
class _$ChatRoomDetailDataCopyWithImpl<$Res>
    implements $ChatRoomDetailDataCopyWith<$Res> {
  _$ChatRoomDetailDataCopyWithImpl(this._self, this._then);

  final ChatRoomDetailData _self;
  final $Res Function(ChatRoomDetailData) _then;

/// Create a copy of ChatRoomDetailData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatroomName = null,Object? participantCount = null,Object? messages = null,Object? hasNext = null,}) {
  return _then(ChatRoomDetailData(
chatroomName: null == chatroomName ? _self.chatroomName : chatroomName // ignore: cast_nullable_to_non_nullable
as String,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatRoomDetailData].
extension ChatRoomDetailDataPatterns on ChatRoomDetailData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatRoomDetailData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatRoomDetailData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatRoomDetailData value)  $default,){
final _that = this;
switch (_that) {
case _ChatRoomDetailData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatRoomDetailData value)?  $default,){
final _that = this;
switch (_that) {
case _ChatRoomDetailData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String chatroomName,  int participantCount,  List<ChatMessage> messages,  bool hasNext)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatRoomDetailData() when $default != null:
return $default(_that.chatroomName,_that.participantCount,_that.messages,_that.hasNext);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String chatroomName,  int participantCount,  List<ChatMessage> messages,  bool hasNext)  $default,) {final _that = this;
switch (_that) {
case _ChatRoomDetailData():
return $default(_that.chatroomName,_that.participantCount,_that.messages,_that.hasNext);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String chatroomName,  int participantCount,  List<ChatMessage> messages,  bool hasNext)?  $default,) {final _that = this;
switch (_that) {
case _ChatRoomDetailData() when $default != null:
return $default(_that.chatroomName,_that.participantCount,_that.messages,_that.hasNext);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatRoomDetailData implements ChatRoomDetailData {
  const _ChatRoomDetailData({required this.chatroomName, required this.participantCount,  List<ChatMessage> messages = const <ChatMessage>[], required this.hasNext}): _messages = messages;
  factory _ChatRoomDetailData.fromJson(Map<String, dynamic> json) => _$ChatRoomDetailDataFromJson(json);

@override final  String chatroomName;
@override final  int participantCount;
 final  List<ChatMessage> _messages;
@override@JsonKey() List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override final  bool hasNext;

/// Create a copy of ChatRoomDetailData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatRoomDetailDataCopyWith<_ChatRoomDetailData> get copyWith => __$ChatRoomDetailDataCopyWithImpl<_ChatRoomDetailData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatRoomDetailDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatRoomDetailData&&(identical(other.chatroomName, chatroomName) || other.chatroomName == chatroomName)&&(identical(other.participantCount, participantCount) || other.participantCount == participantCount)&&const DeepCollectionEquality().equals(other.messages, _messages)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,chatroomName,participantCount,const DeepCollectionEquality().hash(_messages),hasNext);
}

@override
String toString() {
    return 'ChatRoomDetailData(chatroomName: $chatroomName, participantCount: $participantCount, messages: $messages, hasNext: $hasNext)';
}


}

/// @nodoc
abstract mixin class _$ChatRoomDetailDataCopyWith<$Res> implements $ChatRoomDetailDataCopyWith<$Res> {
  factory _$ChatRoomDetailDataCopyWith(_ChatRoomDetailData value, $Res Function(_ChatRoomDetailData) _then) = __$ChatRoomDetailDataCopyWithImpl;
@override @useResult
$Res call({
 String chatroomName, int participantCount, List<ChatMessage> messages, bool hasNext
});




}
/// @nodoc
class __$ChatRoomDetailDataCopyWithImpl<$Res>
    implements _$ChatRoomDetailDataCopyWith<$Res> {
  __$ChatRoomDetailDataCopyWithImpl(this._self, this._then);

  final _ChatRoomDetailData _self;
  final $Res Function(_ChatRoomDetailData) _then;

/// Create a copy of ChatRoomDetailData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatroomName = null,Object? participantCount = null,Object? messages = null,Object? hasNext = null,}) {
  return _then(_ChatRoomDetailData(
chatroomName: null == chatroomName ? _self.chatroomName : chatroomName // ignore: cast_nullable_to_non_nullable
as String,participantCount: null == participantCount ? _self.participantCount : participantCount // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatMessage {

 int get messageId; int get senderId; String get senderName; String? get profileImageUrl; String get content;@JsonKey(unknownEnumValue: ChatMessageType.unknown) ChatMessageType get messageType; DateTime get createdAt;@JsonKey(name: 'mine') bool get isMine; String? get attachmentName; int? get attachmentSizeBytes; String? get attachmentMimeType;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.senderId, _this.senderId) || other.senderId == _this.senderId)&&(identical(other.senderName, _this.senderName) || other.senderName == _this.senderName)&&(identical(other.profileImageUrl, _this.profileImageUrl) || other.profileImageUrl == _this.profileImageUrl)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.messageType, _this.messageType) || other.messageType == _this.messageType)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.isMine, _this.isMine) || other.isMine == _this.isMine)&&(identical(other.attachmentName, _this.attachmentName) || other.attachmentName == _this.attachmentName)&&(identical(other.attachmentSizeBytes, _this.attachmentSizeBytes) || other.attachmentSizeBytes == _this.attachmentSizeBytes)&&(identical(other.attachmentMimeType, _this.attachmentMimeType) || other.attachmentMimeType == _this.attachmentMimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMessage;
  return Object.hash(runtimeType,_this.messageId,_this.senderId,_this.senderName,_this.profileImageUrl,_this.content,_this.messageType,_this.createdAt,_this.isMine,_this.attachmentName,_this.attachmentSizeBytes,_this.attachmentMimeType);
}

@override
String toString() {
  final _this = this as ChatMessage;
  return 'ChatMessage(messageId: ${_this.messageId}, senderId: ${_this.senderId}, senderName: ${_this.senderName}, profileImageUrl: ${_this.profileImageUrl}, content: ${_this.content}, messageType: ${_this.messageType}, createdAt: ${_this.createdAt}, isMine: ${_this.isMine}, attachmentName: ${_this.attachmentName}, attachmentSizeBytes: ${_this.attachmentSizeBytes}, attachmentMimeType: ${_this.attachmentMimeType})';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 int messageId, int senderId, String senderName, String? profileImageUrl, String content,@JsonKey(unknownEnumValue: ChatMessageType.unknown) ChatMessageType messageType, DateTime createdAt,@JsonKey(name: 'mine') bool isMine, String? attachmentName, int? attachmentSizeBytes, String? attachmentMimeType
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? senderId = null,Object? senderName = null,Object? profileImageUrl = freezed,Object? content = null,Object? messageType = null,Object? createdAt = null,Object? isMine = null,Object? attachmentName = freezed,Object? attachmentSizeBytes = freezed,Object? attachmentMimeType = freezed,}) {
  return _then(ChatMessage(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as ChatMessageType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,attachmentName: freezed == attachmentName ? _self.attachmentName : attachmentName // ignore: cast_nullable_to_non_nullable
as String?,attachmentSizeBytes: freezed == attachmentSizeBytes ? _self.attachmentSizeBytes : attachmentSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,attachmentMimeType: freezed == attachmentMimeType ? _self.attachmentMimeType : attachmentMimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int messageId,  int senderId,  String senderName,  String? profileImageUrl,  String content, @JsonKey(unknownEnumValue: ChatMessageType.unknown)  ChatMessageType messageType,  DateTime createdAt, @JsonKey(name: 'mine')  bool isMine,  String? attachmentName,  int? attachmentSizeBytes,  String? attachmentMimeType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.messageId,_that.senderId,_that.senderName,_that.profileImageUrl,_that.content,_that.messageType,_that.createdAt,_that.isMine,_that.attachmentName,_that.attachmentSizeBytes,_that.attachmentMimeType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int messageId,  int senderId,  String senderName,  String? profileImageUrl,  String content, @JsonKey(unknownEnumValue: ChatMessageType.unknown)  ChatMessageType messageType,  DateTime createdAt, @JsonKey(name: 'mine')  bool isMine,  String? attachmentName,  int? attachmentSizeBytes,  String? attachmentMimeType)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.messageId,_that.senderId,_that.senderName,_that.profileImageUrl,_that.content,_that.messageType,_that.createdAt,_that.isMine,_that.attachmentName,_that.attachmentSizeBytes,_that.attachmentMimeType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int messageId,  int senderId,  String senderName,  String? profileImageUrl,  String content, @JsonKey(unknownEnumValue: ChatMessageType.unknown)  ChatMessageType messageType,  DateTime createdAt, @JsonKey(name: 'mine')  bool isMine,  String? attachmentName,  int? attachmentSizeBytes,  String? attachmentMimeType)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.messageId,_that.senderId,_that.senderName,_that.profileImageUrl,_that.content,_that.messageType,_that.createdAt,_that.isMine,_that.attachmentName,_that.attachmentSizeBytes,_that.attachmentMimeType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({required this.messageId, required this.senderId, required this.senderName, this.profileImageUrl, required this.content, @JsonKey(unknownEnumValue: ChatMessageType.unknown) required this.messageType, required this.createdAt, @JsonKey(name: 'mine') required this.isMine, this.attachmentName, this.attachmentSizeBytes, this.attachmentMimeType});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override final  int messageId;
@override final  int senderId;
@override final  String senderName;
@override final  String? profileImageUrl;
@override final  String content;
@override@JsonKey(unknownEnumValue: ChatMessageType.unknown) final  ChatMessageType messageType;
@override final  DateTime createdAt;
@override@JsonKey(name: 'mine') final  bool isMine;
@override final  String? attachmentName;
@override final  int? attachmentSizeBytes;
@override final  String? attachmentMimeType;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.content, content) || other.content == content)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.attachmentName, attachmentName) || other.attachmentName == attachmentName)&&(identical(other.attachmentSizeBytes, attachmentSizeBytes) || other.attachmentSizeBytes == attachmentSizeBytes)&&(identical(other.attachmentMimeType, attachmentMimeType) || other.attachmentMimeType == attachmentMimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,messageId,senderId,senderName,profileImageUrl,content,messageType,createdAt,isMine,attachmentName,attachmentSizeBytes,attachmentMimeType);
}

@override
String toString() {
    return 'ChatMessage(messageId: $messageId, senderId: $senderId, senderName: $senderName, profileImageUrl: $profileImageUrl, content: $content, messageType: $messageType, createdAt: $createdAt, isMine: $isMine, attachmentName: $attachmentName, attachmentSizeBytes: $attachmentSizeBytes, attachmentMimeType: $attachmentMimeType)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 int messageId, int senderId, String senderName, String? profileImageUrl, String content,@JsonKey(unknownEnumValue: ChatMessageType.unknown) ChatMessageType messageType, DateTime createdAt,@JsonKey(name: 'mine') bool isMine, String? attachmentName, int? attachmentSizeBytes, String? attachmentMimeType
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? senderId = null,Object? senderName = null,Object? profileImageUrl = freezed,Object? content = null,Object? messageType = null,Object? createdAt = null,Object? isMine = null,Object? attachmentName = freezed,Object? attachmentSizeBytes = freezed,Object? attachmentMimeType = freezed,}) {
  return _then(_ChatMessage(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as ChatMessageType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,attachmentName: freezed == attachmentName ? _self.attachmentName : attachmentName // ignore: cast_nullable_to_non_nullable
as String?,attachmentSizeBytes: freezed == attachmentSizeBytes ? _self.attachmentSizeBytes : attachmentSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,attachmentMimeType: freezed == attachmentMimeType ? _self.attachmentMimeType : attachmentMimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChatMessageSendRequest {

 ChatMessageType get messageType; String? get content; String? get storageKey;
/// Create a copy of ChatMessageSendRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageSendRequestCopyWith<ChatMessageSendRequest> get copyWith => _$ChatMessageSendRequestCopyWithImpl<ChatMessageSendRequest>(this as ChatMessageSendRequest, _$identity);

  /// Serializes this ChatMessageSendRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMessageSendRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageSendRequest&&(identical(other.messageType, _this.messageType) || other.messageType == _this.messageType)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.storageKey, _this.storageKey) || other.storageKey == _this.storageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMessageSendRequest;
  return Object.hash(runtimeType,_this.messageType,_this.content,_this.storageKey);
}

@override
String toString() {
  final _this = this as ChatMessageSendRequest;
  return 'ChatMessageSendRequest(messageType: ${_this.messageType}, content: ${_this.content}, storageKey: ${_this.storageKey})';
}


}

/// @nodoc
abstract mixin class $ChatMessageSendRequestCopyWith<$Res>  {
  factory $ChatMessageSendRequestCopyWith(ChatMessageSendRequest value, $Res Function(ChatMessageSendRequest) _then) = _$ChatMessageSendRequestCopyWithImpl;
@useResult
$Res call({
 ChatMessageType messageType, String? content, String? storageKey
});




}
/// @nodoc
class _$ChatMessageSendRequestCopyWithImpl<$Res>
    implements $ChatMessageSendRequestCopyWith<$Res> {
  _$ChatMessageSendRequestCopyWithImpl(this._self, this._then);

  final ChatMessageSendRequest _self;
  final $Res Function(ChatMessageSendRequest) _then;

/// Create a copy of ChatMessageSendRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageType = null,Object? content = freezed,Object? storageKey = freezed,}) {
  return _then(ChatMessageSendRequest(
messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as ChatMessageType,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,storageKey: freezed == storageKey ? _self.storageKey : storageKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageSendRequest].
extension ChatMessageSendRequestPatterns on ChatMessageSendRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageSendRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageSendRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageSendRequest value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageSendRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageSendRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageSendRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatMessageType messageType,  String? content,  String? storageKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageSendRequest() when $default != null:
return $default(_that.messageType,_that.content,_that.storageKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatMessageType messageType,  String? content,  String? storageKey)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageSendRequest():
return $default(_that.messageType,_that.content,_that.storageKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatMessageType messageType,  String? content,  String? storageKey)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageSendRequest() when $default != null:
return $default(_that.messageType,_that.content,_that.storageKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageSendRequest implements ChatMessageSendRequest {
  const _ChatMessageSendRequest({required this.messageType, this.content, this.storageKey});
  factory _ChatMessageSendRequest.fromJson(Map<String, dynamic> json) => _$ChatMessageSendRequestFromJson(json);

@override final  ChatMessageType messageType;
@override final  String? content;
@override final  String? storageKey;

/// Create a copy of ChatMessageSendRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageSendRequestCopyWith<_ChatMessageSendRequest> get copyWith => __$ChatMessageSendRequestCopyWithImpl<_ChatMessageSendRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageSendRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageSendRequest&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.content, content) || other.content == content)&&(identical(other.storageKey, storageKey) || other.storageKey == storageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,messageType,content,storageKey);
}

@override
String toString() {
    return 'ChatMessageSendRequest(messageType: $messageType, content: $content, storageKey: $storageKey)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageSendRequestCopyWith<$Res> implements $ChatMessageSendRequestCopyWith<$Res> {
  factory _$ChatMessageSendRequestCopyWith(_ChatMessageSendRequest value, $Res Function(_ChatMessageSendRequest) _then) = __$ChatMessageSendRequestCopyWithImpl;
@override @useResult
$Res call({
 ChatMessageType messageType, String? content, String? storageKey
});




}
/// @nodoc
class __$ChatMessageSendRequestCopyWithImpl<$Res>
    implements _$ChatMessageSendRequestCopyWith<$Res> {
  __$ChatMessageSendRequestCopyWithImpl(this._self, this._then);

  final _ChatMessageSendRequest _self;
  final $Res Function(_ChatMessageSendRequest) _then;

/// Create a copy of ChatMessageSendRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageType = null,Object? content = freezed,Object? storageKey = freezed,}) {
  return _then(_ChatMessageSendRequest(
messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as ChatMessageType,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,storageKey: freezed == storageKey ? _self.storageKey : storageKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChatMessageSendData {

 int get messageId; int get chatId; int get senderId; String get content;@JsonKey(unknownEnumValue: ChatMessageType.unknown) ChatMessageType get messageType; DateTime get createdAt;
/// Create a copy of ChatMessageSendData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageSendDataCopyWith<ChatMessageSendData> get copyWith => _$ChatMessageSendDataCopyWithImpl<ChatMessageSendData>(this as ChatMessageSendData, _$identity);

  /// Serializes this ChatMessageSendData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMessageSendData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageSendData&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.chatId, _this.chatId) || other.chatId == _this.chatId)&&(identical(other.senderId, _this.senderId) || other.senderId == _this.senderId)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.messageType, _this.messageType) || other.messageType == _this.messageType)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMessageSendData;
  return Object.hash(runtimeType,_this.messageId,_this.chatId,_this.senderId,_this.content,_this.messageType,_this.createdAt);
}

@override
String toString() {
  final _this = this as ChatMessageSendData;
  return 'ChatMessageSendData(messageId: ${_this.messageId}, chatId: ${_this.chatId}, senderId: ${_this.senderId}, content: ${_this.content}, messageType: ${_this.messageType}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ChatMessageSendDataCopyWith<$Res>  {
  factory $ChatMessageSendDataCopyWith(ChatMessageSendData value, $Res Function(ChatMessageSendData) _then) = _$ChatMessageSendDataCopyWithImpl;
@useResult
$Res call({
 int messageId, int chatId, int senderId, String content,@JsonKey(unknownEnumValue: ChatMessageType.unknown) ChatMessageType messageType, DateTime createdAt
});




}
/// @nodoc
class _$ChatMessageSendDataCopyWithImpl<$Res>
    implements $ChatMessageSendDataCopyWith<$Res> {
  _$ChatMessageSendDataCopyWithImpl(this._self, this._then);

  final ChatMessageSendData _self;
  final $Res Function(ChatMessageSendData) _then;

/// Create a copy of ChatMessageSendData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? chatId = null,Object? senderId = null,Object? content = null,Object? messageType = null,Object? createdAt = null,}) {
  return _then(ChatMessageSendData(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as ChatMessageType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageSendData].
extension ChatMessageSendDataPatterns on ChatMessageSendData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageSendData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageSendData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageSendData value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageSendData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageSendData value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageSendData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int messageId,  int chatId,  int senderId,  String content, @JsonKey(unknownEnumValue: ChatMessageType.unknown)  ChatMessageType messageType,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageSendData() when $default != null:
return $default(_that.messageId,_that.chatId,_that.senderId,_that.content,_that.messageType,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int messageId,  int chatId,  int senderId,  String content, @JsonKey(unknownEnumValue: ChatMessageType.unknown)  ChatMessageType messageType,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageSendData():
return $default(_that.messageId,_that.chatId,_that.senderId,_that.content,_that.messageType,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int messageId,  int chatId,  int senderId,  String content, @JsonKey(unknownEnumValue: ChatMessageType.unknown)  ChatMessageType messageType,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageSendData() when $default != null:
return $default(_that.messageId,_that.chatId,_that.senderId,_that.content,_that.messageType,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageSendData implements ChatMessageSendData {
  const _ChatMessageSendData({required this.messageId, required this.chatId, required this.senderId, required this.content, @JsonKey(unknownEnumValue: ChatMessageType.unknown) required this.messageType, required this.createdAt});
  factory _ChatMessageSendData.fromJson(Map<String, dynamic> json) => _$ChatMessageSendDataFromJson(json);

@override final  int messageId;
@override final  int chatId;
@override final  int senderId;
@override final  String content;
@override@JsonKey(unknownEnumValue: ChatMessageType.unknown) final  ChatMessageType messageType;
@override final  DateTime createdAt;

/// Create a copy of ChatMessageSendData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageSendDataCopyWith<_ChatMessageSendData> get copyWith => __$ChatMessageSendDataCopyWithImpl<_ChatMessageSendData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageSendDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageSendData&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.content, content) || other.content == content)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,messageId,chatId,senderId,content,messageType,createdAt);
}

@override
String toString() {
    return 'ChatMessageSendData(messageId: $messageId, chatId: $chatId, senderId: $senderId, content: $content, messageType: $messageType, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageSendDataCopyWith<$Res> implements $ChatMessageSendDataCopyWith<$Res> {
  factory _$ChatMessageSendDataCopyWith(_ChatMessageSendData value, $Res Function(_ChatMessageSendData) _then) = __$ChatMessageSendDataCopyWithImpl;
@override @useResult
$Res call({
 int messageId, int chatId, int senderId, String content,@JsonKey(unknownEnumValue: ChatMessageType.unknown) ChatMessageType messageType, DateTime createdAt
});




}
/// @nodoc
class __$ChatMessageSendDataCopyWithImpl<$Res>
    implements _$ChatMessageSendDataCopyWith<$Res> {
  __$ChatMessageSendDataCopyWithImpl(this._self, this._then);

  final _ChatMessageSendData _self;
  final $Res Function(_ChatMessageSendData) _then;

/// Create a copy of ChatMessageSendData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? chatId = null,Object? senderId = null,Object? content = null,Object? messageType = null,Object? createdAt = null,}) {
  return _then(_ChatMessageSendData(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as ChatMessageType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
