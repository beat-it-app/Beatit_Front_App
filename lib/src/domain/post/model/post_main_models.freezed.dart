// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_main_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoticeListResponse {

 bool get success; int get status; String get message; NoticeListData get data;
/// Create a copy of NoticeListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeListResponseCopyWith<NoticeListResponse> get copyWith => _$NoticeListResponseCopyWithImpl<NoticeListResponse>(this as NoticeListResponse, _$identity);

  /// Serializes this NoticeListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NoticeListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticeListResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NoticeListResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as NoticeListResponse;
  return 'NoticeListResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $NoticeListResponseCopyWith<$Res>  {
  factory $NoticeListResponseCopyWith(NoticeListResponse value, $Res Function(NoticeListResponse) _then) = _$NoticeListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, NoticeListData data
});


$NoticeListDataCopyWith<$Res> get data;

}
/// @nodoc
class _$NoticeListResponseCopyWithImpl<$Res>
    implements $NoticeListResponseCopyWith<$Res> {
  _$NoticeListResponseCopyWithImpl(this._self, this._then);

  final NoticeListResponse _self;
  final $Res Function(NoticeListResponse) _then;

/// Create a copy of NoticeListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(NoticeListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NoticeListData,
  ));
}
/// Create a copy of NoticeListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoticeListDataCopyWith<$Res> get data {
  
  return $NoticeListDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [NoticeListResponse].
extension NoticeListResponsePatterns on NoticeListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoticeListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoticeListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoticeListResponse value)  $default,){
final _that = this;
switch (_that) {
case _NoticeListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoticeListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NoticeListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  NoticeListData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoticeListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  NoticeListData data)  $default,) {final _that = this;
switch (_that) {
case _NoticeListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  NoticeListData data)?  $default,) {final _that = this;
switch (_that) {
case _NoticeListResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoticeListResponse implements NoticeListResponse {
  const _NoticeListResponse({required this.success, required this.status, required this.message, required this.data});
  factory _NoticeListResponse.fromJson(Map<String, dynamic> json) => _$NoticeListResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  NoticeListData data;

/// Create a copy of NoticeListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeListResponseCopyWith<_NoticeListResponse> get copyWith => __$NoticeListResponseCopyWithImpl<_NoticeListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticeListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'NoticeListResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$NoticeListResponseCopyWith<$Res> implements $NoticeListResponseCopyWith<$Res> {
  factory _$NoticeListResponseCopyWith(_NoticeListResponse value, $Res Function(_NoticeListResponse) _then) = __$NoticeListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, NoticeListData data
});


@override $NoticeListDataCopyWith<$Res> get data;

}
/// @nodoc
class __$NoticeListResponseCopyWithImpl<$Res>
    implements _$NoticeListResponseCopyWith<$Res> {
  __$NoticeListResponseCopyWithImpl(this._self, this._then);

  final _NoticeListResponse _self;
  final $Res Function(_NoticeListResponse) _then;

/// Create a copy of NoticeListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_NoticeListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NoticeListData,
  ));
}

/// Create a copy of NoticeListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoticeListDataCopyWith<$Res> get data {
  
  return $NoticeListDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$NoticeListData {

 List<NoticeListItem> get noticeListResponse; int get totalCount; bool get hasNext;
/// Create a copy of NoticeListData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeListDataCopyWith<NoticeListData> get copyWith => _$NoticeListDataCopyWithImpl<NoticeListData>(this as NoticeListData, _$identity);

  /// Serializes this NoticeListData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NoticeListData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticeListData&&const DeepCollectionEquality().equals(other.noticeListResponse, _this.noticeListResponse)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.hasNext, _this.hasNext) || other.hasNext == _this.hasNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NoticeListData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.noticeListResponse),_this.totalCount,_this.hasNext);
}

@override
String toString() {
  final _this = this as NoticeListData;
  return 'NoticeListData(noticeListResponse: ${_this.noticeListResponse}, totalCount: ${_this.totalCount}, hasNext: ${_this.hasNext})';
}


}

/// @nodoc
abstract mixin class $NoticeListDataCopyWith<$Res>  {
  factory $NoticeListDataCopyWith(NoticeListData value, $Res Function(NoticeListData) _then) = _$NoticeListDataCopyWithImpl;
@useResult
$Res call({
 List<NoticeListItem> noticeListResponse, int totalCount, bool hasNext
});




}
/// @nodoc
class _$NoticeListDataCopyWithImpl<$Res>
    implements $NoticeListDataCopyWith<$Res> {
  _$NoticeListDataCopyWithImpl(this._self, this._then);

  final NoticeListData _self;
  final $Res Function(NoticeListData) _then;

/// Create a copy of NoticeListData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noticeListResponse = null,Object? totalCount = null,Object? hasNext = null,}) {
  return _then(NoticeListData(
noticeListResponse: null == noticeListResponse ? _self.noticeListResponse : noticeListResponse // ignore: cast_nullable_to_non_nullable
as List<NoticeListItem>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NoticeListData].
extension NoticeListDataPatterns on NoticeListData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoticeListData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoticeListData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoticeListData value)  $default,){
final _that = this;
switch (_that) {
case _NoticeListData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoticeListData value)?  $default,){
final _that = this;
switch (_that) {
case _NoticeListData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NoticeListItem> noticeListResponse,  int totalCount,  bool hasNext)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoticeListData() when $default != null:
return $default(_that.noticeListResponse,_that.totalCount,_that.hasNext);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NoticeListItem> noticeListResponse,  int totalCount,  bool hasNext)  $default,) {final _that = this;
switch (_that) {
case _NoticeListData():
return $default(_that.noticeListResponse,_that.totalCount,_that.hasNext);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NoticeListItem> noticeListResponse,  int totalCount,  bool hasNext)?  $default,) {final _that = this;
switch (_that) {
case _NoticeListData() when $default != null:
return $default(_that.noticeListResponse,_that.totalCount,_that.hasNext);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoticeListData implements NoticeListData {
  const _NoticeListData({ List<NoticeListItem> noticeListResponse = const <NoticeListItem>[], required this.totalCount, required this.hasNext}): _noticeListResponse = noticeListResponse;
  factory _NoticeListData.fromJson(Map<String, dynamic> json) => _$NoticeListDataFromJson(json);

 final  List<NoticeListItem> _noticeListResponse;
@override@JsonKey() List<NoticeListItem> get noticeListResponse {
  if (_noticeListResponse is EqualUnmodifiableListView) return _noticeListResponse;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_noticeListResponse);
}

@override final  int totalCount;
@override final  bool hasNext;

/// Create a copy of NoticeListData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeListDataCopyWith<_NoticeListData> get copyWith => __$NoticeListDataCopyWithImpl<_NoticeListData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeListDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticeListData&&const DeepCollectionEquality().equals(other.noticeListResponse, _noticeListResponse)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_noticeListResponse),totalCount,hasNext);
}

@override
String toString() {
    return 'NoticeListData(noticeListResponse: $noticeListResponse, totalCount: $totalCount, hasNext: $hasNext)';
}


}

