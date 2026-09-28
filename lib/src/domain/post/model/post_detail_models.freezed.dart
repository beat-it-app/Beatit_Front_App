// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_detail_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostComment {

 int get commentId; int? get parentCommentId; String get writerName; String get content; DateTime get createdAt; String? get profileImageUrl;@JsonKey(name: 'writer') bool get isWriter;@JsonKey(name: 'mine') bool get isMine; List<PostMentionUser> get mentionedUsers; List<PostComment> get replies;
/// Create a copy of PostComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCommentCopyWith<PostComment> get copyWith => _$PostCommentCopyWithImpl<PostComment>(this as PostComment, _$identity);

  /// Serializes this PostComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostComment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostComment&&(identical(other.commentId, _this.commentId) || other.commentId == _this.commentId)&&(identical(other.parentCommentId, _this.parentCommentId) || other.parentCommentId == _this.parentCommentId)&&(identical(other.writerName, _this.writerName) || other.writerName == _this.writerName)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.profileImageUrl, _this.profileImageUrl) || other.profileImageUrl == _this.profileImageUrl)&&(identical(other.isWriter, _this.isWriter) || other.isWriter == _this.isWriter)&&(identical(other.isMine, _this.isMine) || other.isMine == _this.isMine)&&const DeepCollectionEquality().equals(other.mentionedUsers, _this.mentionedUsers)&&const DeepCollectionEquality().equals(other.replies, _this.replies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostComment;
  return Object.hash(runtimeType,_this.commentId,_this.parentCommentId,_this.writerName,_this.content,_this.createdAt,_this.profileImageUrl,_this.isWriter,_this.isMine,const DeepCollectionEquality().hash(_this.mentionedUsers),const DeepCollectionEquality().hash(_this.replies));
}

@override
String toString() {
  final _this = this as PostComment;
  return 'PostComment(commentId: ${_this.commentId}, parentCommentId: ${_this.parentCommentId}, writerName: ${_this.writerName}, content: ${_this.content}, createdAt: ${_this.createdAt}, profileImageUrl: ${_this.profileImageUrl}, isWriter: ${_this.isWriter}, isMine: ${_this.isMine}, mentionedUsers: ${_this.mentionedUsers}, replies: ${_this.replies})';
}


}

/// @nodoc
abstract mixin class $PostCommentCopyWith<$Res>  {
  factory $PostCommentCopyWith(PostComment value, $Res Function(PostComment) _then) = _$PostCommentCopyWithImpl;
@useResult
$Res call({
 int commentId, int? parentCommentId, String writerName, String content, DateTime createdAt, String? profileImageUrl,@JsonKey(name: 'writer') bool isWriter,@JsonKey(name: 'mine') bool isMine, List<PostMentionUser> mentionedUsers, List<PostComment> replies
});




}
/// @nodoc
class _$PostCommentCopyWithImpl<$Res>
    implements $PostCommentCopyWith<$Res> {
  _$PostCommentCopyWithImpl(this._self, this._then);

  final PostComment _self;
  final $Res Function(PostComment) _then;

/// Create a copy of PostComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? commentId = null,Object? parentCommentId = freezed,Object? writerName = null,Object? content = null,Object? createdAt = null,Object? profileImageUrl = freezed,Object? isWriter = null,Object? isMine = null,Object? mentionedUsers = null,Object? replies = null,}) {
  return _then(PostComment(
commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as int,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as int?,writerName: null == writerName ? _self.writerName : writerName // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,isWriter: null == isWriter ? _self.isWriter : isWriter // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,mentionedUsers: null == mentionedUsers ? _self.mentionedUsers : mentionedUsers // ignore: cast_nullable_to_non_nullable
as List<PostMentionUser>,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<PostComment>,
  ));
}

}


/// Adds pattern-matching-related methods to [PostComment].
extension PostCommentPatterns on PostComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostComment value)  $default,){
final _that = this;
switch (_that) {
case _PostComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostComment value)?  $default,){
final _that = this;
switch (_that) {
case _PostComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int commentId,  int? parentCommentId,  String writerName,  String content,  DateTime createdAt,  String? profileImageUrl, @JsonKey(name: 'writer')  bool isWriter, @JsonKey(name: 'mine')  bool isMine,  List<PostMentionUser> mentionedUsers,  List<PostComment> replies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostComment() when $default != null:
return $default(_that.commentId,_that.parentCommentId,_that.writerName,_that.content,_that.createdAt,_that.profileImageUrl,_that.isWriter,_that.isMine,_that.mentionedUsers,_that.replies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int commentId,  int? parentCommentId,  String writerName,  String content,  DateTime createdAt,  String? profileImageUrl, @JsonKey(name: 'writer')  bool isWriter, @JsonKey(name: 'mine')  bool isMine,  List<PostMentionUser> mentionedUsers,  List<PostComment> replies)  $default,) {final _that = this;
switch (_that) {
case _PostComment():
return $default(_that.commentId,_that.parentCommentId,_that.writerName,_that.content,_that.createdAt,_that.profileImageUrl,_that.isWriter,_that.isMine,_that.mentionedUsers,_that.replies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int commentId,  int? parentCommentId,  String writerName,  String content,  DateTime createdAt,  String? profileImageUrl, @JsonKey(name: 'writer')  bool isWriter, @JsonKey(name: 'mine')  bool isMine,  List<PostMentionUser> mentionedUsers,  List<PostComment> replies)?  $default,) {final _that = this;
switch (_that) {
case _PostComment() when $default != null:
return $default(_that.commentId,_that.parentCommentId,_that.writerName,_that.content,_that.createdAt,_that.profileImageUrl,_that.isWriter,_that.isMine,_that.mentionedUsers,_that.replies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostComment implements PostComment {
  const _PostComment({required this.commentId, this.parentCommentId, required this.writerName, required this.content, required this.createdAt, this.profileImageUrl, @JsonKey(name: 'writer') this.isWriter = false, @JsonKey(name: 'mine') this.isMine = false,  List<PostMentionUser> mentionedUsers = const <PostMentionUser>[],  List<PostComment> replies = const <PostComment>[]}): _mentionedUsers = mentionedUsers,_replies = replies;
  factory _PostComment.fromJson(Map<String, dynamic> json) => _$PostCommentFromJson(json);

@override final  int commentId;
@override final  int? parentCommentId;
@override final  String writerName;
@override final  String content;
@override final  DateTime createdAt;
@override final  String? profileImageUrl;
@override@JsonKey(name: 'writer') final  bool isWriter;
@override@JsonKey(name: 'mine') final  bool isMine;
 final  List<PostMentionUser> _mentionedUsers;
@override@JsonKey() List<PostMentionUser> get mentionedUsers {
  if (_mentionedUsers is EqualUnmodifiableListView) return _mentionedUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mentionedUsers);
}

 final  List<PostComment> _replies;
@override@JsonKey() List<PostComment> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}


/// Create a copy of PostComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCommentCopyWith<_PostComment> get copyWith => __$PostCommentCopyWithImpl<_PostComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostCommentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostComment&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId)&&(identical(other.writerName, writerName) || other.writerName == writerName)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.isWriter, isWriter) || other.isWriter == isWriter)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&const DeepCollectionEquality().equals(other.mentionedUsers, _mentionedUsers)&&const DeepCollectionEquality().equals(other.replies, _replies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,commentId,parentCommentId,writerName,content,createdAt,profileImageUrl,isWriter,isMine,const DeepCollectionEquality().hash(_mentionedUsers),const DeepCollectionEquality().hash(_replies));
}

@override
String toString() {
    return 'PostComment(commentId: $commentId, parentCommentId: $parentCommentId, writerName: $writerName, content: $content, createdAt: $createdAt, profileImageUrl: $profileImageUrl, isWriter: $isWriter, isMine: $isMine, mentionedUsers: $mentionedUsers, replies: $replies)';
}


}

/// @nodoc
abstract mixin class _$PostCommentCopyWith<$Res> implements $PostCommentCopyWith<$Res> {
  factory _$PostCommentCopyWith(_PostComment value, $Res Function(_PostComment) _then) = __$PostCommentCopyWithImpl;
@override @useResult
$Res call({
 int commentId, int? parentCommentId, String writerName, String content, DateTime createdAt, String? profileImageUrl,@JsonKey(name: 'writer') bool isWriter,@JsonKey(name: 'mine') bool isMine, List<PostMentionUser> mentionedUsers, List<PostComment> replies
});




}
/// @nodoc
class __$PostCommentCopyWithImpl<$Res>
    implements _$PostCommentCopyWith<$Res> {
  __$PostCommentCopyWithImpl(this._self, this._then);

  final _PostComment _self;
  final $Res Function(_PostComment) _then;

/// Create a copy of PostComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? commentId = null,Object? parentCommentId = freezed,Object? writerName = null,Object? content = null,Object? createdAt = null,Object? profileImageUrl = freezed,Object? isWriter = null,Object? isMine = null,Object? mentionedUsers = null,Object? replies = null,}) {
  return _then(_PostComment(
commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as int,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as int?,writerName: null == writerName ? _self.writerName : writerName // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,isWriter: null == isWriter ? _self.isWriter : isWriter // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,mentionedUsers: null == mentionedUsers ? _self._mentionedUsers : mentionedUsers // ignore: cast_nullable_to_non_nullable
as List<PostMentionUser>,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<PostComment>,
  ));
}


}


/// @nodoc
mixin _$PostMentionUser {

 int get userId; String get name; String? get profileImageUrl;
/// Create a copy of PostMentionUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostMentionUserCopyWith<PostMentionUser> get copyWith => _$PostMentionUserCopyWithImpl<PostMentionUser>(this as PostMentionUser, _$identity);

  /// Serializes this PostMentionUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PostMentionUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostMentionUser&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.profileImageUrl, _this.profileImageUrl) || other.profileImageUrl == _this.profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PostMentionUser;
  return Object.hash(runtimeType,_this.userId,_this.name,_this.profileImageUrl);
}

@override
String toString() {
  final _this = this as PostMentionUser;
  return 'PostMentionUser(userId: ${_this.userId}, name: ${_this.name}, profileImageUrl: ${_this.profileImageUrl})';
}


}

/// @nodoc
abstract mixin class $PostMentionUserCopyWith<$Res>  {
  factory $PostMentionUserCopyWith(PostMentionUser value, $Res Function(PostMentionUser) _then) = _$PostMentionUserCopyWithImpl;
@useResult
$Res call({
 int userId, String name, String? profileImageUrl
});




}
/// @nodoc
class _$PostMentionUserCopyWithImpl<$Res>
    implements $PostMentionUserCopyWith<$Res> {
  _$PostMentionUserCopyWithImpl(this._self, this._then);

  final PostMentionUser _self;
  final $Res Function(PostMentionUser) _then;

/// Create a copy of PostMentionUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? profileImageUrl = freezed,}) {
  return _then(PostMentionUser(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PostMentionUser].
extension PostMentionUserPatterns on PostMentionUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostMentionUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostMentionUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostMentionUser value)  $default,){
final _that = this;
switch (_that) {
case _PostMentionUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostMentionUser value)?  $default,){
final _that = this;
switch (_that) {
case _PostMentionUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  String name,  String? profileImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostMentionUser() when $default != null:
return $default(_that.userId,_that.name,_that.profileImageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  String name,  String? profileImageUrl)  $default,) {final _that = this;
switch (_that) {
case _PostMentionUser():
return $default(_that.userId,_that.name,_that.profileImageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  String name,  String? profileImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _PostMentionUser() when $default != null:
return $default(_that.userId,_that.name,_that.profileImageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostMentionUser implements PostMentionUser {
  const _PostMentionUser({required this.userId, required this.name, this.profileImageUrl});
  factory _PostMentionUser.fromJson(Map<String, dynamic> json) => _$PostMentionUserFromJson(json);

@override final  int userId;
@override final  String name;
@override final  String? profileImageUrl;

/// Create a copy of PostMentionUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostMentionUserCopyWith<_PostMentionUser> get copyWith => __$PostMentionUserCopyWithImpl<_PostMentionUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostMentionUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostMentionUser&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,name,profileImageUrl);
}

@override
String toString() {
    return 'PostMentionUser(userId: $userId, name: $name, profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class _$PostMentionUserCopyWith<$Res> implements $PostMentionUserCopyWith<$Res> {
  factory _$PostMentionUserCopyWith(_PostMentionUser value, $Res Function(_PostMentionUser) _then) = __$PostMentionUserCopyWithImpl;
@override @useResult
$Res call({
 int userId, String name, String? profileImageUrl
});




}
/// @nodoc
class __$PostMentionUserCopyWithImpl<$Res>
    implements _$PostMentionUserCopyWith<$Res> {
  __$PostMentionUserCopyWithImpl(this._self, this._then);

  final _PostMentionUser _self;
  final $Res Function(_PostMentionUser) _then;

/// Create a copy of PostMentionUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? profileImageUrl = freezed,}) {
  return _then(_PostMentionUser(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NoticeDetailResponse {

 bool get success; int get status; String get message; NoticeDetailData get data;
/// Create a copy of NoticeDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeDetailResponseCopyWith<NoticeDetailResponse> get copyWith => _$NoticeDetailResponseCopyWithImpl<NoticeDetailResponse>(this as NoticeDetailResponse, _$identity);

  /// Serializes this NoticeDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NoticeDetailResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticeDetailResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NoticeDetailResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as NoticeDetailResponse;
  return 'NoticeDetailResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $NoticeDetailResponseCopyWith<$Res>  {
  factory $NoticeDetailResponseCopyWith(NoticeDetailResponse value, $Res Function(NoticeDetailResponse) _then) = _$NoticeDetailResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, NoticeDetailData data
});


$NoticeDetailDataCopyWith<$Res> get data;

}
/// @nodoc
class _$NoticeDetailResponseCopyWithImpl<$Res>
    implements $NoticeDetailResponseCopyWith<$Res> {
  _$NoticeDetailResponseCopyWithImpl(this._self, this._then);

  final NoticeDetailResponse _self;
  final $Res Function(NoticeDetailResponse) _then;

/// Create a copy of NoticeDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(NoticeDetailResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NoticeDetailData,
  ));
}
/// Create a copy of NoticeDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoticeDetailDataCopyWith<$Res> get data {
  
  return $NoticeDetailDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [NoticeDetailResponse].
extension NoticeDetailResponsePatterns on NoticeDetailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoticeDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoticeDetailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoticeDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _NoticeDetailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoticeDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NoticeDetailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  NoticeDetailData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoticeDetailResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  NoticeDetailData data)  $default,) {final _that = this;
switch (_that) {
case _NoticeDetailResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  NoticeDetailData data)?  $default,) {final _that = this;
switch (_that) {
case _NoticeDetailResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoticeDetailResponse implements NoticeDetailResponse {
  const _NoticeDetailResponse({required this.success, required this.status, required this.message, required this.data});
  factory _NoticeDetailResponse.fromJson(Map<String, dynamic> json) => _$NoticeDetailResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  NoticeDetailData data;

/// Create a copy of NoticeDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeDetailResponseCopyWith<_NoticeDetailResponse> get copyWith => __$NoticeDetailResponseCopyWithImpl<_NoticeDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticeDetailResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'NoticeDetailResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$NoticeDetailResponseCopyWith<$Res> implements $NoticeDetailResponseCopyWith<$Res> {
  factory _$NoticeDetailResponseCopyWith(_NoticeDetailResponse value, $Res Function(_NoticeDetailResponse) _then) = __$NoticeDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, NoticeDetailData data
});


@override $NoticeDetailDataCopyWith<$Res> get data;

}
/// @nodoc
class __$NoticeDetailResponseCopyWithImpl<$Res>
    implements _$NoticeDetailResponseCopyWith<$Res> {
  __$NoticeDetailResponseCopyWithImpl(this._self, this._then);

  final _NoticeDetailResponse _self;
  final $Res Function(_NoticeDetailResponse) _then;

/// Create a copy of NoticeDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_NoticeDetailResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NoticeDetailData,
  ));
}

/// Create a copy of NoticeDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoticeDetailDataCopyWith<$Res> get data {
  
  return $NoticeDetailDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$NoticeDetailData {

 int get noticeId; String get title; String get content; String get writerName; String? get writerProfileImageUrl; DateTime get createdAt; DateTime get updatedAt; List<String> get images;@JsonKey(name: 'writer') bool get isWriter; NoticeReaction get reaction; List<PostComment> get commentList;
/// Create a copy of NoticeDetailData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeDetailDataCopyWith<NoticeDetailData> get copyWith => _$NoticeDetailDataCopyWithImpl<NoticeDetailData>(this as NoticeDetailData, _$identity);

  /// Serializes this NoticeDetailData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NoticeDetailData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticeDetailData&&(identical(other.noticeId, _this.noticeId) || other.noticeId == _this.noticeId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.writerName, _this.writerName) || other.writerName == _this.writerName)&&(identical(other.writerProfileImageUrl, _this.writerProfileImageUrl) || other.writerProfileImageUrl == _this.writerProfileImageUrl)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.images, _this.images)&&(identical(other.isWriter, _this.isWriter) || other.isWriter == _this.isWriter)&&(identical(other.reaction, _this.reaction) || other.reaction == _this.reaction)&&const DeepCollectionEquality().equals(other.commentList, _this.commentList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NoticeDetailData;
  return Object.hash(runtimeType,_this.noticeId,_this.title,_this.content,_this.writerName,_this.writerProfileImageUrl,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.images),_this.isWriter,_this.reaction,const DeepCollectionEquality().hash(_this.commentList));
}

@override
String toString() {
  final _this = this as NoticeDetailData;
  return 'NoticeDetailData(noticeId: ${_this.noticeId}, title: ${_this.title}, content: ${_this.content}, writerName: ${_this.writerName}, writerProfileImageUrl: ${_this.writerProfileImageUrl}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, images: ${_this.images}, isWriter: ${_this.isWriter}, reaction: ${_this.reaction}, commentList: ${_this.commentList})';
}


}