/// @nodoc
abstract mixin class _$NoticeListDataCopyWith<$Res> implements $NoticeListDataCopyWith<$Res> {
  factory _$NoticeListDataCopyWith(_NoticeListData value, $Res Function(_NoticeListData) _then) = __$NoticeListDataCopyWithImpl;
@override @useResult
$Res call({
 List<NoticeListItem> noticeListResponse, int totalCount, bool hasNext
});




}
/// @nodoc
class __$NoticeListDataCopyWithImpl<$Res>
    implements _$NoticeListDataCopyWith<$Res> {
  __$NoticeListDataCopyWithImpl(this._self, this._then);

  final _NoticeListData _self;
  final $Res Function(_NoticeListData) _then;

/// Create a copy of NoticeListData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noticeListResponse = null,Object? totalCount = null,Object? hasNext = null,}) {
  return _then(_NoticeListData(
noticeListResponse: null == noticeListResponse ? _self._noticeListResponse : noticeListResponse // ignore: cast_nullable_to_non_nullable
as List<NoticeListItem>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$NoticeListItem {

 int get noticeId; String get title; String get description; int get likeCount; int get dislikeCount; int get commentCount; DateTime get createdAt; String get writer; String? get thumbnailUrl;
/// Create a copy of NoticeListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeListItemCopyWith<NoticeListItem> get copyWith => _$NoticeListItemCopyWithImpl<NoticeListItem>(this as NoticeListItem, _$identity);

  /// Serializes this NoticeListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NoticeListItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoticeListItem&&(identical(other.noticeId, _this.noticeId) || other.noticeId == _this.noticeId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.likeCount, _this.likeCount) || other.likeCount == _this.likeCount)&&(identical(other.dislikeCount, _this.dislikeCount) || other.dislikeCount == _this.dislikeCount)&&(identical(other.commentCount, _this.commentCount) || other.commentCount == _this.commentCount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.writer, _this.writer) || other.writer == _this.writer)&&(identical(other.thumbnailUrl, _this.thumbnailUrl) || other.thumbnailUrl == _this.thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NoticeListItem;
  return Object.hash(runtimeType,_this.noticeId,_this.title,_this.description,_this.likeCount,_this.dislikeCount,_this.commentCount,_this.createdAt,_this.writer,_this.thumbnailUrl);
}

@override
String toString() {
  final _this = this as NoticeListItem;
  return 'NoticeListItem(noticeId: ${_this.noticeId}, title: ${_this.title}, description: ${_this.description}, likeCount: ${_this.likeCount}, dislikeCount: ${_this.dislikeCount}, commentCount: ${_this.commentCount}, createdAt: ${_this.createdAt}, writer: ${_this.writer}, thumbnailUrl: ${_this.thumbnailUrl})';
}


}

/// @nodoc
abstract mixin class $NoticeListItemCopyWith<$Res>  {
  factory $NoticeListItemCopyWith(NoticeListItem value, $Res Function(NoticeListItem) _then) = _$NoticeListItemCopyWithImpl;
@useResult
$Res call({
 int noticeId, String title, String description, int likeCount, int dislikeCount, int commentCount, DateTime createdAt, String writer, String? thumbnailUrl
});




}
/// @nodoc
class _$NoticeListItemCopyWithImpl<$Res>
    implements $NoticeListItemCopyWith<$Res> {
  _$NoticeListItemCopyWithImpl(this._self, this._then);

  final NoticeListItem _self;
  final $Res Function(NoticeListItem) _then;

/// Create a copy of NoticeListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noticeId = null,Object? title = null,Object? description = null,Object? likeCount = null,Object? dislikeCount = null,Object? commentCount = null,Object? createdAt = null,Object? writer = null,Object? thumbnailUrl = freezed,}) {
  return _then(NoticeListItem(
noticeId: null == noticeId ? _self.noticeId : noticeId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,dislikeCount: null == dislikeCount ? _self.dislikeCount : dislikeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,writer: null == writer ? _self.writer : writer // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NoticeListItem].
extension NoticeListItemPatterns on NoticeListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoticeListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoticeListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoticeListItem value)  $default,){
final _that = this;
switch (_that) {
case _NoticeListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoticeListItem value)?  $default,){
final _that = this;
switch (_that) {
case _NoticeListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int noticeId,  String title,  String description,  int likeCount,  int dislikeCount,  int commentCount,  DateTime createdAt,  String writer,  String? thumbnailUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoticeListItem() when $default != null:
return $default(_that.noticeId,_that.title,_that.description,_that.likeCount,_that.dislikeCount,_that.commentCount,_that.createdAt,_that.writer,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int noticeId,  String title,  String description,  int likeCount,  int dislikeCount,  int commentCount,  DateTime createdAt,  String writer,  String? thumbnailUrl)  $default,) {final _that = this;
switch (_that) {
case _NoticeListItem():
return $default(_that.noticeId,_that.title,_that.description,_that.likeCount,_that.dislikeCount,_that.commentCount,_that.createdAt,_that.writer,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int noticeId,  String title,  String description,  int likeCount,  int dislikeCount,  int commentCount,  DateTime createdAt,  String writer,  String? thumbnailUrl)?  $default,) {final _that = this;
switch (_that) {
case _NoticeListItem() when $default != null:
return $default(_that.noticeId,_that.title,_that.description,_that.likeCount,_that.dislikeCount,_that.commentCount,_that.createdAt,_that.writer,_that.thumbnailUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoticeListItem implements NoticeListItem {
  const _NoticeListItem({required this.noticeId, required this.title, required this.description, required this.likeCount, required this.dislikeCount, required this.commentCount, required this.createdAt, required this.writer, this.thumbnailUrl});
  factory _NoticeListItem.fromJson(Map<String, dynamic> json) => _$NoticeListItemFromJson(json);

@override final  int noticeId;
@override final  String title;
@override final  String description;
@override final  int likeCount;
@override final  int dislikeCount;
@override final  int commentCount;
@override final  DateTime createdAt;
@override final  String writer;
@override final  String? thumbnailUrl;

/// Create a copy of NoticeListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeListItemCopyWith<_NoticeListItem> get copyWith => __$NoticeListItemCopyWithImpl<_NoticeListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeListItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoticeListItem&&(identical(other.noticeId, noticeId) || other.noticeId == noticeId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.dislikeCount, dislikeCount) || other.dislikeCount == dislikeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.writer, writer) || other.writer == writer)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,noticeId,title,description,likeCount,dislikeCount,commentCount,createdAt,writer,thumbnailUrl);
}

@override
String toString() {
    return 'NoticeListItem(noticeId: $noticeId, title: $title, description: $description, likeCount: $likeCount, dislikeCount: $dislikeCount, commentCount: $commentCount, createdAt: $createdAt, writer: $writer, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$NoticeListItemCopyWith<$Res> implements $NoticeListItemCopyWith<$Res> {
  factory _$NoticeListItemCopyWith(_NoticeListItem value, $Res Function(_NoticeListItem) _then) = __$NoticeListItemCopyWithImpl;
@override @useResult
$Res call({
 int noticeId, String title, String description, int likeCount, int dislikeCount, int commentCount, DateTime createdAt, String writer, String? thumbnailUrl
});




}
/// @nodoc
class __$NoticeListItemCopyWithImpl<$Res>
    implements _$NoticeListItemCopyWith<$Res> {
  __$NoticeListItemCopyWithImpl(this._self, this._then);

  final _NoticeListItem _self;
  final $Res Function(_NoticeListItem) _then;

/// Create a copy of NoticeListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noticeId = null,Object? title = null,Object? description = null,Object? likeCount = null,Object? dislikeCount = null,Object? commentCount = null,Object? createdAt = null,Object? writer = null,Object? thumbnailUrl = freezed,}) {
  return _then(_NoticeListItem(
noticeId: null == noticeId ? _self.noticeId : noticeId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,dislikeCount: null == dislikeCount ? _self.dislikeCount : dislikeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,writer: null == writer ? _self.writer : writer // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PollListResponse {

 bool get success; int get status; String get message; PollListData get data;
/// Create a copy of PollListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollListResponseCopyWith<PollListResponse> get copyWith => _$PollListResponseCopyWithImpl<PollListResponse>(this as PollListResponse, _$identity);

  /// Serializes this PollListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PollListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollListResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PollListResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as PollListResponse;
  return 'PollListResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $PollListResponseCopyWith<$Res>  {
  factory $PollListResponseCopyWith(PollListResponse value, $Res Function(PollListResponse) _then) = _$PollListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, PollListData data
});


$PollListDataCopyWith<$Res> get data;

}
/// @nodoc
class _$PollListResponseCopyWithImpl<$Res>
    implements $PollListResponseCopyWith<$Res> {
  _$PollListResponseCopyWithImpl(this._self, this._then);

  final PollListResponse _self;
  final $Res Function(PollListResponse) _then;

/// Create a copy of PollListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(PollListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PollListData,
  ));
}
/// Create a copy of PollListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PollListDataCopyWith<$Res> get data {
  
  return $PollListDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [PollListResponse].
extension PollListResponsePatterns on PollListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollListResponse value)  $default,){
final _that = this;
switch (_that) {
case _PollListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PollListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  PollListData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  PollListData data)  $default,) {final _that = this;
switch (_that) {
case _PollListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  PollListData data)?  $default,) {final _that = this;
switch (_that) {
case _PollListResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollListResponse implements PollListResponse {
  const _PollListResponse({required this.success, required this.status, required this.message, required this.data});
  factory _PollListResponse.fromJson(Map<String, dynamic> json) => _$PollListResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  PollListData data;

/// Create a copy of PollListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollListResponseCopyWith<_PollListResponse> get copyWith => __$PollListResponseCopyWithImpl<_PollListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'PollListResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$PollListResponseCopyWith<$Res> implements $PollListResponseCopyWith<$Res> {
  factory _$PollListResponseCopyWith(_PollListResponse value, $Res Function(_PollListResponse) _then) = __$PollListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, PollListData data
});


@override $PollListDataCopyWith<$Res> get data;

}
/// @nodoc
class __$PollListResponseCopyWithImpl<$Res>
    implements _$PollListResponseCopyWith<$Res> {
  __$PollListResponseCopyWithImpl(this._self, this._then);

  final _PollListResponse _self;
  final $Res Function(_PollListResponse) _then;

/// Create a copy of PollListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_PollListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PollListData,
  ));
}

/// Create a copy of PollListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PollListDataCopyWith<$Res> get data {
  
  return $PollListDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$PollListData {

 List<PollListItem> get pollListInProgress; List<PollListItem> get pollListClosed; int get totalCount; bool get hasNext;
/// Create a copy of PollListData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollListDataCopyWith<PollListData> get copyWith => _$PollListDataCopyWithImpl<PollListData>(this as PollListData, _$identity);

  /// Serializes this PollListData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PollListData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollListData&&const DeepCollectionEquality().equals(other.pollListInProgress, _this.pollListInProgress)&&const DeepCollectionEquality().equals(other.pollListClosed, _this.pollListClosed)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.hasNext, _this.hasNext) || other.hasNext == _this.hasNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PollListData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.pollListInProgress),const DeepCollectionEquality().hash(_this.pollListClosed),_this.totalCount,_this.hasNext);
}

@override
String toString() {
  final _this = this as PollListData;
  return 'PollListData(pollListInProgress: ${_this.pollListInProgress}, pollListClosed: ${_this.pollListClosed}, totalCount: ${_this.totalCount}, hasNext: ${_this.hasNext})';
}


}

/// @nodoc
abstract mixin class $PollListDataCopyWith<$Res>  {
  factory $PollListDataCopyWith(PollListData value, $Res Function(PollListData) _then) = _$PollListDataCopyWithImpl;
@useResult
$Res call({
 List<PollListItem> pollListInProgress, List<PollListItem> pollListClosed, int totalCount, bool hasNext
});




}
/// @nodoc
class _$PollListDataCopyWithImpl<$Res>
    implements $PollListDataCopyWith<$Res> {
  _$PollListDataCopyWithImpl(this._self, this._then);

  final PollListData _self;
  final $Res Function(PollListData) _then;

/// Create a copy of PollListData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pollListInProgress = null,Object? pollListClosed = null,Object? totalCount = null,Object? hasNext = null,}) {
  return _then(PollListData(
pollListInProgress: null == pollListInProgress ? _self.pollListInProgress : pollListInProgress // ignore: cast_nullable_to_non_nullable
as List<PollListItem>,pollListClosed: null == pollListClosed ? _self.pollListClosed : pollListClosed // ignore: cast_nullable_to_non_nullable
as List<PollListItem>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PollListData].
extension PollListDataPatterns on PollListData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollListData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollListData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollListData value)  $default,){
final _that = this;
switch (_that) {
case _PollListData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollListData value)?  $default,){
final _that = this;
switch (_that) {
case _PollListData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PollListItem> pollListInProgress,  List<PollListItem> pollListClosed,  int totalCount,  bool hasNext)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollListData() when $default != null:
return $default(_that.pollListInProgress,_that.pollListClosed,_that.totalCount,_that.hasNext);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PollListItem> pollListInProgress,  List<PollListItem> pollListClosed,  int totalCount,  bool hasNext)  $default,) {final _that = this;
switch (_that) {
case _PollListData():
return $default(_that.pollListInProgress,_that.pollListClosed,_that.totalCount,_that.hasNext);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PollListItem> pollListInProgress,  List<PollListItem> pollListClosed,  int totalCount,  bool hasNext)?  $default,) {final _that = this;
switch (_that) {
case _PollListData() when $default != null:
return $default(_that.pollListInProgress,_that.pollListClosed,_that.totalCount,_that.hasNext);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollListData implements PollListData {
  const _PollListData({ List<PollListItem> pollListInProgress = const <PollListItem>[],  List<PollListItem> pollListClosed = const <PollListItem>[], required this.totalCount, required this.hasNext}): _pollListInProgress = pollListInProgress,_pollListClosed = pollListClosed;
  factory _PollListData.fromJson(Map<String, dynamic> json) => _$PollListDataFromJson(json);

 final  List<PollListItem> _pollListInProgress;
@override@JsonKey() List<PollListItem> get pollListInProgress {
  if (_pollListInProgress is EqualUnmodifiableListView) return _pollListInProgress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pollListInProgress);
}

 final  List<PollListItem> _pollListClosed;
@override@JsonKey() List<PollListItem> get pollListClosed {
  if (_pollListClosed is EqualUnmodifiableListView) return _pollListClosed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pollListClosed);
}

@override final  int totalCount;
@override final  bool hasNext;

/// Create a copy of PollListData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollListDataCopyWith<_PollListData> get copyWith => __$PollListDataCopyWithImpl<_PollListData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollListDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollListData&&const DeepCollectionEquality().equals(other.pollListInProgress, _pollListInProgress)&&const DeepCollectionEquality().equals(other.pollListClosed, _pollListClosed)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_pollListInProgress),const DeepCollectionEquality().hash(_pollListClosed),totalCount,hasNext);
}