/// @nodoc
abstract mixin class $NoticeDetailDataCopyWith<$Res>  {
  factory $NoticeDetailDataCopyWith(NoticeDetailData value, $Res Function(NoticeDetailData) _then) = _$NoticeDetailDataCopyWithImpl;
@useResult
$Res call({
 int noticeId, String title, String content, String writerName, String? writerProfileImageUrl, DateTime createdAt, DateTime updatedAt, List<String> images,@JsonKey(name: 'writer') bool isWriter, NoticeReaction reaction, List<PostComment> commentList
});


$NoticeReactionCopyWith<$Res> get reaction;

}
/// @nodoc
class _$NoticeDetailDataCopyWithImpl<$Res>
    implements $NoticeDetailDataCopyWith<$Res> {
  _$NoticeDetailDataCopyWithImpl(this._self, this._then);

  final NoticeDetailData _self;
  final $Res Function(NoticeDetailData) _then;

/// Create a copy of NoticeDetailData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noticeId = null,Object? title = null,Object? content = null,Object? writerName = null,Object? writerProfileImageUrl = freezed,Object? createdAt = null,Object? updatedAt = null,Object? images = null,Object? isWriter = null,Object? reaction = null,Object? commentList = null,}) {
  return _then(NoticeDetailData(
noticeId: null == noticeId ? _self.noticeId : noticeId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,writerName: null == writerName ? _self.writerName : writerName // ignore: cast_nullable_to_non_nullable
as String,writerProfileImageUrl: freezed == writerProfileImageUrl ? _self.writerProfileImageUrl : writerProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,isWriter: null == isWriter ? _self.isWriter : isWriter // ignore: cast_nullable_to_non_nullable
as bool,reaction: null == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as NoticeReaction,commentList: null == commentList ? _self.commentList : commentList // ignore: cast_nullable_to_non_nullable
as List<PostComment>,
  ));
}
/// Create a copy of NoticeDetailData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoticeReactionCopyWith<$Res> get reaction {
  
  return $NoticeReactionCopyWith<$Res>(_self.reaction, (value) {
    return _then(_self.copyWith(reaction: value));
  });
}
}


/// Adds pattern-matching-related methods to [NoticeDetailData].
extension NoticeDetailDataPatterns on NoticeDetailData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoticeDetailData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoticeDetailData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoticeDetailData value)  $default,){
final _that = this;
switch (_that) {
case _NoticeDetailData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoticeDetailData value)?  $default,){
final _that = this;
switch (_that) {
case _NoticeDetailData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int noticeId,  String title,  String content,  String writerName,  String? writerProfileImageUrl,  DateTime createdAt,  DateTime updatedAt,  List<String> images, @JsonKey(name: 'writer')  bool isWriter,  NoticeReaction reaction,  List<PostComment> commentList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoticeDetailData() when $default != null:
return $default(_that.noticeId,_that.title,_that.content,_that.writerName,_that.writerProfileImageUrl,_that.createdAt,_that.updatedAt,_that.images,_that.isWriter,_that.reaction,_that.commentList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int noticeId,  String title,  String content,  String writerName,  String? writerProfileImageUrl,  DateTime createdAt,  DateTime updatedAt,  List<String> images, @JsonKey(name: 'writer')  bool isWriter,  NoticeReaction reaction,  List<PostComment> commentList)  $default,) {final _that = this;
switch (_that) {
case _NoticeDetailData():
return $default(_that.noticeId,_that.title,_that.content,_that.writerName,_that.writerProfileImageUrl,_that.createdAt,_that.updatedAt,_that.images,_that.isWriter,_that.reaction,_that.commentList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int noticeId,  String title,  String content,  String writerName,  String? writerProfileImageUrl,  DateTime createdAt,  DateTime updatedAt,  List<String> images, @JsonKey(name: 'writer')  bool isWriter,  NoticeReaction reaction,  List<PostComment> commentList)?  $default,) {final _that = this;
switch (_that) {
case _NoticeDetailData() when $default != null:
return $default(_that.noticeId,_that.title,_that.content,_that.writerName,_that.writerProfileImageUrl,_that.createdAt,_that.updatedAt,_that.images,_that.isWriter,_that.reaction,_that.commentList);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoticeDetailData implements NoticeDetailData {
  const _NoticeDetailData({required this.noticeId, required this.title, required this.content, required this.writerName, this.writerProfileImageUrl, required this.createdAt, required this.updatedAt,  List<String> images = const <String>[], @JsonKey(name: 'writer') this.isWriter = false, required this.reaction,  List<PostComment> commentList = const <PostComment>[]}): _images = images,_commentList = commentList;
  factory _NoticeDetailData.fromJson(Map<String, dynamic> json) => _$NoticeDetailDataFromJson(json);

@override final  int noticeId;
@override final  String title;
@override final  String content;
@override final  String writerName;
@override final  String? writerProfileImageUrl;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override@JsonKey(name: 'writer') final  bool isWriter;
@override final  NoticeReaction reaction;
 final  List<PostComment> _commentList;
@override@JsonKey() List<PostComment> get commentList {
  if (_commentList is EqualUnmodifiableListView) return _commentList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_commentList);
}


/// Create a copy of NoticeDetailData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeDetailDataCopyWith<_NoticeDetailData> get copyWith => __$NoticeDetailDataCopyWithImpl<_NoticeDetailData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeDetailDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticeDetailData&&(identical(other.noticeId, noticeId) || other.noticeId == noticeId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.writerName, writerName) || other.writerName == writerName)&&(identical(other.writerProfileImageUrl, writerProfileImageUrl) || other.writerProfileImageUrl == writerProfileImageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.images, _images)&&(identical(other.isWriter, isWriter) || other.isWriter == isWriter)&&(identical(other.reaction, reaction) || other.reaction == reaction)&&const DeepCollectionEquality().equals(other.commentList, _commentList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,noticeId,title,content,writerName,writerProfileImageUrl,createdAt,updatedAt,const DeepCollectionEquality().hash(_images),isWriter,reaction,const DeepCollectionEquality().hash(_commentList));
}

@override
String toString() {
    return 'NoticeDetailData(noticeId: $noticeId, title: $title, content: $content, writerName: $writerName, writerProfileImageUrl: $writerProfileImageUrl, createdAt: $createdAt, updatedAt: $updatedAt, images: $images, isWriter: $isWriter, reaction: $reaction, commentList: $commentList)';
}


}

/// @nodoc
abstract mixin class _$NoticeDetailDataCopyWith<$Res> implements $NoticeDetailDataCopyWith<$Res> {
  factory _$NoticeDetailDataCopyWith(_NoticeDetailData value, $Res Function(_NoticeDetailData) _then) = __$NoticeDetailDataCopyWithImpl;
@override @useResult
$Res call({
 int noticeId, String title, String content, String writerName, String? writerProfileImageUrl, DateTime createdAt, DateTime updatedAt, List<String> images,@JsonKey(name: 'writer') bool isWriter, NoticeReaction reaction, List<PostComment> commentList
});


@override $NoticeReactionCopyWith<$Res> get reaction;

}
/// @nodoc
class __$NoticeDetailDataCopyWithImpl<$Res>
    implements _$NoticeDetailDataCopyWith<$Res> {
  __$NoticeDetailDataCopyWithImpl(this._self, this._then);

  final _NoticeDetailData _self;
  final $Res Function(_NoticeDetailData) _then;

/// Create a copy of NoticeDetailData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noticeId = null,Object? title = null,Object? content = null,Object? writerName = null,Object? writerProfileImageUrl = freezed,Object? createdAt = null,Object? updatedAt = null,Object? images = null,Object? isWriter = null,Object? reaction = null,Object? commentList = null,}) {
  return _then(_NoticeDetailData(
noticeId: null == noticeId ? _self.noticeId : noticeId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,writerName: null == writerName ? _self.writerName : writerName // ignore: cast_nullable_to_non_nullable
as String,writerProfileImageUrl: freezed == writerProfileImageUrl ? _self.writerProfileImageUrl : writerProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,isWriter: null == isWriter ? _self.isWriter : isWriter // ignore: cast_nullable_to_non_nullable
as bool,reaction: null == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as NoticeReaction,commentList: null == commentList ? _self._commentList : commentList // ignore: cast_nullable_to_non_nullable
as List<PostComment>,
  ));
}

/// Create a copy of NoticeDetailData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoticeReactionCopyWith<$Res> get reaction {
  
  return $NoticeReactionCopyWith<$Res>(_self.reaction, (value) {
    return _then(_self.copyWith(reaction: value));
  });
}
}


/// @nodoc
mixin _$NoticeReaction {

 int get likeCount; int get dislikeCount;@JsonKey(name: 'liked') bool get isLiked;@JsonKey(name: 'disliked') bool get isDisliked; int get commentCount;
/// Create a copy of NoticeReaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeReactionCopyWith<NoticeReaction> get copyWith => _$NoticeReactionCopyWithImpl<NoticeReaction>(this as NoticeReaction, _$identity);

  /// Serializes this NoticeReaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NoticeReaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticeReaction&&(identical(other.likeCount, _this.likeCount) || other.likeCount == _this.likeCount)&&(identical(other.dislikeCount, _this.dislikeCount) || other.dislikeCount == _this.dislikeCount)&&(identical(other.isLiked, _this.isLiked) || other.isLiked == _this.isLiked)&&(identical(other.isDisliked, _this.isDisliked) || other.isDisliked == _this.isDisliked)&&(identical(other.commentCount, _this.commentCount) || other.commentCount == _this.commentCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NoticeReaction;
  return Object.hash(runtimeType,_this.likeCount,_this.dislikeCount,_this.isLiked,_this.isDisliked,_this.commentCount);
}

@override
String toString() {
  final _this = this as NoticeReaction;
  return 'NoticeReaction(likeCount: ${_this.likeCount}, dislikeCount: ${_this.dislikeCount}, isLiked: ${_this.isLiked}, isDisliked: ${_this.isDisliked}, commentCount: ${_this.commentCount})';
}


}