@override
String toString() {
    return 'PollListData(pollListInProgress: $pollListInProgress, pollListClosed: $pollListClosed, totalCount: $totalCount, hasNext: $hasNext)';
}


}

/// @nodoc
abstract mixin class _$PollListDataCopyWith<$Res> implements $PollListDataCopyWith<$Res> {
  factory _$PollListDataCopyWith(_PollListData value, $Res Function(_PollListData) _then) = __$PollListDataCopyWithImpl;
@override @useResult
$Res call({
 List<PollListItem> pollListInProgress, List<PollListItem> pollListClosed, int totalCount, bool hasNext
});




}
/// @nodoc
class __$PollListDataCopyWithImpl<$Res>
    implements _$PollListDataCopyWith<$Res> {
  __$PollListDataCopyWithImpl(this._self, this._then);

  final _PollListData _self;
  final $Res Function(_PollListData) _then;

/// Create a copy of PollListData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pollListInProgress = null,Object? pollListClosed = null,Object? totalCount = null,Object? hasNext = null,}) {
  return _then(_PollListData(
pollListInProgress: null == pollListInProgress ? _self._pollListInProgress : pollListInProgress // ignore: cast_nullable_to_non_nullable
as List<PollListItem>,pollListClosed: null == pollListClosed ? _self._pollListClosed : pollListClosed // ignore: cast_nullable_to_non_nullable
as List<PollListItem>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PollListItem {

 int get pollId; String get title; DateTime? get closeAt; int get pollCount;@JsonKey(name: 'voted') bool get isVoted;
/// Create a copy of PollListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollListItemCopyWith<PollListItem> get copyWith => _$PollListItemCopyWithImpl<PollListItem>(this as PollListItem, _$identity);

  /// Serializes this PollListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PollListItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollListItem&&(identical(other.pollId, _this.pollId) || other.pollId == _this.pollId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.closeAt, _this.closeAt) || other.closeAt == _this.closeAt)&&(identical(other.pollCount, _this.pollCount) || other.pollCount == _this.pollCount)&&(identical(other.isVoted, _this.isVoted) || other.isVoted == _this.isVoted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PollListItem;
  return Object.hash(runtimeType,_this.pollId,_this.title,_this.closeAt,_this.pollCount,_this.isVoted);
}

@override
String toString() {
  final _this = this as PollListItem;
  return 'PollListItem(pollId: ${_this.pollId}, title: ${_this.title}, closeAt: ${_this.closeAt}, pollCount: ${_this.pollCount}, isVoted: ${_this.isVoted})';
}


}

/// @nodoc
abstract mixin class $PollListItemCopyWith<$Res>  {
  factory $PollListItemCopyWith(PollListItem value, $Res Function(PollListItem) _then) = _$PollListItemCopyWithImpl;
@useResult
$Res call({
 int pollId, String title, DateTime? closeAt, int pollCount,@JsonKey(name: 'voted') bool isVoted
});




}
/// @nodoc
class _$PollListItemCopyWithImpl<$Res>
    implements $PollListItemCopyWith<$Res> {
  _$PollListItemCopyWithImpl(this._self, this._then);

  final PollListItem _self;
  final $Res Function(PollListItem) _then;

/// Create a copy of PollListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pollId = null,Object? title = null,Object? closeAt = freezed,Object? pollCount = null,Object? isVoted = null,}) {
  return _then(PollListItem(
pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,closeAt: freezed == closeAt ? _self.closeAt : closeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pollCount: null == pollCount ? _self.pollCount : pollCount // ignore: cast_nullable_to_non_nullable
as int,isVoted: null == isVoted ? _self.isVoted : isVoted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PollListItem].
extension PollListItemPatterns on PollListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollListItem value)  $default,){
final _that = this;
switch (_that) {
case _PollListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollListItem value)?  $default,){
final _that = this;
switch (_that) {
case _PollListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pollId,  String title,  DateTime? closeAt,  int pollCount, @JsonKey(name: 'voted')  bool isVoted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollListItem() when $default != null:
return $default(_that.pollId,_that.title,_that.closeAt,_that.pollCount,_that.isVoted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pollId,  String title,  DateTime? closeAt,  int pollCount, @JsonKey(name: 'voted')  bool isVoted)  $default,) {final _that = this;
switch (_that) {
case _PollListItem():
return $default(_that.pollId,_that.title,_that.closeAt,_that.pollCount,_that.isVoted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pollId,  String title,  DateTime? closeAt,  int pollCount, @JsonKey(name: 'voted')  bool isVoted)?  $default,) {final _that = this;
switch (_that) {
case _PollListItem() when $default != null:
return $default(_that.pollId,_that.title,_that.closeAt,_that.pollCount,_that.isVoted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollListItem implements PollListItem {
  const _PollListItem({required this.pollId, required this.title, this.closeAt, required this.pollCount, @JsonKey(name: 'voted') required this.isVoted});
  factory _PollListItem.fromJson(Map<String, dynamic> json) => _$PollListItemFromJson(json);

@override final  int pollId;
@override final  String title;
@override final  DateTime? closeAt;
@override final  int pollCount;
@override@JsonKey(name: 'voted') final  bool isVoted;

/// Create a copy of PollListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollListItemCopyWith<_PollListItem> get copyWith => __$PollListItemCopyWithImpl<_PollListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollListItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollListItem&&(identical(other.pollId, pollId) || other.pollId == pollId)&&(identical(other.title, title) || other.title == title)&&(identical(other.closeAt, closeAt) || other.closeAt == closeAt)&&(identical(other.pollCount, pollCount) || other.pollCount == pollCount)&&(identical(other.isVoted, isVoted) || other.isVoted == isVoted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,pollId,title,closeAt,pollCount,isVoted);
}

@override
String toString() {
    return 'PollListItem(pollId: $pollId, title: $title, closeAt: $closeAt, pollCount: $pollCount, isVoted: $isVoted)';
}


}

/// @nodoc
abstract mixin class _$PollListItemCopyWith<$Res> implements $PollListItemCopyWith<$Res> {
  factory _$PollListItemCopyWith(_PollListItem value, $Res Function(_PollListItem) _then) = __$PollListItemCopyWithImpl;
@override @useResult
$Res call({
 int pollId, String title, DateTime? closeAt, int pollCount,@JsonKey(name: 'voted') bool isVoted
});




}
/// @nodoc
class __$PollListItemCopyWithImpl<$Res>
    implements _$PollListItemCopyWith<$Res> {
  __$PollListItemCopyWithImpl(this._self, this._then);

  final _PollListItem _self;
  final $Res Function(_PollListItem) _then;

/// Create a copy of PollListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pollId = null,Object? title = null,Object? closeAt = freezed,Object? pollCount = null,Object? isVoted = null,}) {
  return _then(_PollListItem(
pollId: null == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,closeAt: freezed == closeAt ? _self.closeAt : closeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pollCount: null == pollCount ? _self.pollCount : pollCount // ignore: cast_nullable_to_non_nullable
as int,isVoted: null == isVoted ? _self.isVoted : isVoted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MeetitListResponse {

 bool get success; int get status; String get message; MeetitListData get data;
/// Create a copy of MeetitListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetitListResponseCopyWith<MeetitListResponse> get copyWith => _$MeetitListResponseCopyWithImpl<MeetitListResponse>(this as MeetitListResponse, _$identity);

  /// Serializes this MeetitListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetitListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetitListResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetitListResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as MeetitListResponse;
  return 'MeetitListResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $MeetitListResponseCopyWith<$Res>  {
  factory $MeetitListResponseCopyWith(MeetitListResponse value, $Res Function(MeetitListResponse) _then) = _$MeetitListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, MeetitListData data
});


$MeetitListDataCopyWith<$Res> get data;

}
/// @nodoc
class _$MeetitListResponseCopyWithImpl<$Res>
    implements $MeetitListResponseCopyWith<$Res> {
  _$MeetitListResponseCopyWithImpl(this._self, this._then);

  final MeetitListResponse _self;
  final $Res Function(MeetitListResponse) _then;

/// Create a copy of MeetitListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(MeetitListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MeetitListData,
  ));
}
/// Create a copy of MeetitListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetitListDataCopyWith<$Res> get data {
  
  return $MeetitListDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeetitListResponse].
extension MeetitListResponsePatterns on MeetitListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetitListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetitListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetitListResponse value)  $default,){
final _that = this;
switch (_that) {
case _MeetitListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetitListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MeetitListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  MeetitListData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetitListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  MeetitListData data)  $default,) {final _that = this;
switch (_that) {
case _MeetitListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  MeetitListData data)?  $default,) {final _that = this;
switch (_that) {
case _MeetitListResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetitListResponse implements MeetitListResponse {
  const _MeetitListResponse({required this.success, required this.status, required this.message, required this.data});
  factory _MeetitListResponse.fromJson(Map<String, dynamic> json) => _$MeetitListResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  MeetitListData data;

/// Create a copy of MeetitListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetitListResponseCopyWith<_MeetitListResponse> get copyWith => __$MeetitListResponseCopyWithImpl<_MeetitListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetitListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetitListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'MeetitListResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$MeetitListResponseCopyWith<$Res> implements $MeetitListResponseCopyWith<$Res> {
  factory _$MeetitListResponseCopyWith(_MeetitListResponse value, $Res Function(_MeetitListResponse) _then) = __$MeetitListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, MeetitListData data
});


@override $MeetitListDataCopyWith<$Res> get data;

}
/// @nodoc
class __$MeetitListResponseCopyWithImpl<$Res>
    implements _$MeetitListResponseCopyWith<$Res> {
  __$MeetitListResponseCopyWithImpl(this._self, this._then);

  final _MeetitListResponse _self;
  final $Res Function(_MeetitListResponse) _then;

/// Create a copy of MeetitListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_MeetitListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MeetitListData,
  ));
}