/// @nodoc
abstract mixin class $NoticeReactionCopyWith<$Res>  {
  factory $NoticeReactionCopyWith(NoticeReaction value, $Res Function(NoticeReaction) _then) = _$NoticeReactionCopyWithImpl;
@useResult
$Res call({
 int likeCount, int dislikeCount,@JsonKey(name: 'liked') bool isLiked,@JsonKey(name: 'disliked') bool isDisliked, int commentCount
});




}
/// @nodoc
class _$NoticeReactionCopyWithImpl<$Res>
    implements $NoticeReactionCopyWith<$Res> {
  _$NoticeReactionCopyWithImpl(this._self, this._then);

  final NoticeReaction _self;
  final $Res Function(NoticeReaction) _then;

/// Create a copy of NoticeReaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? likeCount = null,Object? dislikeCount = null,Object? isLiked = null,Object? isDisliked = null,Object? commentCount = null,}) {
  return _then(NoticeReaction(
likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,dislikeCount: null == dislikeCount ? _self.dislikeCount : dislikeCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isDisliked: null == isDisliked ? _self.isDisliked : isDisliked // ignore: cast_nullable_to_non_nullable
as bool,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NoticeReaction].
extension NoticeReactionPatterns on NoticeReaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoticeReaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoticeReaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoticeReaction value)  $default,){
final _that = this;
switch (_that) {
case _NoticeReaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoticeReaction value)?  $default,){
final _that = this;
switch (_that) {
case _NoticeReaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int likeCount,  int dislikeCount, @JsonKey(name: 'liked')  bool isLiked, @JsonKey(name: 'disliked')  bool isDisliked,  int commentCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoticeReaction() when $default != null:
return $default(_that.likeCount,_that.dislikeCount,_that.isLiked,_that.isDisliked,_that.commentCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int likeCount,  int dislikeCount, @JsonKey(name: 'liked')  bool isLiked, @JsonKey(name: 'disliked')  bool isDisliked,  int commentCount)  $default,) {final _that = this;
switch (_that) {
case _NoticeReaction():
return $default(_that.likeCount,_that.dislikeCount,_that.isLiked,_that.isDisliked,_that.commentCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int likeCount,  int dislikeCount, @JsonKey(name: 'liked')  bool isLiked, @JsonKey(name: 'disliked')  bool isDisliked,  int commentCount)?  $default,) {final _that = this;
switch (_that) {
case _NoticeReaction() when $default != null:
return $default(_that.likeCount,_that.dislikeCount,_that.isLiked,_that.isDisliked,_that.commentCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoticeReaction implements NoticeReaction {
  const _NoticeReaction({required this.likeCount, required this.dislikeCount, @JsonKey(name: 'liked') this.isLiked = false, @JsonKey(name: 'disliked') this.isDisliked = false, required this.commentCount});
  factory _NoticeReaction.fromJson(Map<String, dynamic> json) => _$NoticeReactionFromJson(json);

@override final  int likeCount;
@override final  int dislikeCount;
@override@JsonKey(name: 'liked') final  bool isLiked;
@override@JsonKey(name: 'disliked') final  bool isDisliked;
@override final  int commentCount;

/// Create a copy of NoticeReaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeReactionCopyWith<_NoticeReaction> get copyWith => __$NoticeReactionCopyWithImpl<_NoticeReaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeReactionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticeReaction&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.dislikeCount, dislikeCount) || other.dislikeCount == dislikeCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isDisliked, isDisliked) || other.isDisliked == isDisliked)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,likeCount,dislikeCount,isLiked,isDisliked,commentCount);
}

@override
String toString() {
    return 'NoticeReaction(likeCount: $likeCount, dislikeCount: $dislikeCount, isLiked: $isLiked, isDisliked: $isDisliked, commentCount: $commentCount)';
}


}

/// @nodoc
abstract mixin class _$NoticeReactionCopyWith<$Res> implements $NoticeReactionCopyWith<$Res> {
  factory _$NoticeReactionCopyWith(_NoticeReaction value, $Res Function(_NoticeReaction) _then) = __$NoticeReactionCopyWithImpl;
@override @useResult
$Res call({
 int likeCount, int dislikeCount,@JsonKey(name: 'liked') bool isLiked,@JsonKey(name: 'disliked') bool isDisliked, int commentCount
});




}
/// @nodoc
class __$NoticeReactionCopyWithImpl<$Res>
    implements _$NoticeReactionCopyWith<$Res> {
  __$NoticeReactionCopyWithImpl(this._self, this._then);

  final _NoticeReaction _self;
  final $Res Function(_NoticeReaction) _then;

/// Create a copy of NoticeReaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? likeCount = null,Object? dislikeCount = null,Object? isLiked = null,Object? isDisliked = null,Object? commentCount = null,}) {
  return _then(_NoticeReaction(
likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,dislikeCount: null == dislikeCount ? _self.dislikeCount : dislikeCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isDisliked: null == isDisliked ? _self.isDisliked : isDisliked // ignore: cast_nullable_to_non_nullable
as bool,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PollDetailResponse {

 bool get success; int get status; String get message; PollDetailData get data;
/// Create a copy of PollDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollDetailResponseCopyWith<PollDetailResponse> get copyWith => _$PollDetailResponseCopyWithImpl<PollDetailResponse>(this as PollDetailResponse, _$identity);

  /// Serializes this PollDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PollDetailResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollDetailResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PollDetailResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as PollDetailResponse;
  return 'PollDetailResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $PollDetailResponseCopyWith<$Res>  {
  factory $PollDetailResponseCopyWith(PollDetailResponse value, $Res Function(PollDetailResponse) _then) = _$PollDetailResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, PollDetailData data
});


$PollDetailDataCopyWith<$Res> get data;

}
/// @nodoc
class _$PollDetailResponseCopyWithImpl<$Res>
    implements $PollDetailResponseCopyWith<$Res> {
  _$PollDetailResponseCopyWithImpl(this._self, this._then);

  final PollDetailResponse _self;
  final $Res Function(PollDetailResponse) _then;

/// Create a copy of PollDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(PollDetailResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PollDetailData,
  ));
}
/// Create a copy of PollDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PollDetailDataCopyWith<$Res> get data {
  
  return $PollDetailDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [PollDetailResponse].
extension PollDetailResponsePatterns on PollDetailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollDetailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _PollDetailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PollDetailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  PollDetailData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollDetailResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  PollDetailData data)  $default,) {final _that = this;
switch (_that) {
case _PollDetailResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  PollDetailData data)?  $default,) {final _that = this;
switch (_that) {
case _PollDetailResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollDetailResponse implements PollDetailResponse {
  const _PollDetailResponse({required this.success, required this.status, required this.message, required this.data});
  factory _PollDetailResponse.fromJson(Map<String, dynamic> json) => _$PollDetailResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  PollDetailData data;

/// Create a copy of PollDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollDetailResponseCopyWith<_PollDetailResponse> get copyWith => __$PollDetailResponseCopyWithImpl<_PollDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollDetailResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'PollDetailResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$PollDetailResponseCopyWith<$Res> implements $PollDetailResponseCopyWith<$Res> {
  factory _$PollDetailResponseCopyWith(_PollDetailResponse value, $Res Function(_PollDetailResponse) _then) = __$PollDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, PollDetailData data
});


@override $PollDetailDataCopyWith<$Res> get data;

}
/// @nodoc
class __$PollDetailResponseCopyWithImpl<$Res>
    implements _$PollDetailResponseCopyWith<$Res> {
  __$PollDetailResponseCopyWithImpl(this._self, this._then);

  final _PollDetailResponse _self;
  final $Res Function(_PollDetailResponse) _then;

/// Create a copy of PollDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_PollDetailResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PollDetailData,
  ));
}

/// Create a copy of PollDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PollDetailDataCopyWith<$Res> get data {
  
  return $PollDetailDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$PollDetailData {

 int get pollId; String get title; String? get content; String get pollType; bool get allowMultipleChoice;@JsonKey(name: 'anonymous') bool get isAnonymous; DateTime? get closeAt; String get writerName; String? get writerProfileImageUrl; DateTime get createdAt; DateTime get updatedAt; List<PollDetailItem> get pollItems;@JsonKey(name: 'writer') bool get isWriter; int get commentCount; List<PostComment> get commentList;
/// Create a copy of PollDetailData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollDetailDataCopyWith<PollDetailData> get copyWith => _$PollDetailDataCopyWithImpl<PollDetailData>(this as PollDetailData, _$identity);

  /// Serializes this PollDetailData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PollDetailData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollDetailData&&(identical(other.pollId, _this.pollId) || other.pollId == _this.pollId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.pollType, _this.pollType) || other.pollType == _this.pollType)&&(identical(other.allowMultipleChoice, _this.allowMultipleChoice) || other.allowMultipleChoice == _this.allowMultipleChoice)&&(identical(other.isAnonymous, _this.isAnonymous) || other.isAnonymous == _this.isAnonymous)&&(identical(other.closeAt, _this.closeAt) || other.closeAt == _this.closeAt)&&(identical(other.writerName, _this.writerName) || other.writerName == _this.writerName)&&(identical(other.writerProfileImageUrl, _this.writerProfileImageUrl) || other.writerProfileImageUrl == _this.writerProfileImageUrl)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.pollItems, _this.pollItems)&&(identical(other.isWriter, _this.isWriter) || other.isWriter == _this.isWriter)&&(identical(other.commentCount, _this.commentCount) || other.commentCount == _this.commentCount)&&const DeepCollectionEquality().equals(other.commentList, _this.commentList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PollDetailData;
  return Object.hash(runtimeType,_this.pollId,_this.title,_this.content,_this.pollType,_this.allowMultipleChoice,_this.isAnonymous,_this.closeAt,_this.writerName,_this.writerProfileImageUrl,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.pollItems),_this.isWriter,_this.commentCount,const DeepCollectionEquality().hash(_this.commentList));
}