/// Create a copy of MeetitListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetitListDataCopyWith<$Res> get data {
  
  return $MeetitListDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$MeetitListData {

 List<MeetitListItem> get meetitList; int get totalCount; bool get hasNext;
/// Create a copy of MeetitListData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetitListDataCopyWith<MeetitListData> get copyWith => _$MeetitListDataCopyWithImpl<MeetitListData>(this as MeetitListData, _$identity);

  /// Serializes this MeetitListData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetitListData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetitListData&&const DeepCollectionEquality().equals(other.meetitList, _this.meetitList)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.hasNext, _this.hasNext) || other.hasNext == _this.hasNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetitListData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.meetitList),_this.totalCount,_this.hasNext);
}

@override
String toString() {
  final _this = this as MeetitListData;
  return 'MeetitListData(meetitList: ${_this.meetitList}, totalCount: ${_this.totalCount}, hasNext: ${_this.hasNext})';
}


}

/// @nodoc
abstract mixin class $MeetitListDataCopyWith<$Res>  {
  factory $MeetitListDataCopyWith(MeetitListData value, $Res Function(MeetitListData) _then) = _$MeetitListDataCopyWithImpl;
@useResult
$Res call({
 List<MeetitListItem> meetitList, int totalCount, bool hasNext
});




}
/// @nodoc
class _$MeetitListDataCopyWithImpl<$Res>
    implements $MeetitListDataCopyWith<$Res> {
  _$MeetitListDataCopyWithImpl(this._self, this._then);

  final MeetitListData _self;
  final $Res Function(MeetitListData) _then;

/// Create a copy of MeetitListData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetitList = null,Object? totalCount = null,Object? hasNext = null,}) {
  return _then(MeetitListData(
meetitList: null == meetitList ? _self.meetitList : meetitList // ignore: cast_nullable_to_non_nullable
as List<MeetitListItem>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetitListData].
extension MeetitListDataPatterns on MeetitListData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetitListData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetitListData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetitListData value)  $default,){
final _that = this;
switch (_that) {
case _MeetitListData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetitListData value)?  $default,){
final _that = this;
switch (_that) {
case _MeetitListData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MeetitListItem> meetitList,  int totalCount,  bool hasNext)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetitListData() when $default != null:
return $default(_that.meetitList,_that.totalCount,_that.hasNext);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MeetitListItem> meetitList,  int totalCount,  bool hasNext)  $default,) {final _that = this;
switch (_that) {
case _MeetitListData():
return $default(_that.meetitList,_that.totalCount,_that.hasNext);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MeetitListItem> meetitList,  int totalCount,  bool hasNext)?  $default,) {final _that = this;
switch (_that) {
case _MeetitListData() when $default != null:
return $default(_that.meetitList,_that.totalCount,_that.hasNext);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetitListData implements MeetitListData {
  const _MeetitListData({ List<MeetitListItem> meetitList = const <MeetitListItem>[], required this.totalCount, required this.hasNext}): _meetitList = meetitList;
  factory _MeetitListData.fromJson(Map<String, dynamic> json) => _$MeetitListDataFromJson(json);

 final  List<MeetitListItem> _meetitList;
@override@JsonKey() List<MeetitListItem> get meetitList {
  if (_meetitList is EqualUnmodifiableListView) return _meetitList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_meetitList);
}

@override final  int totalCount;
@override final  bool hasNext;

/// Create a copy of MeetitListData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetitListDataCopyWith<_MeetitListData> get copyWith => __$MeetitListDataCopyWithImpl<_MeetitListData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetitListDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetitListData&&const DeepCollectionEquality().equals(other.meetitList, _meetitList)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_meetitList),totalCount,hasNext);
}

@override
String toString() {
    return 'MeetitListData(meetitList: $meetitList, totalCount: $totalCount, hasNext: $hasNext)';
}


}

/// @nodoc
abstract mixin class _$MeetitListDataCopyWith<$Res> implements $MeetitListDataCopyWith<$Res> {
  factory _$MeetitListDataCopyWith(_MeetitListData value, $Res Function(_MeetitListData) _then) = __$MeetitListDataCopyWithImpl;
@override @useResult
$Res call({
 List<MeetitListItem> meetitList, int totalCount, bool hasNext
});




}
/// @nodoc
class __$MeetitListDataCopyWithImpl<$Res>
    implements _$MeetitListDataCopyWith<$Res> {
  __$MeetitListDataCopyWithImpl(this._self, this._then);

  final _MeetitListData _self;
  final $Res Function(_MeetitListData) _then;

/// Create a copy of MeetitListData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetitList = null,Object? totalCount = null,Object? hasNext = null,}) {
  return _then(_MeetitListData(
meetitList: null == meetitList ? _self._meetitList : meetitList // ignore: cast_nullable_to_non_nullable
as List<MeetitListItem>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MeetitListItem {

 int get meetitId; String get title; int get totalInvitedCount; int get respondedCount; MeetitMyResponseStatus get myResponseStatus; bool get dateOnly;
/// Create a copy of MeetitListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetitListItemCopyWith<MeetitListItem> get copyWith => _$MeetitListItemCopyWithImpl<MeetitListItem>(this as MeetitListItem, _$identity);

  /// Serializes this MeetitListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeetitListItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetitListItem&&(identical(other.meetitId, _this.meetitId) || other.meetitId == _this.meetitId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.totalInvitedCount, _this.totalInvitedCount) || other.totalInvitedCount == _this.totalInvitedCount)&&(identical(other.respondedCount, _this.respondedCount) || other.respondedCount == _this.respondedCount)&&(identical(other.myResponseStatus, _this.myResponseStatus) || other.myResponseStatus == _this.myResponseStatus)&&(identical(other.dateOnly, _this.dateOnly) || other.dateOnly == _this.dateOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeetitListItem;
  return Object.hash(runtimeType,_this.meetitId,_this.title,_this.totalInvitedCount,_this.respondedCount,_this.myResponseStatus,_this.dateOnly);
}

@override
String toString() {
  final _this = this as MeetitListItem;
  return 'MeetitListItem(meetitId: ${_this.meetitId}, title: ${_this.title}, totalInvitedCount: ${_this.totalInvitedCount}, respondedCount: ${_this.respondedCount}, myResponseStatus: ${_this.myResponseStatus}, dateOnly: ${_this.dateOnly})';
}


}

/// @nodoc
abstract mixin class $MeetitListItemCopyWith<$Res>  {
  factory $MeetitListItemCopyWith(MeetitListItem value, $Res Function(MeetitListItem) _then) = _$MeetitListItemCopyWithImpl;
@useResult
$Res call({
 int meetitId, String title, int totalInvitedCount, int respondedCount, MeetitMyResponseStatus myResponseStatus, bool dateOnly
});




}
/// @nodoc
class _$MeetitListItemCopyWithImpl<$Res>
    implements $MeetitListItemCopyWith<$Res> {
  _$MeetitListItemCopyWithImpl(this._self, this._then);

  final MeetitListItem _self;
  final $Res Function(MeetitListItem) _then;

/// Create a copy of MeetitListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meetitId = null,Object? title = null,Object? totalInvitedCount = null,Object? respondedCount = null,Object? myResponseStatus = null,Object? dateOnly = null,}) {
  return _then(MeetitListItem(
meetitId: null == meetitId ? _self.meetitId : meetitId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,totalInvitedCount: null == totalInvitedCount ? _self.totalInvitedCount : totalInvitedCount // ignore: cast_nullable_to_non_nullable
as int,respondedCount: null == respondedCount ? _self.respondedCount : respondedCount // ignore: cast_nullable_to_non_nullable
as int,myResponseStatus: null == myResponseStatus ? _self.myResponseStatus : myResponseStatus // ignore: cast_nullable_to_non_nullable
as MeetitMyResponseStatus,dateOnly: null == dateOnly ? _self.dateOnly : dateOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetitListItem].
extension MeetitListItemPatterns on MeetitListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetitListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetitListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetitListItem value)  $default,){
final _that = this;
switch (_that) {
case _MeetitListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetitListItem value)?  $default,){
final _that = this;
switch (_that) {
case _MeetitListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int meetitId,  String title,  int totalInvitedCount,  int respondedCount,  MeetitMyResponseStatus myResponseStatus,  bool dateOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetitListItem() when $default != null:
return $default(_that.meetitId,_that.title,_that.totalInvitedCount,_that.respondedCount,_that.myResponseStatus,_that.dateOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int meetitId,  String title,  int totalInvitedCount,  int respondedCount,  MeetitMyResponseStatus myResponseStatus,  bool dateOnly)  $default,) {final _that = this;
switch (_that) {
case _MeetitListItem():
return $default(_that.meetitId,_that.title,_that.totalInvitedCount,_that.respondedCount,_that.myResponseStatus,_that.dateOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int meetitId,  String title,  int totalInvitedCount,  int respondedCount,  MeetitMyResponseStatus myResponseStatus,  bool dateOnly)?  $default,) {final _that = this;
switch (_that) {
case _MeetitListItem() when $default != null:
return $default(_that.meetitId,_that.title,_that.totalInvitedCount,_that.respondedCount,_that.myResponseStatus,_that.dateOnly);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeetitListItem implements MeetitListItem {
  const _MeetitListItem({required this.meetitId, required this.title, required this.totalInvitedCount, required this.respondedCount, required this.myResponseStatus, required this.dateOnly});
  factory _MeetitListItem.fromJson(Map<String, dynamic> json) => _$MeetitListItemFromJson(json);

@override final  int meetitId;
@override final  String title;
@override final  int totalInvitedCount;
@override final  int respondedCount;
@override final  MeetitMyResponseStatus myResponseStatus;
@override final  bool dateOnly;

/// Create a copy of MeetitListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetitListItemCopyWith<_MeetitListItem> get copyWith => __$MeetitListItemCopyWithImpl<_MeetitListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetitListItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetitListItem&&(identical(other.meetitId, meetitId) || other.meetitId == meetitId)&&(identical(other.title, title) || other.title == title)&&(identical(other.totalInvitedCount, totalInvitedCount) || other.totalInvitedCount == totalInvitedCount)&&(identical(other.respondedCount, respondedCount) || other.respondedCount == respondedCount)&&(identical(other.myResponseStatus, myResponseStatus) || other.myResponseStatus == myResponseStatus)&&(identical(other.dateOnly, dateOnly) || other.dateOnly == dateOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,meetitId,title,totalInvitedCount,respondedCount,myResponseStatus,dateOnly);
}

@override
String toString() {
    return 'MeetitListItem(meetitId: $meetitId, title: $title, totalInvitedCount: $totalInvitedCount, respondedCount: $respondedCount, myResponseStatus: $myResponseStatus, dateOnly: $dateOnly)';
}


}

/// @nodoc
abstract mixin class _$MeetitListItemCopyWith<$Res> implements $MeetitListItemCopyWith<$Res> {
  factory _$MeetitListItemCopyWith(_MeetitListItem value, $Res Function(_MeetitListItem) _then) = __$MeetitListItemCopyWithImpl;
@override @useResult
$Res call({
 int meetitId, String title, int totalInvitedCount, int respondedCount, MeetitMyResponseStatus myResponseStatus, bool dateOnly
});




}
/// @nodoc
class __$MeetitListItemCopyWithImpl<$Res>
    implements _$MeetitListItemCopyWith<$Res> {
  __$MeetitListItemCopyWithImpl(this._self, this._then);

  final _MeetitListItem _self;
  final $Res Function(_MeetitListItem) _then;

/// Create a copy of MeetitListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meetitId = null,Object? title = null,Object? totalInvitedCount = null,Object? respondedCount = null,Object? myResponseStatus = null,Object? dateOnly = null,}) {
  return _then(_MeetitListItem(
meetitId: null == meetitId ? _self.meetitId : meetitId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,totalInvitedCount: null == totalInvitedCount ? _self.totalInvitedCount : totalInvitedCount // ignore: cast_nullable_to_non_nullable
as int,respondedCount: null == respondedCount ? _self.respondedCount : respondedCount // ignore: cast_nullable_to_non_nullable
as int,myResponseStatus: null == myResponseStatus ? _self.myResponseStatus : myResponseStatus // ignore: cast_nullable_to_non_nullable
as MeetitMyResponseStatus,dateOnly: null == dateOnly ? _self.dateOnly : dateOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