@override
String toString() {
  final _this = this as PollDetailData;
  return 'PollDetailData(pollId: ${_this.pollId}, title: ${_this.title}, content: ${_this.content}, pollType: ${_this.pollType}, allowMultipleChoice: ${_this.allowMultipleChoice}, isAnonymous: ${_this.isAnonymous}, closeAt: ${_this.closeAt}, writerName: ${_this.writerName}, writerProfileImageUrl: ${_this.writerProfileImageUrl}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, pollItems: ${_this.pollItems}, isWriter: ${_this.isWriter}, commentCount: ${_this.commentCount}, commentList: ${_this.commentList})';
}


}

/// @nodoc
abstract mixin class $PollDetailDataCopyWith<$Res>  {
  factory $PollDetailDataCopyWith(PollDetailData value, $Res Function(PollDetailData) _then) = _$PollDetailDataCopyWithImpl;
@useResult
$Res call({
 int pollId, String title, String? content, String pollType, bool allowMultipleChoice,@JsonKey(name: 'anonymous') bool isAnonymous, DateTime? closeAt, String writerName, String? writerProfileImageUrl, DateTime createdAt, DateTime updatedAt, List<PollDetailItem> pollItems,@JsonKey(name: 'writer') bool isWriter, int commentCount, List<PostComment> commentList
});




}
/// @nodoc
class _$PollDetailDataCopyWithImpl<$Res>
    implements $PollDetailDataCopyWith<$Res> {
  _$PollDetailDataCopyWithImpl(this._self, this._then);

  final PollDetailData _self;
  final $Res Function(PollDetailData) _then;

/// Create a copy of PollDetailData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pollId = null,Object? title = null,Object? content = freezed,Object? pollType = null,Object? allowMultipleChoice = null,Object? isAnonymous = null,Object? closeAt = freezed,Object? writerName = null,Object? writerProfileImageUrl = freezed,Object? createdAt = null,Object? updatedAt = null,Object? pollItems = null,Object? isWriter = null,Object? commentCount = null,Object? commentList = null,}) {
  return _then(PollDetailData(
pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,pollType: null == pollType ? _self.pollType : pollType // ignore: cast_nullable_to_non_nullable
as String,allowMultipleChoice: null == allowMultipleChoice ? _self.allowMultipleChoice : allowMultipleChoice // ignore: cast_nullable_to_non_nullable
as bool,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,closeAt: freezed == closeAt ? _self.closeAt : closeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,writerName: null == writerName ? _self.writerName : writerName // ignore: cast_nullable_to_non_nullable
as String,writerProfileImageUrl: freezed == writerProfileImageUrl ? _self.writerProfileImageUrl : writerProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pollItems: null == pollItems ? _self.pollItems : pollItems // ignore: cast_nullable_to_non_nullable
as List<PollDetailItem>,isWriter: null == isWriter ? _self.isWriter : isWriter // ignore: cast_nullable_to_non_nullable
as bool,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,commentList: null == commentList ? _self.commentList : commentList // ignore: cast_nullable_to_non_nullable
as List<PostComment>,
  ));
}

}


/// Adds pattern-matching-related methods to [PollDetailData].
extension PollDetailDataPatterns on PollDetailData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollDetailData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollDetailData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollDetailData value)  $default,){
final _that = this;
switch (_that) {
case _PollDetailData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollDetailData value)?  $default,){
final _that = this;
switch (_that) {
case _PollDetailData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pollId,  String title,  String? content,  String pollType,  bool allowMultipleChoice, @JsonKey(name: 'anonymous')  bool isAnonymous,  DateTime? closeAt,  String writerName,  String? writerProfileImageUrl,  DateTime createdAt,  DateTime updatedAt,  List<PollDetailItem> pollItems, @JsonKey(name: 'writer')  bool isWriter,  int commentCount,  List<PostComment> commentList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollDetailData() when $default != null:
return $default(_that.pollId,_that.title,_that.content,_that.pollType,_that.allowMultipleChoice,_that.isAnonymous,_that.closeAt,_that.writerName,_that.writerProfileImageUrl,_that.createdAt,_that.updatedAt,_that.pollItems,_that.isWriter,_that.commentCount,_that.commentList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pollId,  String title,  String? content,  String pollType,  bool allowMultipleChoice, @JsonKey(name: 'anonymous')  bool isAnonymous,  DateTime? closeAt,  String writerName,  String? writerProfileImageUrl,  DateTime createdAt,  DateTime updatedAt,  List<PollDetailItem> pollItems, @JsonKey(name: 'writer')  bool isWriter,  int commentCount,  List<PostComment> commentList)  $default,) {final _that = this;
switch (_that) {
case _PollDetailData():
return $default(_that.pollId,_that.title,_that.content,_that.pollType,_that.allowMultipleChoice,_that.isAnonymous,_that.closeAt,_that.writerName,_that.writerProfileImageUrl,_that.createdAt,_that.updatedAt,_that.pollItems,_that.isWriter,_that.commentCount,_that.commentList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pollId,  String title,  String? content,  String pollType,  bool allowMultipleChoice, @JsonKey(name: 'anonymous')  bool isAnonymous,  DateTime? closeAt,  String writerName,  String? writerProfileImageUrl,  DateTime createdAt,  DateTime updatedAt,  List<PollDetailItem> pollItems, @JsonKey(name: 'writer')  bool isWriter,  int commentCount,  List<PostComment> commentList)?  $default,) {final _that = this;
switch (_that) {
case _PollDetailData() when $default != null:
return $default(_that.pollId,_that.title,_that.content,_that.pollType,_that.allowMultipleChoice,_that.isAnonymous,_that.closeAt,_that.writerName,_that.writerProfileImageUrl,_that.createdAt,_that.updatedAt,_that.pollItems,_that.isWriter,_that.commentCount,_that.commentList);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollDetailData implements PollDetailData {
  const _PollDetailData({required this.pollId, required this.title, this.content, required this.pollType, required this.allowMultipleChoice, @JsonKey(name: 'anonymous') required this.isAnonymous, this.closeAt, required this.writerName, this.writerProfileImageUrl, required this.createdAt, required this.updatedAt,  List<PollDetailItem> pollItems = const <PollDetailItem>[], @JsonKey(name: 'writer') this.isWriter = false, required this.commentCount,  List<PostComment> commentList = const <PostComment>[]}): _pollItems = pollItems,_commentList = commentList;
  factory _PollDetailData.fromJson(Map<String, dynamic> json) => _$PollDetailDataFromJson(json);

@override final  int pollId;
@override final  String title;
@override final  String? content;
@override final  String pollType;
@override final  bool allowMultipleChoice;
@override@JsonKey(name: 'anonymous') final  bool isAnonymous;
@override final  DateTime? closeAt;
@override final  String writerName;
@override final  String? writerProfileImageUrl;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<PollDetailItem> _pollItems;
@override@JsonKey() List<PollDetailItem> get pollItems {
  if (_pollItems is EqualUnmodifiableListView) return _pollItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pollItems);
}

@override@JsonKey(name: 'writer') final  bool isWriter;
@override final  int commentCount;
 final  List<PostComment> _commentList;
@override@JsonKey() List<PostComment> get commentList {
  if (_commentList is EqualUnmodifiableListView) return _commentList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_commentList);
}


/// Create a copy of PollDetailData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollDetailDataCopyWith<_PollDetailData> get copyWith => __$PollDetailDataCopyWithImpl<_PollDetailData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollDetailDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollDetailData&&(identical(other.pollId, pollId) || other.pollId == pollId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.pollType, pollType) || other.pollType == pollType)&&(identical(other.allowMultipleChoice, allowMultipleChoice) || other.allowMultipleChoice == allowMultipleChoice)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.closeAt, closeAt) || other.closeAt == closeAt)&&(identical(other.writerName, writerName) || other.writerName == writerName)&&(identical(other.writerProfileImageUrl, writerProfileImageUrl) || other.writerProfileImageUrl == writerProfileImageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.pollItems, _pollItems)&&(identical(other.isWriter, isWriter) || other.isWriter == isWriter)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&const DeepCollectionEquality().equals(other.commentList, _commentList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,pollId,title,content,pollType,allowMultipleChoice,isAnonymous,closeAt,writerName,writerProfileImageUrl,createdAt,updatedAt,const DeepCollectionEquality().hash(_pollItems),isWriter,commentCount,const DeepCollectionEquality().hash(_commentList));
}

@override
String toString() {
    return 'PollDetailData(pollId: $pollId, title: $title, content: $content, pollType: $pollType, allowMultipleChoice: $allowMultipleChoice, isAnonymous: $isAnonymous, closeAt: $closeAt, writerName: $writerName, writerProfileImageUrl: $writerProfileImageUrl, createdAt: $createdAt, updatedAt: $updatedAt, pollItems: $pollItems, isWriter: $isWriter, commentCount: $commentCount, commentList: $commentList)';
}


}

/// @nodoc
abstract mixin class _$PollDetailDataCopyWith<$Res> implements $PollDetailDataCopyWith<$Res> {
  factory _$PollDetailDataCopyWith(_PollDetailData value, $Res Function(_PollDetailData) _then) = __$PollDetailDataCopyWithImpl;
@override @useResult
$Res call({
 int pollId, String title, String? content, String pollType, bool allowMultipleChoice,@JsonKey(name: 'anonymous') bool isAnonymous, DateTime? closeAt, String writerName, String? writerProfileImageUrl, DateTime createdAt, DateTime updatedAt, List<PollDetailItem> pollItems,@JsonKey(name: 'writer') bool isWriter, int commentCount, List<PostComment> commentList
});




}
/// @nodoc
class __$PollDetailDataCopyWithImpl<$Res>
    implements _$PollDetailDataCopyWith<$Res> {
  __$PollDetailDataCopyWithImpl(this._self, this._then);

  final _PollDetailData _self;
  final $Res Function(_PollDetailData) _then;

/// Create a copy of PollDetailData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pollId = null,Object? title = null,Object? content = freezed,Object? pollType = null,Object? allowMultipleChoice = null,Object? isAnonymous = null,Object? closeAt = freezed,Object? writerName = null,Object? writerProfileImageUrl = freezed,Object? createdAt = null,Object? updatedAt = null,Object? pollItems = null,Object? isWriter = null,Object? commentCount = null,Object? commentList = null,}) {
  return _then(_PollDetailData(
pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,pollType: null == pollType ? _self.pollType : pollType // ignore: cast_nullable_to_non_nullable
as String,allowMultipleChoice: null == allowMultipleChoice ? _self.allowMultipleChoice : allowMultipleChoice // ignore: cast_nullable_to_non_nullable
as bool,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,closeAt: freezed == closeAt ? _self.closeAt : closeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,writerName: null == writerName ? _self.writerName : writerName // ignore: cast_nullable_to_non_nullable
as String,writerProfileImageUrl: freezed == writerProfileImageUrl ? _self.writerProfileImageUrl : writerProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,pollItems: null == pollItems ? _self._pollItems : pollItems // ignore: cast_nullable_to_non_nullable
as List<PollDetailItem>,isWriter: null == isWriter ? _self.isWriter : isWriter // ignore: cast_nullable_to_non_nullable
as bool,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,commentList: null == commentList ? _self._commentList : commentList // ignore: cast_nullable_to_non_nullable
as List<PostComment>,
  ));
}


}


/// @nodoc
mixin _$PollDetailItem {

 int get itemId; int get voteCount;@JsonKey(name: 'voted') bool get isVoted; String? get content; String? get title; String? get artist; String? get previewUrl; String? get location; int? get locationId; String? get locationName; String? get roadAddress;
/// Create a copy of PollDetailItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollDetailItemCopyWith<PollDetailItem> get copyWith => _$PollDetailItemCopyWithImpl<PollDetailItem>(this as PollDetailItem, _$identity);

  /// Serializes this PollDetailItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PollDetailItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollDetailItem&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.voteCount, _this.voteCount) || other.voteCount == _this.voteCount)&&(identical(other.isVoted, _this.isVoted) || other.isVoted == _this.isVoted)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.artist, _this.artist) || other.artist == _this.artist)&&(identical(other.previewUrl, _this.previewUrl) || other.previewUrl == _this.previewUrl)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.locationId, _this.locationId) || other.locationId == _this.locationId)&&(identical(other.locationName, _this.locationName) || other.locationName == _this.locationName)&&(identical(other.roadAddress, _this.roadAddress) || other.roadAddress == _this.roadAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PollDetailItem;
  return Object.hash(runtimeType,_this.itemId,_this.voteCount,_this.isVoted,_this.content,_this.title,_this.artist,_this.previewUrl,_this.location,_this.locationId,_this.locationName,_this.roadAddress);
}

@override
String toString() {
  final _this = this as PollDetailItem;
  return 'PollDetailItem(itemId: ${_this.itemId}, voteCount: ${_this.voteCount}, isVoted: ${_this.isVoted}, content: ${_this.content}, title: ${_this.title}, artist: ${_this.artist}, previewUrl: ${_this.previewUrl}, location: ${_this.location}, locationId: ${_this.locationId}, locationName: ${_this.locationName}, roadAddress: ${_this.roadAddress})';
}


}

/// @nodoc
abstract mixin class $PollDetailItemCopyWith<$Res>  {
  factory $PollDetailItemCopyWith(PollDetailItem value, $Res Function(PollDetailItem) _then) = _$PollDetailItemCopyWithImpl;
@useResult
$Res call({
 int itemId, int voteCount,@JsonKey(name: 'voted') bool isVoted, String? content, String? title, String? artist, String? previewUrl, String? location, int? locationId, String? locationName, String? roadAddress
});




}
/// @nodoc
class _$PollDetailItemCopyWithImpl<$Res>
    implements $PollDetailItemCopyWith<$Res> {
  _$PollDetailItemCopyWithImpl(this._self, this._then);

  final PollDetailItem _self;
  final $Res Function(PollDetailItem) _then;

/// Create a copy of PollDetailItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? voteCount = null,Object? isVoted = null,Object? content = freezed,Object? title = freezed,Object? artist = freezed,Object? previewUrl = freezed,Object? location = freezed,Object? locationId = freezed,Object? locationName = freezed,Object? roadAddress = freezed,}) {
  return _then(PollDetailItem(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,isVoted: null == isVoted ? _self.isVoted : isVoted // ignore: cast_nullable_to_non_nullable
as bool,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,roadAddress: freezed == roadAddress ? _self.roadAddress : roadAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PollDetailItem].
extension PollDetailItemPatterns on PollDetailItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollDetailItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollDetailItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollDetailItem value)  $default,){
final _that = this;
switch (_that) {
case _PollDetailItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollDetailItem value)?  $default,){
final _that = this;
switch (_that) {
case _PollDetailItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int itemId,  int voteCount, @JsonKey(name: 'voted')  bool isVoted,  String? content,  String? title,  String? artist,  String? previewUrl,  String? location,  int? locationId,  String? locationName,  String? roadAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollDetailItem() when $default != null:
return $default(_that.itemId,_that.voteCount,_that.isVoted,_that.content,_that.title,_that.artist,_that.previewUrl,_that.location,_that.locationId,_that.locationName,_that.roadAddress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int itemId,  int voteCount, @JsonKey(name: 'voted')  bool isVoted,  String? content,  String? title,  String? artist,  String? previewUrl,  String? location,  int? locationId,  String? locationName,  String? roadAddress)  $default,) {final _that = this;
switch (_that) {
case _PollDetailItem():
return $default(_that.itemId,_that.voteCount,_that.isVoted,_that.content,_that.title,_that.artist,_that.previewUrl,_that.location,_that.locationId,_that.locationName,_that.roadAddress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int itemId,  int voteCount, @JsonKey(name: 'voted')  bool isVoted,  String? content,  String? title,  String? artist,  String? previewUrl,  String? location,  int? locationId,  String? locationName,  String? roadAddress)?  $default,) {final _that = this;
switch (_that) {
case _PollDetailItem() when $default != null:
return $default(_that.itemId,_that.voteCount,_that.isVoted,_that.content,_that.title,_that.artist,_that.previewUrl,_that.location,_that.locationId,_that.locationName,_that.roadAddress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollDetailItem implements PollDetailItem {
  const _PollDetailItem({required this.itemId, required this.voteCount, @JsonKey(name: 'voted') this.isVoted = false, this.content, this.title, this.artist, this.previewUrl, this.location, this.locationId, this.locationName, this.roadAddress});
  factory _PollDetailItem.fromJson(Map<String, dynamic> json) => _$PollDetailItemFromJson(json);

@override final  int itemId;
@override final  int voteCount;
@override@JsonKey(name: 'voted') final  bool isVoted;
@override final  String? content;
@override final  String? title;
@override final  String? artist;
@override final  String? previewUrl;
@override final  String? location;
@override final  int? locationId;
@override final  String? locationName;
@override final  String? roadAddress;

/// Create a copy of PollDetailItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollDetailItemCopyWith<_PollDetailItem> get copyWith => __$PollDetailItemCopyWithImpl<_PollDetailItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollDetailItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollDetailItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.voteCount, voteCount) || other.voteCount == voteCount)&&(identical(other.isVoted, isVoted) || other.isVoted == isVoted)&&(identical(other.content, content) || other.content == content)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl)&&(identical(other.location, location) || other.location == location)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.roadAddress, roadAddress) || other.roadAddress == roadAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemId,voteCount,isVoted,content,title,artist,previewUrl,location,locationId,locationName,roadAddress);
}

@override
String toString() {
    return 'PollDetailItem(itemId: $itemId, voteCount: $voteCount, isVoted: $isVoted, content: $content, title: $title, artist: $artist, previewUrl: $previewUrl, location: $location, locationId: $locationId, locationName: $locationName, roadAddress: $roadAddress)';
}


}

/// @nodoc
abstract mixin class _$PollDetailItemCopyWith<$Res> implements $PollDetailItemCopyWith<$Res> {
  factory _$PollDetailItemCopyWith(_PollDetailItem value, $Res Function(_PollDetailItem) _then) = __$PollDetailItemCopyWithImpl;
@override @useResult
$Res call({
 int itemId, int voteCount,@JsonKey(name: 'voted') bool isVoted, String? content, String? title, String? artist, String? previewUrl, String? location, int? locationId, String? locationName, String? roadAddress
});




}
/// @nodoc
class __$PollDetailItemCopyWithImpl<$Res>
    implements _$PollDetailItemCopyWith<$Res> {
  __$PollDetailItemCopyWithImpl(this._self, this._then);

  final _PollDetailItem _self;
  final $Res Function(_PollDetailItem) _then;

/// Create a copy of PollDetailItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? voteCount = null,Object? isVoted = null,Object? content = freezed,Object? title = freezed,Object? artist = freezed,Object? previewUrl = freezed,Object? location = freezed,Object? locationId = freezed,Object? locationName = freezed,Object? roadAddress = freezed,}) {
  return _then(_PollDetailItem(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,voteCount: null == voteCount ? _self.voteCount : voteCount // ignore: cast_nullable_to_non_nullable
as int,isVoted: null == isVoted ? _self.isVoted : isVoted // ignore: cast_nullable_to_non_nullable
as bool,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,roadAddress: freezed == roadAddress ? _self.roadAddress : roadAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PollCreateRequest {

 String get title; String? get content; String get pollType; List<PollCreateItem> get pollList; bool get allowMultipleChoice;@JsonKey(name: 'isAnonymous') bool get isAnonymous; bool get remindBeforeClose; DateTime? get closeAt;
/// Create a copy of PollCreateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollCreateRequestCopyWith<PollCreateRequest> get copyWith => _$PollCreateRequestCopyWithImpl<PollCreateRequest>(this as PollCreateRequest, _$identity);

  /// Serializes this PollCreateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PollCreateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollCreateRequest&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.pollType, _this.pollType) || other.pollType == _this.pollType)&&const DeepCollectionEquality().equals(other.pollList, _this.pollList)&&(identical(other.allowMultipleChoice, _this.allowMultipleChoice) || other.allowMultipleChoice == _this.allowMultipleChoice)&&(identical(other.isAnonymous, _this.isAnonymous) || other.isAnonymous == _this.isAnonymous)&&(identical(other.remindBeforeClose, _this.remindBeforeClose) || other.remindBeforeClose == _this.remindBeforeClose)&&(identical(other.closeAt, _this.closeAt) || other.closeAt == _this.closeAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PollCreateRequest;
  return Object.hash(runtimeType,_this.title,_this.content,_this.pollType,const DeepCollectionEquality().hash(_this.pollList),_this.allowMultipleChoice,_this.isAnonymous,_this.remindBeforeClose,_this.closeAt);
}

@override
String toString() {
  final _this = this as PollCreateRequest;
  return 'PollCreateRequest(title: ${_this.title}, content: ${_this.content}, pollType: ${_this.pollType}, pollList: ${_this.pollList}, allowMultipleChoice: ${_this.allowMultipleChoice}, isAnonymous: ${_this.isAnonymous}, remindBeforeClose: ${_this.remindBeforeClose}, closeAt: ${_this.closeAt})';
}


}

/// @nodoc
abstract mixin class $PollCreateRequestCopyWith<$Res>  {
  factory $PollCreateRequestCopyWith(PollCreateRequest value, $Res Function(PollCreateRequest) _then) = _$PollCreateRequestCopyWithImpl;
@useResult
$Res call({
 String title, String? content, String pollType, List<PollCreateItem> pollList, bool allowMultipleChoice,@JsonKey(name: 'isAnonymous') bool isAnonymous, bool remindBeforeClose, DateTime? closeAt
});




}
/// @nodoc
class _$PollCreateRequestCopyWithImpl<$Res>
    implements $PollCreateRequestCopyWith<$Res> {
  _$PollCreateRequestCopyWithImpl(this._self, this._then);

  final PollCreateRequest _self;
  final $Res Function(PollCreateRequest) _then;

/// Create a copy of PollCreateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? content = freezed,Object? pollType = null,Object? pollList = null,Object? allowMultipleChoice = null,Object? isAnonymous = null,Object? remindBeforeClose = null,Object? closeAt = freezed,}) {
  return _then(PollCreateRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,pollType: null == pollType ? _self.pollType : pollType // ignore: cast_nullable_to_non_nullable
as String,pollList: null == pollList ? _self.pollList : pollList // ignore: cast_nullable_to_non_nullable
as List<PollCreateItem>,allowMultipleChoice: null == allowMultipleChoice ? _self.allowMultipleChoice : allowMultipleChoice // ignore: cast_nullable_to_non_nullable
as bool,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,remindBeforeClose: null == remindBeforeClose ? _self.remindBeforeClose : remindBeforeClose // ignore: cast_nullable_to_non_nullable
as bool,closeAt: freezed == closeAt ? _self.closeAt : closeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PollCreateRequest].
extension PollCreateRequestPatterns on PollCreateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollCreateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollCreateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollCreateRequest value)  $default,){
final _that = this;
switch (_that) {
case _PollCreateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollCreateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PollCreateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? content,  String pollType,  List<PollCreateItem> pollList,  bool allowMultipleChoice, @JsonKey(name: 'isAnonymous')  bool isAnonymous,  bool remindBeforeClose,  DateTime? closeAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollCreateRequest() when $default != null:
return $default(_that.title,_that.content,_that.pollType,_that.pollList,_that.allowMultipleChoice,_that.isAnonymous,_that.remindBeforeClose,_that.closeAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? content,  String pollType,  List<PollCreateItem> pollList,  bool allowMultipleChoice, @JsonKey(name: 'isAnonymous')  bool isAnonymous,  bool remindBeforeClose,  DateTime? closeAt)  $default,) {final _that = this;
switch (_that) {
case _PollCreateRequest():
return $default(_that.title,_that.content,_that.pollType,_that.pollList,_that.allowMultipleChoice,_that.isAnonymous,_that.remindBeforeClose,_that.closeAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? content,  String pollType,  List<PollCreateItem> pollList,  bool allowMultipleChoice, @JsonKey(name: 'isAnonymous')  bool isAnonymous,  bool remindBeforeClose,  DateTime? closeAt)?  $default,) {final _that = this;
switch (_that) {
case _PollCreateRequest() when $default != null:
return $default(_that.title,_that.content,_that.pollType,_that.pollList,_that.allowMultipleChoice,_that.isAnonymous,_that.remindBeforeClose,_that.closeAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollCreateRequest implements PollCreateRequest {
  const _PollCreateRequest({required this.title, this.content, required this.pollType, required  List<PollCreateItem> pollList, required this.allowMultipleChoice, @JsonKey(name: 'isAnonymous') required this.isAnonymous, required this.remindBeforeClose, this.closeAt}): _pollList = pollList;
  factory _PollCreateRequest.fromJson(Map<String, dynamic> json) => _$PollCreateRequestFromJson(json);

@override final  String title;
@override final  String? content;
@override final  String pollType;
 final  List<PollCreateItem> _pollList;
@override List<PollCreateItem> get pollList {
  if (_pollList is EqualUnmodifiableListView) return _pollList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pollList);
}

@override final  bool allowMultipleChoice;
@override@JsonKey(name: 'isAnonymous') final  bool isAnonymous;
@override final  bool remindBeforeClose;
@override final  DateTime? closeAt;

/// Create a copy of PollCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollCreateRequestCopyWith<_PollCreateRequest> get copyWith => __$PollCreateRequestCopyWithImpl<_PollCreateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollCreateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollCreateRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.pollType, pollType) || other.pollType == pollType)&&const DeepCollectionEquality().equals(other.pollList, _pollList)&&(identical(other.allowMultipleChoice, allowMultipleChoice) || other.allowMultipleChoice == allowMultipleChoice)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.remindBeforeClose, remindBeforeClose) || other.remindBeforeClose == remindBeforeClose)&&(identical(other.closeAt, closeAt) || other.closeAt == closeAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,content,pollType,const DeepCollectionEquality().hash(_pollList),allowMultipleChoice,isAnonymous,remindBeforeClose,closeAt);
}

@override
String toString() {
    return 'PollCreateRequest(title: $title, content: $content, pollType: $pollType, pollList: $pollList, allowMultipleChoice: $allowMultipleChoice, isAnonymous: $isAnonymous, remindBeforeClose: $remindBeforeClose, closeAt: $closeAt)';
}


}

/// @nodoc
abstract mixin class _$PollCreateRequestCopyWith<$Res> implements $PollCreateRequestCopyWith<$Res> {
  factory _$PollCreateRequestCopyWith(_PollCreateRequest value, $Res Function(_PollCreateRequest) _then) = __$PollCreateRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String? content, String pollType, List<PollCreateItem> pollList, bool allowMultipleChoice,@JsonKey(name: 'isAnonymous') bool isAnonymous, bool remindBeforeClose, DateTime? closeAt
});




}
/// @nodoc
class __$PollCreateRequestCopyWithImpl<$Res>
    implements _$PollCreateRequestCopyWith<$Res> {
  __$PollCreateRequestCopyWithImpl(this._self, this._then);

  final _PollCreateRequest _self;
  final $Res Function(_PollCreateRequest) _then;

/// Create a copy of PollCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? content = freezed,Object? pollType = null,Object? pollList = null,Object? allowMultipleChoice = null,Object? isAnonymous = null,Object? remindBeforeClose = null,Object? closeAt = freezed,}) {
  return _then(_PollCreateRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,pollType: null == pollType ? _self.pollType : pollType // ignore: cast_nullable_to_non_nullable
as String,pollList: null == pollList ? _self._pollList : pollList // ignore: cast_nullable_to_non_nullable
as List<PollCreateItem>,allowMultipleChoice: null == allowMultipleChoice ? _self.allowMultipleChoice : allowMultipleChoice // ignore: cast_nullable_to_non_nullable
as bool,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,remindBeforeClose: null == remindBeforeClose ? _self.remindBeforeClose : remindBeforeClose // ignore: cast_nullable_to_non_nullable
as bool,closeAt: freezed == closeAt ? _self.closeAt : closeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PollCreateItem {

 String? get content; PollCreateMusic? get music; String? get location; int? get locationId;
/// Create a copy of PollCreateItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollCreateItemCopyWith<PollCreateItem> get copyWith => _$PollCreateItemCopyWithImpl<PollCreateItem>(this as PollCreateItem, _$identity);

  /// Serializes this PollCreateItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PollCreateItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollCreateItem&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.music, _this.music) || other.music == _this.music)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.locationId, _this.locationId) || other.locationId == _this.locationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PollCreateItem;
  return Object.hash(runtimeType,_this.content,_this.music,_this.location,_this.locationId);
}

@override
String toString() {
  final _this = this as PollCreateItem;
  return 'PollCreateItem(content: ${_this.content}, music: ${_this.music}, location: ${_this.location}, locationId: ${_this.locationId})';
}


}

/// @nodoc
abstract mixin class $PollCreateItemCopyWith<$Res>  {
  factory $PollCreateItemCopyWith(PollCreateItem value, $Res Function(PollCreateItem) _then) = _$PollCreateItemCopyWithImpl;
@useResult
$Res call({
 String? content, PollCreateMusic? music, String? location, int? locationId
});


$PollCreateMusicCopyWith<$Res>? get music;

}
/// @nodoc
class _$PollCreateItemCopyWithImpl<$Res>
    implements $PollCreateItemCopyWith<$Res> {
  _$PollCreateItemCopyWithImpl(this._self, this._then);

  final PollCreateItem _self;
  final $Res Function(PollCreateItem) _then;

/// Create a copy of PollCreateItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? music = freezed,Object? location = freezed,Object? locationId = freezed,}) {
  return _then(PollCreateItem(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,music: freezed == music ? _self.music : music // ignore: cast_nullable_to_non_nullable
as PollCreateMusic?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of PollCreateItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PollCreateMusicCopyWith<$Res>? get music {
    if (_self.music == null) {
    return null;
  }

  return $PollCreateMusicCopyWith<$Res>(_self.music!, (value) {
    return _then(_self.copyWith(music: value));
  });
}
}


/// Adds pattern-matching-related methods to [PollCreateItem].
extension PollCreateItemPatterns on PollCreateItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollCreateItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollCreateItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollCreateItem value)  $default,){
final _that = this;
switch (_that) {
case _PollCreateItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollCreateItem value)?  $default,){
final _that = this;
switch (_that) {
case _PollCreateItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? content,  PollCreateMusic? music,  String? location,  int? locationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollCreateItem() when $default != null:
return $default(_that.content,_that.music,_that.location,_that.locationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? content,  PollCreateMusic? music,  String? location,  int? locationId)  $default,) {final _that = this;
switch (_that) {
case _PollCreateItem():
return $default(_that.content,_that.music,_that.location,_that.locationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? content,  PollCreateMusic? music,  String? location,  int? locationId)?  $default,) {final _that = this;
switch (_that) {
case _PollCreateItem() when $default != null:
return $default(_that.content,_that.music,_that.location,_that.locationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollCreateItem implements PollCreateItem {
  const _PollCreateItem({this.content, this.music, this.location, this.locationId});
  factory _PollCreateItem.fromJson(Map<String, dynamic> json) => _$PollCreateItemFromJson(json);

@override final  String? content;
@override final  PollCreateMusic? music;
@override final  String? location;
@override final  int? locationId;

/// Create a copy of PollCreateItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollCreateItemCopyWith<_PollCreateItem> get copyWith => __$PollCreateItemCopyWithImpl<_PollCreateItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollCreateItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollCreateItem&&(identical(other.content, content) || other.content == content)&&(identical(other.music, music) || other.music == music)&&(identical(other.location, location) || other.location == location)&&(identical(other.locationId, locationId) || other.locationId == locationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,content,music,location,locationId);
}

@override
String toString() {
    return 'PollCreateItem(content: $content, music: $music, location: $location, locationId: $locationId)';
}


}

/// @nodoc
abstract mixin class _$PollCreateItemCopyWith<$Res> implements $PollCreateItemCopyWith<$Res> {
  factory _$PollCreateItemCopyWith(_PollCreateItem value, $Res Function(_PollCreateItem) _then) = __$PollCreateItemCopyWithImpl;
@override @useResult
$Res call({
 String? content, PollCreateMusic? music, String? location, int? locationId
});


@override $PollCreateMusicCopyWith<$Res>? get music;

}
/// @nodoc
class __$PollCreateItemCopyWithImpl<$Res>
    implements _$PollCreateItemCopyWith<$Res> {
  __$PollCreateItemCopyWithImpl(this._self, this._then);

  final _PollCreateItem _self;
  final $Res Function(_PollCreateItem) _then;

/// Create a copy of PollCreateItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? music = freezed,Object? location = freezed,Object? locationId = freezed,}) {
  return _then(_PollCreateItem(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,music: freezed == music ? _self.music : music // ignore: cast_nullable_to_non_nullable
as PollCreateMusic?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of PollCreateItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PollCreateMusicCopyWith<$Res>? get music {
    if (_self.music == null) {
    return null;
  }

  return $PollCreateMusicCopyWith<$Res>(_self.music!, (value) {
    return _then(_self.copyWith(music: value));
  });
}
}


/// @nodoc
mixin _$PollCreateMusic {

 String get title; String get artist; String? get previewUrl;
/// Create a copy of PollCreateMusic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollCreateMusicCopyWith<PollCreateMusic> get copyWith => _$PollCreateMusicCopyWithImpl<PollCreateMusic>(this as PollCreateMusic, _$identity);

  /// Serializes this PollCreateMusic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PollCreateMusic;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollCreateMusic&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.artist, _this.artist) || other.artist == _this.artist)&&(identical(other.previewUrl, _this.previewUrl) || other.previewUrl == _this.previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PollCreateMusic;
  return Object.hash(runtimeType,_this.title,_this.artist,_this.previewUrl);
}

@override
String toString() {
  final _this = this as PollCreateMusic;
  return 'PollCreateMusic(title: ${_this.title}, artist: ${_this.artist}, previewUrl: ${_this.previewUrl})';
}


}

/// @nodoc
abstract mixin class $PollCreateMusicCopyWith<$Res>  {
  factory $PollCreateMusicCopyWith(PollCreateMusic value, $Res Function(PollCreateMusic) _then) = _$PollCreateMusicCopyWithImpl;
@useResult
$Res call({
 String title, String artist, String? previewUrl
});




}
/// @nodoc
class _$PollCreateMusicCopyWithImpl<$Res>
    implements $PollCreateMusicCopyWith<$Res> {
  _$PollCreateMusicCopyWithImpl(this._self, this._then);

  final PollCreateMusic _self;
  final $Res Function(PollCreateMusic) _then;

/// Create a copy of PollCreateMusic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? artist = null,Object? previewUrl = freezed,}) {
  return _then(PollCreateMusic(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PollCreateMusic].
extension PollCreateMusicPatterns on PollCreateMusic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollCreateMusic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollCreateMusic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollCreateMusic value)  $default,){
final _that = this;
switch (_that) {
case _PollCreateMusic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollCreateMusic value)?  $default,){
final _that = this;
switch (_that) {
case _PollCreateMusic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String artist,  String? previewUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollCreateMusic() when $default != null:
return $default(_that.title,_that.artist,_that.previewUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String artist,  String? previewUrl)  $default,) {final _that = this;
switch (_that) {
case _PollCreateMusic():
return $default(_that.title,_that.artist,_that.previewUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String artist,  String? previewUrl)?  $default,) {final _that = this;
switch (_that) {
case _PollCreateMusic() when $default != null:
return $default(_that.title,_that.artist,_that.previewUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollCreateMusic implements PollCreateMusic {
  const _PollCreateMusic({required this.title, required this.artist, this.previewUrl});
  factory _PollCreateMusic.fromJson(Map<String, dynamic> json) => _$PollCreateMusicFromJson(json);

@override final  String title;
@override final  String artist;
@override final  String? previewUrl;

/// Create a copy of PollCreateMusic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollCreateMusicCopyWith<_PollCreateMusic> get copyWith => __$PollCreateMusicCopyWithImpl<_PollCreateMusic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollCreateMusicToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollCreateMusic&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,artist,previewUrl);
}

@override
String toString() {
    return 'PollCreateMusic(title: $title, artist: $artist, previewUrl: $previewUrl)';
}


}

/// @nodoc
abstract mixin class _$PollCreateMusicCopyWith<$Res> implements $PollCreateMusicCopyWith<$Res> {
  factory _$PollCreateMusicCopyWith(_PollCreateMusic value, $Res Function(_PollCreateMusic) _then) = __$PollCreateMusicCopyWithImpl;
@override @useResult
$Res call({
 String title, String artist, String? previewUrl
});




}
/// @nodoc
class __$PollCreateMusicCopyWithImpl<$Res>
    implements _$PollCreateMusicCopyWith<$Res> {
  __$PollCreateMusicCopyWithImpl(this._self, this._then);

  final _PollCreateMusic _self;
  final $Res Function(_PollCreateMusic) _then;

/// Create a copy of PollCreateMusic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? artist = null,Object? previewUrl = freezed,}) {
  return _then(_PollCreateMusic(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
