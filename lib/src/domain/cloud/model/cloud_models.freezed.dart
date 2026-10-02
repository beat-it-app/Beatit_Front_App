// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cloud_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CloudListResponse {

 bool get success; int get status; String get message; CloudListData get data;
/// Create a copy of CloudListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudListResponseCopyWith<CloudListResponse> get copyWith => _$CloudListResponseCopyWithImpl<CloudListResponse>(this as CloudListResponse, _$identity);

  /// Serializes this CloudListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudListResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudListResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudListResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as CloudListResponse;
  return 'CloudListResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $CloudListResponseCopyWith<$Res>  {
  factory $CloudListResponseCopyWith(CloudListResponse value, $Res Function(CloudListResponse) _then) = _$CloudListResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, CloudListData data
});


$CloudListDataCopyWith<$Res> get data;

}
/// @nodoc
class _$CloudListResponseCopyWithImpl<$Res>
    implements $CloudListResponseCopyWith<$Res> {
  _$CloudListResponseCopyWithImpl(this._self, this._then);

  final CloudListResponse _self;
  final $Res Function(CloudListResponse) _then;

/// Create a copy of CloudListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(CloudListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CloudListData,
  ));
}
/// Create a copy of CloudListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CloudListDataCopyWith<$Res> get data {
  
  return $CloudListDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CloudListResponse].
extension CloudListResponsePatterns on CloudListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudListResponse value)  $default,){
final _that = this;
switch (_that) {
case _CloudListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CloudListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CloudListData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CloudListData data)  $default,) {final _that = this;
switch (_that) {
case _CloudListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  CloudListData data)?  $default,) {final _that = this;
switch (_that) {
case _CloudListResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudListResponse implements CloudListResponse {
  const _CloudListResponse({required this.success, required this.status, required this.message, required this.data});
  factory _CloudListResponse.fromJson(Map<String, dynamic> json) => _$CloudListResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  CloudListData data;

/// Create a copy of CloudListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudListResponseCopyWith<_CloudListResponse> get copyWith => __$CloudListResponseCopyWithImpl<_CloudListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudListResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'CloudListResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CloudListResponseCopyWith<$Res> implements $CloudListResponseCopyWith<$Res> {
  factory _$CloudListResponseCopyWith(_CloudListResponse value, $Res Function(_CloudListResponse) _then) = __$CloudListResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, CloudListData data
});


@override $CloudListDataCopyWith<$Res> get data;

}
/// @nodoc
class __$CloudListResponseCopyWithImpl<$Res>
    implements _$CloudListResponseCopyWith<$Res> {
  __$CloudListResponseCopyWithImpl(this._self, this._then);

  final _CloudListResponse _self;
  final $Res Function(_CloudListResponse) _then;

/// Create a copy of CloudListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_CloudListResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CloudListData,
  ));
}

/// Create a copy of CloudListResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CloudListDataCopyWith<$Res> get data {
  
  return $CloudListDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$CloudListData {

 String? get currentFolderName; List<CloudFolder> get folders; List<CloudItem> get items;
/// Create a copy of CloudListData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudListDataCopyWith<CloudListData> get copyWith => _$CloudListDataCopyWithImpl<CloudListData>(this as CloudListData, _$identity);

  /// Serializes this CloudListData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudListData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudListData&&(identical(other.currentFolderName, _this.currentFolderName) || other.currentFolderName == _this.currentFolderName)&&const DeepCollectionEquality().equals(other.folders, _this.folders)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudListData;
  return Object.hash(runtimeType,_this.currentFolderName,const DeepCollectionEquality().hash(_this.folders),const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as CloudListData;
  return 'CloudListData(currentFolderName: ${_this.currentFolderName}, folders: ${_this.folders}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $CloudListDataCopyWith<$Res>  {
  factory $CloudListDataCopyWith(CloudListData value, $Res Function(CloudListData) _then) = _$CloudListDataCopyWithImpl;
@useResult
$Res call({
 String? currentFolderName, List<CloudFolder> folders, List<CloudItem> items
});




}
/// @nodoc
class _$CloudListDataCopyWithImpl<$Res>
    implements $CloudListDataCopyWith<$Res> {
  _$CloudListDataCopyWithImpl(this._self, this._then);

  final CloudListData _self;
  final $Res Function(CloudListData) _then;

/// Create a copy of CloudListData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentFolderName = freezed,Object? folders = null,Object? items = null,}) {
  return _then(CloudListData(
currentFolderName: freezed == currentFolderName ? _self.currentFolderName : currentFolderName // ignore: cast_nullable_to_non_nullable
as String?,folders: null == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as List<CloudFolder>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CloudItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudListData].
extension CloudListDataPatterns on CloudListData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudListData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudListData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudListData value)  $default,){
final _that = this;
switch (_that) {
case _CloudListData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudListData value)?  $default,){
final _that = this;
switch (_that) {
case _CloudListData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? currentFolderName,  List<CloudFolder> folders,  List<CloudItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudListData() when $default != null:
return $default(_that.currentFolderName,_that.folders,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? currentFolderName,  List<CloudFolder> folders,  List<CloudItem> items)  $default,) {final _that = this;
switch (_that) {
case _CloudListData():
return $default(_that.currentFolderName,_that.folders,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? currentFolderName,  List<CloudFolder> folders,  List<CloudItem> items)?  $default,) {final _that = this;
switch (_that) {
case _CloudListData() when $default != null:
return $default(_that.currentFolderName,_that.folders,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudListData implements CloudListData {
  const _CloudListData({this.currentFolderName,  List<CloudFolder> folders = const <CloudFolder>[],  List<CloudItem> items = const <CloudItem>[]}): _folders = folders,_items = items;
  factory _CloudListData.fromJson(Map<String, dynamic> json) => _$CloudListDataFromJson(json);

@override final  String? currentFolderName;
 final  List<CloudFolder> _folders;
@override@JsonKey() List<CloudFolder> get folders {
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_folders);
}

 final  List<CloudItem> _items;
@override@JsonKey() List<CloudItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of CloudListData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudListDataCopyWith<_CloudListData> get copyWith => __$CloudListDataCopyWithImpl<_CloudListData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudListDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudListData&&(identical(other.currentFolderName, currentFolderName) || other.currentFolderName == currentFolderName)&&const DeepCollectionEquality().equals(other.folders, _folders)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,currentFolderName,const DeepCollectionEquality().hash(_folders),const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'CloudListData(currentFolderName: $currentFolderName, folders: $folders, items: $items)';
}


}

/// @nodoc
abstract mixin class _$CloudListDataCopyWith<$Res> implements $CloudListDataCopyWith<$Res> {
  factory _$CloudListDataCopyWith(_CloudListData value, $Res Function(_CloudListData) _then) = __$CloudListDataCopyWithImpl;
@override @useResult
$Res call({
 String? currentFolderName, List<CloudFolder> folders, List<CloudItem> items
});




}
/// @nodoc
class __$CloudListDataCopyWithImpl<$Res>
    implements _$CloudListDataCopyWith<$Res> {
  __$CloudListDataCopyWithImpl(this._self, this._then);

  final _CloudListData _self;
  final $Res Function(_CloudListData) _then;

/// Create a copy of CloudListData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentFolderName = freezed,Object? folders = null,Object? items = null,}) {
  return _then(_CloudListData(
currentFolderName: freezed == currentFolderName ? _self.currentFolderName : currentFolderName // ignore: cast_nullable_to_non_nullable
as String?,folders: null == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<CloudFolder>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CloudItem>,
  ));
}


}


/// @nodoc
mixin _$CloudFolder {

 int get folderId; String get folderName; int get itemCount; String get creatorName;
/// Create a copy of CloudFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudFolderCopyWith<CloudFolder> get copyWith => _$CloudFolderCopyWithImpl<CloudFolder>(this as CloudFolder, _$identity);

  /// Serializes this CloudFolder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudFolder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudFolder&&(identical(other.folderId, _this.folderId) || other.folderId == _this.folderId)&&(identical(other.folderName, _this.folderName) || other.folderName == _this.folderName)&&(identical(other.itemCount, _this.itemCount) || other.itemCount == _this.itemCount)&&(identical(other.creatorName, _this.creatorName) || other.creatorName == _this.creatorName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudFolder;
  return Object.hash(runtimeType,_this.folderId,_this.folderName,_this.itemCount,_this.creatorName);
}

@override
String toString() {
  final _this = this as CloudFolder;
  return 'CloudFolder(folderId: ${_this.folderId}, folderName: ${_this.folderName}, itemCount: ${_this.itemCount}, creatorName: ${_this.creatorName})';
}


}

/// @nodoc
abstract mixin class $CloudFolderCopyWith<$Res>  {
  factory $CloudFolderCopyWith(CloudFolder value, $Res Function(CloudFolder) _then) = _$CloudFolderCopyWithImpl;
@useResult
$Res call({
 int folderId, String folderName, int itemCount, String creatorName
});




}
/// @nodoc
class _$CloudFolderCopyWithImpl<$Res>
    implements $CloudFolderCopyWith<$Res> {
  _$CloudFolderCopyWithImpl(this._self, this._then);

  final CloudFolder _self;
  final $Res Function(CloudFolder) _then;

/// Create a copy of CloudFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folderId = null,Object? folderName = null,Object? itemCount = null,Object? creatorName = null,}) {
  return _then(CloudFolder(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as int,folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,creatorName: null == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudFolder].
extension CloudFolderPatterns on CloudFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudFolder value)  $default,){
final _that = this;
switch (_that) {
case _CloudFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudFolder value)?  $default,){
final _that = this;
switch (_that) {
case _CloudFolder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int folderId,  String folderName,  int itemCount,  String creatorName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudFolder() when $default != null:
return $default(_that.folderId,_that.folderName,_that.itemCount,_that.creatorName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int folderId,  String folderName,  int itemCount,  String creatorName)  $default,) {final _that = this;
switch (_that) {
case _CloudFolder():
return $default(_that.folderId,_that.folderName,_that.itemCount,_that.creatorName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int folderId,  String folderName,  int itemCount,  String creatorName)?  $default,) {final _that = this;
switch (_that) {
case _CloudFolder() when $default != null:
return $default(_that.folderId,_that.folderName,_that.itemCount,_that.creatorName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudFolder implements CloudFolder {
  const _CloudFolder({required this.folderId, required this.folderName, required this.itemCount, required this.creatorName});
  factory _CloudFolder.fromJson(Map<String, dynamic> json) => _$CloudFolderFromJson(json);

@override final  int folderId;
@override final  String folderName;
@override final  int itemCount;
@override final  String creatorName;

/// Create a copy of CloudFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudFolderCopyWith<_CloudFolder> get copyWith => __$CloudFolderCopyWithImpl<_CloudFolder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudFolderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudFolder&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.folderName, folderName) || other.folderName == folderName)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,folderId,folderName,itemCount,creatorName);
}

@override
String toString() {
    return 'CloudFolder(folderId: $folderId, folderName: $folderName, itemCount: $itemCount, creatorName: $creatorName)';
}


}

/// @nodoc
abstract mixin class _$CloudFolderCopyWith<$Res> implements $CloudFolderCopyWith<$Res> {
  factory _$CloudFolderCopyWith(_CloudFolder value, $Res Function(_CloudFolder) _then) = __$CloudFolderCopyWithImpl;
@override @useResult
$Res call({
 int folderId, String folderName, int itemCount, String creatorName
});




}
/// @nodoc
class __$CloudFolderCopyWithImpl<$Res>
    implements _$CloudFolderCopyWith<$Res> {
  __$CloudFolderCopyWithImpl(this._self, this._then);

  final _CloudFolder _self;
  final $Res Function(_CloudFolder) _then;

/// Create a copy of CloudFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folderId = null,Object? folderName = null,Object? itemCount = null,Object? creatorName = null,}) {
  return _then(_CloudFolder(
folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as int,folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,creatorName: null == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CloudItem {

 int get itemId; String get itemName; int? get fileSize; String? get mimeType; String? get linkUrl; String get uploaderName; DateTime get createdAt;
/// Create a copy of CloudItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudItemCopyWith<CloudItem> get copyWith => _$CloudItemCopyWithImpl<CloudItem>(this as CloudItem, _$identity);

  /// Serializes this CloudItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudItem&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.itemName, _this.itemName) || other.itemName == _this.itemName)&&(identical(other.fileSize, _this.fileSize) || other.fileSize == _this.fileSize)&&(identical(other.mimeType, _this.mimeType) || other.mimeType == _this.mimeType)&&(identical(other.linkUrl, _this.linkUrl) || other.linkUrl == _this.linkUrl)&&(identical(other.uploaderName, _this.uploaderName) || other.uploaderName == _this.uploaderName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudItem;
  return Object.hash(runtimeType,_this.itemId,_this.itemName,_this.fileSize,_this.mimeType,_this.linkUrl,_this.uploaderName,_this.createdAt);
}

@override
String toString() {
  final _this = this as CloudItem;
  return 'CloudItem(itemId: ${_this.itemId}, itemName: ${_this.itemName}, fileSize: ${_this.fileSize}, mimeType: ${_this.mimeType}, linkUrl: ${_this.linkUrl}, uploaderName: ${_this.uploaderName}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $CloudItemCopyWith<$Res>  {
  factory $CloudItemCopyWith(CloudItem value, $Res Function(CloudItem) _then) = _$CloudItemCopyWithImpl;
@useResult
$Res call({
 int itemId, String itemName, int? fileSize, String? mimeType, String? linkUrl, String uploaderName, DateTime createdAt
});




}
/// @nodoc
class _$CloudItemCopyWithImpl<$Res>
    implements $CloudItemCopyWith<$Res> {
  _$CloudItemCopyWithImpl(this._self, this._then);

  final CloudItem _self;
  final $Res Function(CloudItem) _then;

/// Create a copy of CloudItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? itemName = null,Object? fileSize = freezed,Object? mimeType = freezed,Object? linkUrl = freezed,Object? uploaderName = null,Object? createdAt = null,}) {
  return _then(CloudItem(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudItem].
extension CloudItemPatterns on CloudItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudItem value)  $default,){
final _that = this;
switch (_that) {
case _CloudItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudItem value)?  $default,){
final _that = this;
switch (_that) {
case _CloudItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int itemId,  String itemName,  int? fileSize,  String? mimeType,  String? linkUrl,  String uploaderName,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudItem() when $default != null:
return $default(_that.itemId,_that.itemName,_that.fileSize,_that.mimeType,_that.linkUrl,_that.uploaderName,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int itemId,  String itemName,  int? fileSize,  String? mimeType,  String? linkUrl,  String uploaderName,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CloudItem():
return $default(_that.itemId,_that.itemName,_that.fileSize,_that.mimeType,_that.linkUrl,_that.uploaderName,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int itemId,  String itemName,  int? fileSize,  String? mimeType,  String? linkUrl,  String uploaderName,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CloudItem() when $default != null:
return $default(_that.itemId,_that.itemName,_that.fileSize,_that.mimeType,_that.linkUrl,_that.uploaderName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudItem implements CloudItem {
  const _CloudItem({required this.itemId, required this.itemName, this.fileSize, this.mimeType, this.linkUrl, required this.uploaderName, required this.createdAt});
  factory _CloudItem.fromJson(Map<String, dynamic> json) => _$CloudItemFromJson(json);

@override final  int itemId;
@override final  String itemName;
@override final  int? fileSize;
@override final  String? mimeType;
@override final  String? linkUrl;
@override final  String uploaderName;
@override final  DateTime createdAt;

/// Create a copy of CloudItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudItemCopyWith<_CloudItem> get copyWith => __$CloudItemCopyWithImpl<_CloudItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl)&&(identical(other.uploaderName, uploaderName) || other.uploaderName == uploaderName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemId,itemName,fileSize,mimeType,linkUrl,uploaderName,createdAt);
}

@override
String toString() {
    return 'CloudItem(itemId: $itemId, itemName: $itemName, fileSize: $fileSize, mimeType: $mimeType, linkUrl: $linkUrl, uploaderName: $uploaderName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CloudItemCopyWith<$Res> implements $CloudItemCopyWith<$Res> {
  factory _$CloudItemCopyWith(_CloudItem value, $Res Function(_CloudItem) _then) = __$CloudItemCopyWithImpl;
@override @useResult
$Res call({
 int itemId, String itemName, int? fileSize, String? mimeType, String? linkUrl, String uploaderName, DateTime createdAt
});




}
/// @nodoc
class __$CloudItemCopyWithImpl<$Res>
    implements _$CloudItemCopyWith<$Res> {
  __$CloudItemCopyWithImpl(this._self, this._then);

  final _CloudItem _self;
  final $Res Function(_CloudItem) _then;

/// Create a copy of CloudItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? itemName = null,Object? fileSize = freezed,Object? mimeType = freezed,Object? linkUrl = freezed,Object? uploaderName = null,Object? createdAt = null,}) {
  return _then(_CloudItem(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,uploaderName: null == uploaderName ? _self.uploaderName : uploaderName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CloudFileDetailResponse {

 bool get success; int get status; String get message; CloudFileDetail get data;
/// Create a copy of CloudFileDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudFileDetailResponseCopyWith<CloudFileDetailResponse> get copyWith => _$CloudFileDetailResponseCopyWithImpl<CloudFileDetailResponse>(this as CloudFileDetailResponse, _$identity);

  /// Serializes this CloudFileDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudFileDetailResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudFileDetailResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudFileDetailResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as CloudFileDetailResponse;
  return 'CloudFileDetailResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $CloudFileDetailResponseCopyWith<$Res>  {
  factory $CloudFileDetailResponseCopyWith(CloudFileDetailResponse value, $Res Function(CloudFileDetailResponse) _then) = _$CloudFileDetailResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, CloudFileDetail data
});


$CloudFileDetailCopyWith<$Res> get data;

}
/// @nodoc
class _$CloudFileDetailResponseCopyWithImpl<$Res>
    implements $CloudFileDetailResponseCopyWith<$Res> {
  _$CloudFileDetailResponseCopyWithImpl(this._self, this._then);

  final CloudFileDetailResponse _self;
  final $Res Function(CloudFileDetailResponse) _then;

/// Create a copy of CloudFileDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(CloudFileDetailResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CloudFileDetail,
  ));
}
/// Create a copy of CloudFileDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CloudFileDetailCopyWith<$Res> get data {
  
  return $CloudFileDetailCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CloudFileDetailResponse].
extension CloudFileDetailResponsePatterns on CloudFileDetailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudFileDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudFileDetailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudFileDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _CloudFileDetailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudFileDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CloudFileDetailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CloudFileDetail data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudFileDetailResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CloudFileDetail data)  $default,) {final _that = this;
switch (_that) {
case _CloudFileDetailResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  CloudFileDetail data)?  $default,) {final _that = this;
switch (_that) {
case _CloudFileDetailResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudFileDetailResponse implements CloudFileDetailResponse {
  const _CloudFileDetailResponse({required this.success, required this.status, required this.message, required this.data});
  factory _CloudFileDetailResponse.fromJson(Map<String, dynamic> json) => _$CloudFileDetailResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  CloudFileDetail data;

/// Create a copy of CloudFileDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudFileDetailResponseCopyWith<_CloudFileDetailResponse> get copyWith => __$CloudFileDetailResponseCopyWithImpl<_CloudFileDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudFileDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudFileDetailResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'CloudFileDetailResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CloudFileDetailResponseCopyWith<$Res> implements $CloudFileDetailResponseCopyWith<$Res> {
  factory _$CloudFileDetailResponseCopyWith(_CloudFileDetailResponse value, $Res Function(_CloudFileDetailResponse) _then) = __$CloudFileDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, CloudFileDetail data
});


@override $CloudFileDetailCopyWith<$Res> get data;

}
/// @nodoc
class __$CloudFileDetailResponseCopyWithImpl<$Res>
    implements _$CloudFileDetailResponseCopyWith<$Res> {
  __$CloudFileDetailResponseCopyWithImpl(this._self, this._then);

  final _CloudFileDetailResponse _self;
  final $Res Function(_CloudFileDetailResponse) _then;

/// Create a copy of CloudFileDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_CloudFileDetailResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CloudFileDetail,
  ));
}

/// Create a copy of CloudFileDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CloudFileDetailCopyWith<$Res> get data {
  
  return $CloudFileDetailCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$CloudFileDetail {

 int get itemId; String get itemName; int get fileSize; String get mimeType; String get fileUrl;
/// Create a copy of CloudFileDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudFileDetailCopyWith<CloudFileDetail> get copyWith => _$CloudFileDetailCopyWithImpl<CloudFileDetail>(this as CloudFileDetail, _$identity);

  /// Serializes this CloudFileDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudFileDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudFileDetail&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.itemName, _this.itemName) || other.itemName == _this.itemName)&&(identical(other.fileSize, _this.fileSize) || other.fileSize == _this.fileSize)&&(identical(other.mimeType, _this.mimeType) || other.mimeType == _this.mimeType)&&(identical(other.fileUrl, _this.fileUrl) || other.fileUrl == _this.fileUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudFileDetail;
  return Object.hash(runtimeType,_this.itemId,_this.itemName,_this.fileSize,_this.mimeType,_this.fileUrl);
}

@override
String toString() {
  final _this = this as CloudFileDetail;
  return 'CloudFileDetail(itemId: ${_this.itemId}, itemName: ${_this.itemName}, fileSize: ${_this.fileSize}, mimeType: ${_this.mimeType}, fileUrl: ${_this.fileUrl})';
}


}

/// @nodoc
abstract mixin class $CloudFileDetailCopyWith<$Res>  {
  factory $CloudFileDetailCopyWith(CloudFileDetail value, $Res Function(CloudFileDetail) _then) = _$CloudFileDetailCopyWithImpl;
@useResult
$Res call({
 int itemId, String itemName, int fileSize, String mimeType, String fileUrl
});




}
/// @nodoc
class _$CloudFileDetailCopyWithImpl<$Res>
    implements $CloudFileDetailCopyWith<$Res> {
  _$CloudFileDetailCopyWithImpl(this._self, this._then);

  final CloudFileDetail _self;
  final $Res Function(CloudFileDetail) _then;

/// Create a copy of CloudFileDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? itemName = null,Object? fileSize = null,Object? mimeType = null,Object? fileUrl = null,}) {
  return _then(CloudFileDetail(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudFileDetail].
extension CloudFileDetailPatterns on CloudFileDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudFileDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudFileDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudFileDetail value)  $default,){
final _that = this;
switch (_that) {
case _CloudFileDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudFileDetail value)?  $default,){
final _that = this;
switch (_that) {
case _CloudFileDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int itemId,  String itemName,  int fileSize,  String mimeType,  String fileUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudFileDetail() when $default != null:
return $default(_that.itemId,_that.itemName,_that.fileSize,_that.mimeType,_that.fileUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int itemId,  String itemName,  int fileSize,  String mimeType,  String fileUrl)  $default,) {final _that = this;
switch (_that) {
case _CloudFileDetail():
return $default(_that.itemId,_that.itemName,_that.fileSize,_that.mimeType,_that.fileUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int itemId,  String itemName,  int fileSize,  String mimeType,  String fileUrl)?  $default,) {final _that = this;
switch (_that) {
case _CloudFileDetail() when $default != null:
return $default(_that.itemId,_that.itemName,_that.fileSize,_that.mimeType,_that.fileUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudFileDetail implements CloudFileDetail {
  const _CloudFileDetail({required this.itemId, required this.itemName, required this.fileSize, required this.mimeType, required this.fileUrl});
  factory _CloudFileDetail.fromJson(Map<String, dynamic> json) => _$CloudFileDetailFromJson(json);

@override final  int itemId;
@override final  String itemName;
@override final  int fileSize;
@override final  String mimeType;
@override final  String fileUrl;

/// Create a copy of CloudFileDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudFileDetailCopyWith<_CloudFileDetail> get copyWith => __$CloudFileDetailCopyWithImpl<_CloudFileDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudFileDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudFileDetail&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemId,itemName,fileSize,mimeType,fileUrl);
}

@override
String toString() {
    return 'CloudFileDetail(itemId: $itemId, itemName: $itemName, fileSize: $fileSize, mimeType: $mimeType, fileUrl: $fileUrl)';
}


}

/// @nodoc
abstract mixin class _$CloudFileDetailCopyWith<$Res> implements $CloudFileDetailCopyWith<$Res> {
  factory _$CloudFileDetailCopyWith(_CloudFileDetail value, $Res Function(_CloudFileDetail) _then) = __$CloudFileDetailCopyWithImpl;
@override @useResult
$Res call({
 int itemId, String itemName, int fileSize, String mimeType, String fileUrl
});




}
/// @nodoc
class __$CloudFileDetailCopyWithImpl<$Res>
    implements _$CloudFileDetailCopyWith<$Res> {
  __$CloudFileDetailCopyWithImpl(this._self, this._then);

  final _CloudFileDetail _self;
  final $Res Function(_CloudFileDetail) _then;

/// Create a copy of CloudFileDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? itemName = null,Object? fileSize = null,Object? mimeType = null,Object? fileUrl = null,}) {
  return _then(_CloudFileDetail(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CloudPresignedUrlResponse {

 bool get success; int get status; String get message; CloudPresignedUrlData get data;
/// Create a copy of CloudPresignedUrlResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudPresignedUrlResponseCopyWith<CloudPresignedUrlResponse> get copyWith => _$CloudPresignedUrlResponseCopyWithImpl<CloudPresignedUrlResponse>(this as CloudPresignedUrlResponse, _$identity);

  /// Serializes this CloudPresignedUrlResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudPresignedUrlResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudPresignedUrlResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudPresignedUrlResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as CloudPresignedUrlResponse;
  return 'CloudPresignedUrlResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $CloudPresignedUrlResponseCopyWith<$Res>  {
  factory $CloudPresignedUrlResponseCopyWith(CloudPresignedUrlResponse value, $Res Function(CloudPresignedUrlResponse) _then) = _$CloudPresignedUrlResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, CloudPresignedUrlData data
});


$CloudPresignedUrlDataCopyWith<$Res> get data;

}
/// @nodoc
class _$CloudPresignedUrlResponseCopyWithImpl<$Res>
    implements $CloudPresignedUrlResponseCopyWith<$Res> {
  _$CloudPresignedUrlResponseCopyWithImpl(this._self, this._then);

  final CloudPresignedUrlResponse _self;
  final $Res Function(CloudPresignedUrlResponse) _then;

/// Create a copy of CloudPresignedUrlResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(CloudPresignedUrlResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CloudPresignedUrlData,
  ));
}
/// Create a copy of CloudPresignedUrlResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CloudPresignedUrlDataCopyWith<$Res> get data {
  
  return $CloudPresignedUrlDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CloudPresignedUrlResponse].
extension CloudPresignedUrlResponsePatterns on CloudPresignedUrlResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudPresignedUrlResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudPresignedUrlResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudPresignedUrlResponse value)  $default,){
final _that = this;
switch (_that) {
case _CloudPresignedUrlResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudPresignedUrlResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CloudPresignedUrlResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CloudPresignedUrlData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudPresignedUrlResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CloudPresignedUrlData data)  $default,) {final _that = this;
switch (_that) {
case _CloudPresignedUrlResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  CloudPresignedUrlData data)?  $default,) {final _that = this;
switch (_that) {
case _CloudPresignedUrlResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudPresignedUrlResponse implements CloudPresignedUrlResponse {
  const _CloudPresignedUrlResponse({required this.success, required this.status, required this.message, required this.data});
  factory _CloudPresignedUrlResponse.fromJson(Map<String, dynamic> json) => _$CloudPresignedUrlResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  CloudPresignedUrlData data;

/// Create a copy of CloudPresignedUrlResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudPresignedUrlResponseCopyWith<_CloudPresignedUrlResponse> get copyWith => __$CloudPresignedUrlResponseCopyWithImpl<_CloudPresignedUrlResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudPresignedUrlResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudPresignedUrlResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'CloudPresignedUrlResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CloudPresignedUrlResponseCopyWith<$Res> implements $CloudPresignedUrlResponseCopyWith<$Res> {
  factory _$CloudPresignedUrlResponseCopyWith(_CloudPresignedUrlResponse value, $Res Function(_CloudPresignedUrlResponse) _then) = __$CloudPresignedUrlResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, CloudPresignedUrlData data
});


@override $CloudPresignedUrlDataCopyWith<$Res> get data;

}
/// @nodoc
class __$CloudPresignedUrlResponseCopyWithImpl<$Res>
    implements _$CloudPresignedUrlResponseCopyWith<$Res> {
  __$CloudPresignedUrlResponseCopyWithImpl(this._self, this._then);

  final _CloudPresignedUrlResponse _self;
  final $Res Function(_CloudPresignedUrlResponse) _then;

/// Create a copy of CloudPresignedUrlResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_CloudPresignedUrlResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CloudPresignedUrlData,
  ));
}

/// Create a copy of CloudPresignedUrlResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CloudPresignedUrlDataCopyWith<$Res> get data {
  
  return $CloudPresignedUrlDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$CloudPresignedUrlData {

 String get presignedUrl; String get storageKey; String get cdnUrl; int get expirationMinutes;
/// Create a copy of CloudPresignedUrlData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudPresignedUrlDataCopyWith<CloudPresignedUrlData> get copyWith => _$CloudPresignedUrlDataCopyWithImpl<CloudPresignedUrlData>(this as CloudPresignedUrlData, _$identity);

  /// Serializes this CloudPresignedUrlData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudPresignedUrlData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudPresignedUrlData&&(identical(other.presignedUrl, _this.presignedUrl) || other.presignedUrl == _this.presignedUrl)&&(identical(other.storageKey, _this.storageKey) || other.storageKey == _this.storageKey)&&(identical(other.cdnUrl, _this.cdnUrl) || other.cdnUrl == _this.cdnUrl)&&(identical(other.expirationMinutes, _this.expirationMinutes) || other.expirationMinutes == _this.expirationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudPresignedUrlData;
  return Object.hash(runtimeType,_this.presignedUrl,_this.storageKey,_this.cdnUrl,_this.expirationMinutes);
}

@override
String toString() {
  final _this = this as CloudPresignedUrlData;
  return 'CloudPresignedUrlData(presignedUrl: ${_this.presignedUrl}, storageKey: ${_this.storageKey}, cdnUrl: ${_this.cdnUrl}, expirationMinutes: ${_this.expirationMinutes})';
}


}

/// @nodoc
abstract mixin class $CloudPresignedUrlDataCopyWith<$Res>  {
  factory $CloudPresignedUrlDataCopyWith(CloudPresignedUrlData value, $Res Function(CloudPresignedUrlData) _then) = _$CloudPresignedUrlDataCopyWithImpl;
@useResult
$Res call({
 String presignedUrl, String storageKey, String cdnUrl, int expirationMinutes
});




}
/// @nodoc
class _$CloudPresignedUrlDataCopyWithImpl<$Res>
    implements $CloudPresignedUrlDataCopyWith<$Res> {
  _$CloudPresignedUrlDataCopyWithImpl(this._self, this._then);

  final CloudPresignedUrlData _self;
  final $Res Function(CloudPresignedUrlData) _then;

/// Create a copy of CloudPresignedUrlData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? presignedUrl = null,Object? storageKey = null,Object? cdnUrl = null,Object? expirationMinutes = null,}) {
  return _then(CloudPresignedUrlData(
presignedUrl: null == presignedUrl ? _self.presignedUrl : presignedUrl // ignore: cast_nullable_to_non_nullable
as String,storageKey: null == storageKey ? _self.storageKey : storageKey // ignore: cast_nullable_to_non_nullable
as String,cdnUrl: null == cdnUrl ? _self.cdnUrl : cdnUrl // ignore: cast_nullable_to_non_nullable
as String,expirationMinutes: null == expirationMinutes ? _self.expirationMinutes : expirationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudPresignedUrlData].
extension CloudPresignedUrlDataPatterns on CloudPresignedUrlData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudPresignedUrlData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudPresignedUrlData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudPresignedUrlData value)  $default,){
final _that = this;
switch (_that) {
case _CloudPresignedUrlData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudPresignedUrlData value)?  $default,){
final _that = this;
switch (_that) {
case _CloudPresignedUrlData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String presignedUrl,  String storageKey,  String cdnUrl,  int expirationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudPresignedUrlData() when $default != null:
return $default(_that.presignedUrl,_that.storageKey,_that.cdnUrl,_that.expirationMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String presignedUrl,  String storageKey,  String cdnUrl,  int expirationMinutes)  $default,) {final _that = this;
switch (_that) {
case _CloudPresignedUrlData():
return $default(_that.presignedUrl,_that.storageKey,_that.cdnUrl,_that.expirationMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String presignedUrl,  String storageKey,  String cdnUrl,  int expirationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _CloudPresignedUrlData() when $default != null:
return $default(_that.presignedUrl,_that.storageKey,_that.cdnUrl,_that.expirationMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudPresignedUrlData implements CloudPresignedUrlData {
  const _CloudPresignedUrlData({required this.presignedUrl, required this.storageKey, required this.cdnUrl, required this.expirationMinutes});
  factory _CloudPresignedUrlData.fromJson(Map<String, dynamic> json) => _$CloudPresignedUrlDataFromJson(json);

@override final  String presignedUrl;
@override final  String storageKey;
@override final  String cdnUrl;
@override final  int expirationMinutes;

/// Create a copy of CloudPresignedUrlData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudPresignedUrlDataCopyWith<_CloudPresignedUrlData> get copyWith => __$CloudPresignedUrlDataCopyWithImpl<_CloudPresignedUrlData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudPresignedUrlDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudPresignedUrlData&&(identical(other.presignedUrl, presignedUrl) || other.presignedUrl == presignedUrl)&&(identical(other.storageKey, storageKey) || other.storageKey == storageKey)&&(identical(other.cdnUrl, cdnUrl) || other.cdnUrl == cdnUrl)&&(identical(other.expirationMinutes, expirationMinutes) || other.expirationMinutes == expirationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,presignedUrl,storageKey,cdnUrl,expirationMinutes);
}

@override
String toString() {
    return 'CloudPresignedUrlData(presignedUrl: $presignedUrl, storageKey: $storageKey, cdnUrl: $cdnUrl, expirationMinutes: $expirationMinutes)';
}


}

/// @nodoc
abstract mixin class _$CloudPresignedUrlDataCopyWith<$Res> implements $CloudPresignedUrlDataCopyWith<$Res> {
  factory _$CloudPresignedUrlDataCopyWith(_CloudPresignedUrlData value, $Res Function(_CloudPresignedUrlData) _then) = __$CloudPresignedUrlDataCopyWithImpl;
@override @useResult
$Res call({
 String presignedUrl, String storageKey, String cdnUrl, int expirationMinutes
});




}
/// @nodoc
class __$CloudPresignedUrlDataCopyWithImpl<$Res>
    implements _$CloudPresignedUrlDataCopyWith<$Res> {
  __$CloudPresignedUrlDataCopyWithImpl(this._self, this._then);

  final _CloudPresignedUrlData _self;
  final $Res Function(_CloudPresignedUrlData) _then;

/// Create a copy of CloudPresignedUrlData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? presignedUrl = null,Object? storageKey = null,Object? cdnUrl = null,Object? expirationMinutes = null,}) {
  return _then(_CloudPresignedUrlData(
presignedUrl: null == presignedUrl ? _self.presignedUrl : presignedUrl // ignore: cast_nullable_to_non_nullable
as String,storageKey: null == storageKey ? _self.storageKey : storageKey // ignore: cast_nullable_to_non_nullable
as String,cdnUrl: null == cdnUrl ? _self.cdnUrl : cdnUrl // ignore: cast_nullable_to_non_nullable
as String,expirationMinutes: null == expirationMinutes ? _self.expirationMinutes : expirationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CloudStorageResponse {

 bool get success; int get status; String get message; CloudStorageData get data;
/// Create a copy of CloudStorageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudStorageResponseCopyWith<CloudStorageResponse> get copyWith => _$CloudStorageResponseCopyWithImpl<CloudStorageResponse>(this as CloudStorageResponse, _$identity);

  /// Serializes this CloudStorageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudStorageResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudStorageResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudStorageResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as CloudStorageResponse;
  return 'CloudStorageResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $CloudStorageResponseCopyWith<$Res>  {
  factory $CloudStorageResponseCopyWith(CloudStorageResponse value, $Res Function(CloudStorageResponse) _then) = _$CloudStorageResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, CloudStorageData data
});


$CloudStorageDataCopyWith<$Res> get data;

}
/// @nodoc
class _$CloudStorageResponseCopyWithImpl<$Res>
    implements $CloudStorageResponseCopyWith<$Res> {
  _$CloudStorageResponseCopyWithImpl(this._self, this._then);

  final CloudStorageResponse _self;
  final $Res Function(CloudStorageResponse) _then;

/// Create a copy of CloudStorageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(CloudStorageResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CloudStorageData,
  ));
}
/// Create a copy of CloudStorageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CloudStorageDataCopyWith<$Res> get data {
  
  return $CloudStorageDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CloudStorageResponse].
extension CloudStorageResponsePatterns on CloudStorageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudStorageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudStorageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudStorageResponse value)  $default,){
final _that = this;
switch (_that) {
case _CloudStorageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudStorageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CloudStorageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CloudStorageData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudStorageResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  CloudStorageData data)  $default,) {final _that = this;
switch (_that) {
case _CloudStorageResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  CloudStorageData data)?  $default,) {final _that = this;
switch (_that) {
case _CloudStorageResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudStorageResponse implements CloudStorageResponse {
  const _CloudStorageResponse({required this.success, required this.status, required this.message, required this.data});
  factory _CloudStorageResponse.fromJson(Map<String, dynamic> json) => _$CloudStorageResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  CloudStorageData data;

/// Create a copy of CloudStorageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudStorageResponseCopyWith<_CloudStorageResponse> get copyWith => __$CloudStorageResponseCopyWithImpl<_CloudStorageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudStorageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudStorageResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'CloudStorageResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CloudStorageResponseCopyWith<$Res> implements $CloudStorageResponseCopyWith<$Res> {
  factory _$CloudStorageResponseCopyWith(_CloudStorageResponse value, $Res Function(_CloudStorageResponse) _then) = __$CloudStorageResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, CloudStorageData data
});


@override $CloudStorageDataCopyWith<$Res> get data;

}
/// @nodoc
class __$CloudStorageResponseCopyWithImpl<$Res>
    implements _$CloudStorageResponseCopyWith<$Res> {
  __$CloudStorageResponseCopyWithImpl(this._self, this._then);

  final _CloudStorageResponse _self;
  final $Res Function(_CloudStorageResponse) _then;

/// Create a copy of CloudStorageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_CloudStorageResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CloudStorageData,
  ));
}

/// Create a copy of CloudStorageResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CloudStorageDataCopyWith<$Res> get data {
  
  return $CloudStorageDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$CloudStorageData {

 String get teamName; int get usagePercentage; int get totalStorageBytes; String get totalStorageDisplay; int get usedStorageBytes; String get usedStorageDisplay; int get remainingStorageBytes; String get remainingStorageDisplay; List<CloudStorageCategoryUsage> get categories;
/// Create a copy of CloudStorageData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudStorageDataCopyWith<CloudStorageData> get copyWith => _$CloudStorageDataCopyWithImpl<CloudStorageData>(this as CloudStorageData, _$identity);

  /// Serializes this CloudStorageData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudStorageData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudStorageData&&(identical(other.teamName, _this.teamName) || other.teamName == _this.teamName)&&(identical(other.usagePercentage, _this.usagePercentage) || other.usagePercentage == _this.usagePercentage)&&(identical(other.totalStorageBytes, _this.totalStorageBytes) || other.totalStorageBytes == _this.totalStorageBytes)&&(identical(other.totalStorageDisplay, _this.totalStorageDisplay) || other.totalStorageDisplay == _this.totalStorageDisplay)&&(identical(other.usedStorageBytes, _this.usedStorageBytes) || other.usedStorageBytes == _this.usedStorageBytes)&&(identical(other.usedStorageDisplay, _this.usedStorageDisplay) || other.usedStorageDisplay == _this.usedStorageDisplay)&&(identical(other.remainingStorageBytes, _this.remainingStorageBytes) || other.remainingStorageBytes == _this.remainingStorageBytes)&&(identical(other.remainingStorageDisplay, _this.remainingStorageDisplay) || other.remainingStorageDisplay == _this.remainingStorageDisplay)&&const DeepCollectionEquality().equals(other.categories, _this.categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudStorageData;
  return Object.hash(runtimeType,_this.teamName,_this.usagePercentage,_this.totalStorageBytes,_this.totalStorageDisplay,_this.usedStorageBytes,_this.usedStorageDisplay,_this.remainingStorageBytes,_this.remainingStorageDisplay,const DeepCollectionEquality().hash(_this.categories));
}

@override
String toString() {
  final _this = this as CloudStorageData;
  return 'CloudStorageData(teamName: ${_this.teamName}, usagePercentage: ${_this.usagePercentage}, totalStorageBytes: ${_this.totalStorageBytes}, totalStorageDisplay: ${_this.totalStorageDisplay}, usedStorageBytes: ${_this.usedStorageBytes}, usedStorageDisplay: ${_this.usedStorageDisplay}, remainingStorageBytes: ${_this.remainingStorageBytes}, remainingStorageDisplay: ${_this.remainingStorageDisplay}, categories: ${_this.categories})';
}


}

/// @nodoc
abstract mixin class $CloudStorageDataCopyWith<$Res>  {
  factory $CloudStorageDataCopyWith(CloudStorageData value, $Res Function(CloudStorageData) _then) = _$CloudStorageDataCopyWithImpl;
@useResult
$Res call({
 String teamName, int usagePercentage, int totalStorageBytes, String totalStorageDisplay, int usedStorageBytes, String usedStorageDisplay, int remainingStorageBytes, String remainingStorageDisplay, List<CloudStorageCategoryUsage> categories
});




}
/// @nodoc
class _$CloudStorageDataCopyWithImpl<$Res>
    implements $CloudStorageDataCopyWith<$Res> {
  _$CloudStorageDataCopyWithImpl(this._self, this._then);

  final CloudStorageData _self;
  final $Res Function(CloudStorageData) _then;

/// Create a copy of CloudStorageData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamName = null,Object? usagePercentage = null,Object? totalStorageBytes = null,Object? totalStorageDisplay = null,Object? usedStorageBytes = null,Object? usedStorageDisplay = null,Object? remainingStorageBytes = null,Object? remainingStorageDisplay = null,Object? categories = null,}) {
  return _then(CloudStorageData(
teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,usagePercentage: null == usagePercentage ? _self.usagePercentage : usagePercentage // ignore: cast_nullable_to_non_nullable
as int,totalStorageBytes: null == totalStorageBytes ? _self.totalStorageBytes : totalStorageBytes // ignore: cast_nullable_to_non_nullable
as int,totalStorageDisplay: null == totalStorageDisplay ? _self.totalStorageDisplay : totalStorageDisplay // ignore: cast_nullable_to_non_nullable
as String,usedStorageBytes: null == usedStorageBytes ? _self.usedStorageBytes : usedStorageBytes // ignore: cast_nullable_to_non_nullable
as int,usedStorageDisplay: null == usedStorageDisplay ? _self.usedStorageDisplay : usedStorageDisplay // ignore: cast_nullable_to_non_nullable
as String,remainingStorageBytes: null == remainingStorageBytes ? _self.remainingStorageBytes : remainingStorageBytes // ignore: cast_nullable_to_non_nullable
as int,remainingStorageDisplay: null == remainingStorageDisplay ? _self.remainingStorageDisplay : remainingStorageDisplay // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CloudStorageCategoryUsage>,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudStorageData].
extension CloudStorageDataPatterns on CloudStorageData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudStorageData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudStorageData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudStorageData value)  $default,){
final _that = this;
switch (_that) {
case _CloudStorageData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudStorageData value)?  $default,){
final _that = this;
switch (_that) {
case _CloudStorageData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String teamName,  int usagePercentage,  int totalStorageBytes,  String totalStorageDisplay,  int usedStorageBytes,  String usedStorageDisplay,  int remainingStorageBytes,  String remainingStorageDisplay,  List<CloudStorageCategoryUsage> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudStorageData() when $default != null:
return $default(_that.teamName,_that.usagePercentage,_that.totalStorageBytes,_that.totalStorageDisplay,_that.usedStorageBytes,_that.usedStorageDisplay,_that.remainingStorageBytes,_that.remainingStorageDisplay,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String teamName,  int usagePercentage,  int totalStorageBytes,  String totalStorageDisplay,  int usedStorageBytes,  String usedStorageDisplay,  int remainingStorageBytes,  String remainingStorageDisplay,  List<CloudStorageCategoryUsage> categories)  $default,) {final _that = this;
switch (_that) {
case _CloudStorageData():
return $default(_that.teamName,_that.usagePercentage,_that.totalStorageBytes,_that.totalStorageDisplay,_that.usedStorageBytes,_that.usedStorageDisplay,_that.remainingStorageBytes,_that.remainingStorageDisplay,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String teamName,  int usagePercentage,  int totalStorageBytes,  String totalStorageDisplay,  int usedStorageBytes,  String usedStorageDisplay,  int remainingStorageBytes,  String remainingStorageDisplay,  List<CloudStorageCategoryUsage> categories)?  $default,) {final _that = this;
switch (_that) {
case _CloudStorageData() when $default != null:
return $default(_that.teamName,_that.usagePercentage,_that.totalStorageBytes,_that.totalStorageDisplay,_that.usedStorageBytes,_that.usedStorageDisplay,_that.remainingStorageBytes,_that.remainingStorageDisplay,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudStorageData implements CloudStorageData {
  const _CloudStorageData({required this.teamName, required this.usagePercentage, required this.totalStorageBytes, required this.totalStorageDisplay, required this.usedStorageBytes, required this.usedStorageDisplay, required this.remainingStorageBytes, required this.remainingStorageDisplay,  List<CloudStorageCategoryUsage> categories = const <CloudStorageCategoryUsage>[]}): _categories = categories;
  factory _CloudStorageData.fromJson(Map<String, dynamic> json) => _$CloudStorageDataFromJson(json);

@override final  String teamName;
@override final  int usagePercentage;
@override final  int totalStorageBytes;
@override final  String totalStorageDisplay;
@override final  int usedStorageBytes;
@override final  String usedStorageDisplay;
@override final  int remainingStorageBytes;
@override final  String remainingStorageDisplay;
 final  List<CloudStorageCategoryUsage> _categories;
@override@JsonKey() List<CloudStorageCategoryUsage> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of CloudStorageData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudStorageDataCopyWith<_CloudStorageData> get copyWith => __$CloudStorageDataCopyWithImpl<_CloudStorageData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudStorageDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudStorageData&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.usagePercentage, usagePercentage) || other.usagePercentage == usagePercentage)&&(identical(other.totalStorageBytes, totalStorageBytes) || other.totalStorageBytes == totalStorageBytes)&&(identical(other.totalStorageDisplay, totalStorageDisplay) || other.totalStorageDisplay == totalStorageDisplay)&&(identical(other.usedStorageBytes, usedStorageBytes) || other.usedStorageBytes == usedStorageBytes)&&(identical(other.usedStorageDisplay, usedStorageDisplay) || other.usedStorageDisplay == usedStorageDisplay)&&(identical(other.remainingStorageBytes, remainingStorageBytes) || other.remainingStorageBytes == remainingStorageBytes)&&(identical(other.remainingStorageDisplay, remainingStorageDisplay) || other.remainingStorageDisplay == remainingStorageDisplay)&&const DeepCollectionEquality().equals(other.categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,teamName,usagePercentage,totalStorageBytes,totalStorageDisplay,usedStorageBytes,usedStorageDisplay,remainingStorageBytes,remainingStorageDisplay,const DeepCollectionEquality().hash(_categories));
}

@override
String toString() {
    return 'CloudStorageData(teamName: $teamName, usagePercentage: $usagePercentage, totalStorageBytes: $totalStorageBytes, totalStorageDisplay: $totalStorageDisplay, usedStorageBytes: $usedStorageBytes, usedStorageDisplay: $usedStorageDisplay, remainingStorageBytes: $remainingStorageBytes, remainingStorageDisplay: $remainingStorageDisplay, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$CloudStorageDataCopyWith<$Res> implements $CloudStorageDataCopyWith<$Res> {
  factory _$CloudStorageDataCopyWith(_CloudStorageData value, $Res Function(_CloudStorageData) _then) = __$CloudStorageDataCopyWithImpl;
@override @useResult
$Res call({
 String teamName, int usagePercentage, int totalStorageBytes, String totalStorageDisplay, int usedStorageBytes, String usedStorageDisplay, int remainingStorageBytes, String remainingStorageDisplay, List<CloudStorageCategoryUsage> categories
});




}
/// @nodoc
class __$CloudStorageDataCopyWithImpl<$Res>
    implements _$CloudStorageDataCopyWith<$Res> {
  __$CloudStorageDataCopyWithImpl(this._self, this._then);

  final _CloudStorageData _self;
  final $Res Function(_CloudStorageData) _then;

/// Create a copy of CloudStorageData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamName = null,Object? usagePercentage = null,Object? totalStorageBytes = null,Object? totalStorageDisplay = null,Object? usedStorageBytes = null,Object? usedStorageDisplay = null,Object? remainingStorageBytes = null,Object? remainingStorageDisplay = null,Object? categories = null,}) {
  return _then(_CloudStorageData(
teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,usagePercentage: null == usagePercentage ? _self.usagePercentage : usagePercentage // ignore: cast_nullable_to_non_nullable
as int,totalStorageBytes: null == totalStorageBytes ? _self.totalStorageBytes : totalStorageBytes // ignore: cast_nullable_to_non_nullable
as int,totalStorageDisplay: null == totalStorageDisplay ? _self.totalStorageDisplay : totalStorageDisplay // ignore: cast_nullable_to_non_nullable
as String,usedStorageBytes: null == usedStorageBytes ? _self.usedStorageBytes : usedStorageBytes // ignore: cast_nullable_to_non_nullable
as int,usedStorageDisplay: null == usedStorageDisplay ? _self.usedStorageDisplay : usedStorageDisplay // ignore: cast_nullable_to_non_nullable
as String,remainingStorageBytes: null == remainingStorageBytes ? _self.remainingStorageBytes : remainingStorageBytes // ignore: cast_nullable_to_non_nullable
as int,remainingStorageDisplay: null == remainingStorageDisplay ? _self.remainingStorageDisplay : remainingStorageDisplay // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CloudStorageCategoryUsage>,
  ));
}


}


/// @nodoc
mixin _$CloudStorageCategoryUsage {

 String get category; int get bytes; String get displaySize;
/// Create a copy of CloudStorageCategoryUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudStorageCategoryUsageCopyWith<CloudStorageCategoryUsage> get copyWith => _$CloudStorageCategoryUsageCopyWithImpl<CloudStorageCategoryUsage>(this as CloudStorageCategoryUsage, _$identity);

  /// Serializes this CloudStorageCategoryUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudStorageCategoryUsage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudStorageCategoryUsage&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.bytes, _this.bytes) || other.bytes == _this.bytes)&&(identical(other.displaySize, _this.displaySize) || other.displaySize == _this.displaySize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudStorageCategoryUsage;
  return Object.hash(runtimeType,_this.category,_this.bytes,_this.displaySize);
}

@override
String toString() {
  final _this = this as CloudStorageCategoryUsage;
  return 'CloudStorageCategoryUsage(category: ${_this.category}, bytes: ${_this.bytes}, displaySize: ${_this.displaySize})';
}


}

/// @nodoc
abstract mixin class $CloudStorageCategoryUsageCopyWith<$Res>  {
  factory $CloudStorageCategoryUsageCopyWith(CloudStorageCategoryUsage value, $Res Function(CloudStorageCategoryUsage) _then) = _$CloudStorageCategoryUsageCopyWithImpl;
@useResult
$Res call({
 String category, int bytes, String displaySize
});




}
/// @nodoc
class _$CloudStorageCategoryUsageCopyWithImpl<$Res>
    implements $CloudStorageCategoryUsageCopyWith<$Res> {
  _$CloudStorageCategoryUsageCopyWithImpl(this._self, this._then);

  final CloudStorageCategoryUsage _self;
  final $Res Function(CloudStorageCategoryUsage) _then;

/// Create a copy of CloudStorageCategoryUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? bytes = null,Object? displaySize = null,}) {
  return _then(CloudStorageCategoryUsage(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,displaySize: null == displaySize ? _self.displaySize : displaySize // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudStorageCategoryUsage].
extension CloudStorageCategoryUsagePatterns on CloudStorageCategoryUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudStorageCategoryUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudStorageCategoryUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudStorageCategoryUsage value)  $default,){
final _that = this;
switch (_that) {
case _CloudStorageCategoryUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudStorageCategoryUsage value)?  $default,){
final _that = this;
switch (_that) {
case _CloudStorageCategoryUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String category,  int bytes,  String displaySize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudStorageCategoryUsage() when $default != null:
return $default(_that.category,_that.bytes,_that.displaySize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String category,  int bytes,  String displaySize)  $default,) {final _that = this;
switch (_that) {
case _CloudStorageCategoryUsage():
return $default(_that.category,_that.bytes,_that.displaySize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String category,  int bytes,  String displaySize)?  $default,) {final _that = this;
switch (_that) {
case _CloudStorageCategoryUsage() when $default != null:
return $default(_that.category,_that.bytes,_that.displaySize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudStorageCategoryUsage implements CloudStorageCategoryUsage {
  const _CloudStorageCategoryUsage({required this.category, required this.bytes, required this.displaySize});
  factory _CloudStorageCategoryUsage.fromJson(Map<String, dynamic> json) => _$CloudStorageCategoryUsageFromJson(json);

@override final  String category;
@override final  int bytes;
@override final  String displaySize;

/// Create a copy of CloudStorageCategoryUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudStorageCategoryUsageCopyWith<_CloudStorageCategoryUsage> get copyWith => __$CloudStorageCategoryUsageCopyWithImpl<_CloudStorageCategoryUsage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudStorageCategoryUsageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudStorageCategoryUsage&&(identical(other.category, category) || other.category == category)&&(identical(other.bytes, bytes) || other.bytes == bytes)&&(identical(other.displaySize, displaySize) || other.displaySize == displaySize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category,bytes,displaySize);
}

@override
String toString() {
    return 'CloudStorageCategoryUsage(category: $category, bytes: $bytes, displaySize: $displaySize)';
}


}

/// @nodoc
abstract mixin class _$CloudStorageCategoryUsageCopyWith<$Res> implements $CloudStorageCategoryUsageCopyWith<$Res> {
  factory _$CloudStorageCategoryUsageCopyWith(_CloudStorageCategoryUsage value, $Res Function(_CloudStorageCategoryUsage) _then) = __$CloudStorageCategoryUsageCopyWithImpl;
@override @useResult
$Res call({
 String category, int bytes, String displaySize
});




}
/// @nodoc
class __$CloudStorageCategoryUsageCopyWithImpl<$Res>
    implements _$CloudStorageCategoryUsageCopyWith<$Res> {
  __$CloudStorageCategoryUsageCopyWithImpl(this._self, this._then);

  final _CloudStorageCategoryUsage _self;
  final $Res Function(_CloudStorageCategoryUsage) _then;

/// Create a copy of CloudStorageCategoryUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? bytes = null,Object? displaySize = null,}) {
  return _then(_CloudStorageCategoryUsage(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,displaySize: null == displaySize ? _self.displaySize : displaySize // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CloudIdResponse {

 bool get success; int get status; String get message; int get data;
/// Create a copy of CloudIdResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudIdResponseCopyWith<CloudIdResponse> get copyWith => _$CloudIdResponseCopyWithImpl<CloudIdResponse>(this as CloudIdResponse, _$identity);

  /// Serializes this CloudIdResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudIdResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudIdResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudIdResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as CloudIdResponse;
  return 'CloudIdResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $CloudIdResponseCopyWith<$Res>  {
  factory $CloudIdResponseCopyWith(CloudIdResponse value, $Res Function(CloudIdResponse) _then) = _$CloudIdResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message, int data
});




}
/// @nodoc
class _$CloudIdResponseCopyWithImpl<$Res>
    implements $CloudIdResponseCopyWith<$Res> {
  _$CloudIdResponseCopyWithImpl(this._self, this._then);

  final CloudIdResponse _self;
  final $Res Function(CloudIdResponse) _then;

/// Create a copy of CloudIdResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(CloudIdResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudIdResponse].
extension CloudIdResponsePatterns on CloudIdResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudIdResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudIdResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudIdResponse value)  $default,){
final _that = this;
switch (_that) {
case _CloudIdResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudIdResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CloudIdResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  int data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudIdResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message,  int data)  $default,) {final _that = this;
switch (_that) {
case _CloudIdResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message,  int data)?  $default,) {final _that = this;
switch (_that) {
case _CloudIdResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudIdResponse implements CloudIdResponse {
  const _CloudIdResponse({required this.success, required this.status, required this.message, required this.data});
  factory _CloudIdResponse.fromJson(Map<String, dynamic> json) => _$CloudIdResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;
@override final  int data;

/// Create a copy of CloudIdResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudIdResponseCopyWith<_CloudIdResponse> get copyWith => __$CloudIdResponseCopyWithImpl<_CloudIdResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudIdResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudIdResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'CloudIdResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CloudIdResponseCopyWith<$Res> implements $CloudIdResponseCopyWith<$Res> {
  factory _$CloudIdResponseCopyWith(_CloudIdResponse value, $Res Function(_CloudIdResponse) _then) = __$CloudIdResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message, int data
});




}
/// @nodoc
class __$CloudIdResponseCopyWithImpl<$Res>
    implements _$CloudIdResponseCopyWith<$Res> {
  __$CloudIdResponseCopyWithImpl(this._self, this._then);

  final _CloudIdResponse _self;
  final $Res Function(_CloudIdResponse) _then;

/// Create a copy of CloudIdResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,Object? data = null,}) {
  return _then(_CloudIdResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CloudFolderRequest {

 String get folderName;
/// Create a copy of CloudFolderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudFolderRequestCopyWith<CloudFolderRequest> get copyWith => _$CloudFolderRequestCopyWithImpl<CloudFolderRequest>(this as CloudFolderRequest, _$identity);

  /// Serializes this CloudFolderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudFolderRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudFolderRequest&&(identical(other.folderName, _this.folderName) || other.folderName == _this.folderName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudFolderRequest;
  return Object.hash(runtimeType,_this.folderName);
}

@override
String toString() {
  final _this = this as CloudFolderRequest;
  return 'CloudFolderRequest(folderName: ${_this.folderName})';
}


}

/// @nodoc
abstract mixin class $CloudFolderRequestCopyWith<$Res>  {
  factory $CloudFolderRequestCopyWith(CloudFolderRequest value, $Res Function(CloudFolderRequest) _then) = _$CloudFolderRequestCopyWithImpl;
@useResult
$Res call({
 String folderName
});




}
/// @nodoc
class _$CloudFolderRequestCopyWithImpl<$Res>
    implements $CloudFolderRequestCopyWith<$Res> {
  _$CloudFolderRequestCopyWithImpl(this._self, this._then);

  final CloudFolderRequest _self;
  final $Res Function(CloudFolderRequest) _then;

/// Create a copy of CloudFolderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? folderName = null,}) {
  return _then(CloudFolderRequest(
folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudFolderRequest].
extension CloudFolderRequestPatterns on CloudFolderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudFolderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudFolderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudFolderRequest value)  $default,){
final _that = this;
switch (_that) {
case _CloudFolderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudFolderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CloudFolderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String folderName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudFolderRequest() when $default != null:
return $default(_that.folderName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String folderName)  $default,) {final _that = this;
switch (_that) {
case _CloudFolderRequest():
return $default(_that.folderName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String folderName)?  $default,) {final _that = this;
switch (_that) {
case _CloudFolderRequest() when $default != null:
return $default(_that.folderName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudFolderRequest implements CloudFolderRequest {
  const _CloudFolderRequest({required this.folderName});
  factory _CloudFolderRequest.fromJson(Map<String, dynamic> json) => _$CloudFolderRequestFromJson(json);

@override final  String folderName;

/// Create a copy of CloudFolderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudFolderRequestCopyWith<_CloudFolderRequest> get copyWith => __$CloudFolderRequestCopyWithImpl<_CloudFolderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudFolderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudFolderRequest&&(identical(other.folderName, folderName) || other.folderName == folderName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,folderName);
}

@override
String toString() {
    return 'CloudFolderRequest(folderName: $folderName)';
}


}

/// @nodoc
abstract mixin class _$CloudFolderRequestCopyWith<$Res> implements $CloudFolderRequestCopyWith<$Res> {
  factory _$CloudFolderRequestCopyWith(_CloudFolderRequest value, $Res Function(_CloudFolderRequest) _then) = __$CloudFolderRequestCopyWithImpl;
@override @useResult
$Res call({
 String folderName
});




}
/// @nodoc
class __$CloudFolderRequestCopyWithImpl<$Res>
    implements _$CloudFolderRequestCopyWith<$Res> {
  __$CloudFolderRequestCopyWithImpl(this._self, this._then);

  final _CloudFolderRequest _self;
  final $Res Function(_CloudFolderRequest) _then;

/// Create a copy of CloudFolderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? folderName = null,}) {
  return _then(_CloudFolderRequest(
folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CloudItemsDeleteRequest {

 List<int> get itemIds;
/// Create a copy of CloudItemsDeleteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudItemsDeleteRequestCopyWith<CloudItemsDeleteRequest> get copyWith => _$CloudItemsDeleteRequestCopyWithImpl<CloudItemsDeleteRequest>(this as CloudItemsDeleteRequest, _$identity);

  /// Serializes this CloudItemsDeleteRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudItemsDeleteRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudItemsDeleteRequest&&const DeepCollectionEquality().equals(other.itemIds, _this.itemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudItemsDeleteRequest;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.itemIds));
}

@override
String toString() {
  final _this = this as CloudItemsDeleteRequest;
  return 'CloudItemsDeleteRequest(itemIds: ${_this.itemIds})';
}


}

/// @nodoc
abstract mixin class $CloudItemsDeleteRequestCopyWith<$Res>  {
  factory $CloudItemsDeleteRequestCopyWith(CloudItemsDeleteRequest value, $Res Function(CloudItemsDeleteRequest) _then) = _$CloudItemsDeleteRequestCopyWithImpl;
@useResult
$Res call({
 List<int> itemIds
});




}
/// @nodoc
class _$CloudItemsDeleteRequestCopyWithImpl<$Res>
    implements $CloudItemsDeleteRequestCopyWith<$Res> {
  _$CloudItemsDeleteRequestCopyWithImpl(this._self, this._then);

  final CloudItemsDeleteRequest _self;
  final $Res Function(CloudItemsDeleteRequest) _then;

/// Create a copy of CloudItemsDeleteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemIds = null,}) {
  return _then(CloudItemsDeleteRequest(
itemIds: null == itemIds ? _self.itemIds : itemIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudItemsDeleteRequest].
extension CloudItemsDeleteRequestPatterns on CloudItemsDeleteRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudItemsDeleteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudItemsDeleteRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudItemsDeleteRequest value)  $default,){
final _that = this;
switch (_that) {
case _CloudItemsDeleteRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudItemsDeleteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CloudItemsDeleteRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> itemIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudItemsDeleteRequest() when $default != null:
return $default(_that.itemIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> itemIds)  $default,) {final _that = this;
switch (_that) {
case _CloudItemsDeleteRequest():
return $default(_that.itemIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> itemIds)?  $default,) {final _that = this;
switch (_that) {
case _CloudItemsDeleteRequest() when $default != null:
return $default(_that.itemIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudItemsDeleteRequest implements CloudItemsDeleteRequest {
  const _CloudItemsDeleteRequest({required  List<int> itemIds}): _itemIds = itemIds;
  factory _CloudItemsDeleteRequest.fromJson(Map<String, dynamic> json) => _$CloudItemsDeleteRequestFromJson(json);

 final  List<int> _itemIds;
@override List<int> get itemIds {
  if (_itemIds is EqualUnmodifiableListView) return _itemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itemIds);
}


/// Create a copy of CloudItemsDeleteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudItemsDeleteRequestCopyWith<_CloudItemsDeleteRequest> get copyWith => __$CloudItemsDeleteRequestCopyWithImpl<_CloudItemsDeleteRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudItemsDeleteRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudItemsDeleteRequest&&const DeepCollectionEquality().equals(other.itemIds, _itemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_itemIds));
}

@override
String toString() {
    return 'CloudItemsDeleteRequest(itemIds: $itemIds)';
}


}

/// @nodoc
abstract mixin class _$CloudItemsDeleteRequestCopyWith<$Res> implements $CloudItemsDeleteRequestCopyWith<$Res> {
  factory _$CloudItemsDeleteRequestCopyWith(_CloudItemsDeleteRequest value, $Res Function(_CloudItemsDeleteRequest) _then) = __$CloudItemsDeleteRequestCopyWithImpl;
@override @useResult
$Res call({
 List<int> itemIds
});




}
/// @nodoc
class __$CloudItemsDeleteRequestCopyWithImpl<$Res>
    implements _$CloudItemsDeleteRequestCopyWith<$Res> {
  __$CloudItemsDeleteRequestCopyWithImpl(this._self, this._then);

  final _CloudItemsDeleteRequest _self;
  final $Res Function(_CloudItemsDeleteRequest) _then;

/// Create a copy of CloudItemsDeleteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemIds = null,}) {
  return _then(_CloudItemsDeleteRequest(
itemIds: null == itemIds ? _self._itemIds : itemIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$CloudItemsMoveRequest {

 List<int> get itemIds; int? get targetFolderId;
/// Create a copy of CloudItemsMoveRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudItemsMoveRequestCopyWith<CloudItemsMoveRequest> get copyWith => _$CloudItemsMoveRequestCopyWithImpl<CloudItemsMoveRequest>(this as CloudItemsMoveRequest, _$identity);

  /// Serializes this CloudItemsMoveRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudItemsMoveRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudItemsMoveRequest&&const DeepCollectionEquality().equals(other.itemIds, _this.itemIds)&&(identical(other.targetFolderId, _this.targetFolderId) || other.targetFolderId == _this.targetFolderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudItemsMoveRequest;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.itemIds),_this.targetFolderId);
}

@override
String toString() {
  final _this = this as CloudItemsMoveRequest;
  return 'CloudItemsMoveRequest(itemIds: ${_this.itemIds}, targetFolderId: ${_this.targetFolderId})';
}


}

/// @nodoc
abstract mixin class $CloudItemsMoveRequestCopyWith<$Res>  {
  factory $CloudItemsMoveRequestCopyWith(CloudItemsMoveRequest value, $Res Function(CloudItemsMoveRequest) _then) = _$CloudItemsMoveRequestCopyWithImpl;
@useResult
$Res call({
 List<int> itemIds, int? targetFolderId
});




}
/// @nodoc
class _$CloudItemsMoveRequestCopyWithImpl<$Res>
    implements $CloudItemsMoveRequestCopyWith<$Res> {
  _$CloudItemsMoveRequestCopyWithImpl(this._self, this._then);

  final CloudItemsMoveRequest _self;
  final $Res Function(CloudItemsMoveRequest) _then;

/// Create a copy of CloudItemsMoveRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemIds = null,Object? targetFolderId = freezed,}) {
  return _then(CloudItemsMoveRequest(
itemIds: null == itemIds ? _self.itemIds : itemIds // ignore: cast_nullable_to_non_nullable
as List<int>,targetFolderId: freezed == targetFolderId ? _self.targetFolderId : targetFolderId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudItemsMoveRequest].
extension CloudItemsMoveRequestPatterns on CloudItemsMoveRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudItemsMoveRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudItemsMoveRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudItemsMoveRequest value)  $default,){
final _that = this;
switch (_that) {
case _CloudItemsMoveRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudItemsMoveRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CloudItemsMoveRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> itemIds,  int? targetFolderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudItemsMoveRequest() when $default != null:
return $default(_that.itemIds,_that.targetFolderId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> itemIds,  int? targetFolderId)  $default,) {final _that = this;
switch (_that) {
case _CloudItemsMoveRequest():
return $default(_that.itemIds,_that.targetFolderId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> itemIds,  int? targetFolderId)?  $default,) {final _that = this;
switch (_that) {
case _CloudItemsMoveRequest() when $default != null:
return $default(_that.itemIds,_that.targetFolderId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudItemsMoveRequest implements CloudItemsMoveRequest {
  const _CloudItemsMoveRequest({required  List<int> itemIds, this.targetFolderId}): _itemIds = itemIds;
  factory _CloudItemsMoveRequest.fromJson(Map<String, dynamic> json) => _$CloudItemsMoveRequestFromJson(json);

 final  List<int> _itemIds;
@override List<int> get itemIds {
  if (_itemIds is EqualUnmodifiableListView) return _itemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itemIds);
}

@override final  int? targetFolderId;

/// Create a copy of CloudItemsMoveRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudItemsMoveRequestCopyWith<_CloudItemsMoveRequest> get copyWith => __$CloudItemsMoveRequestCopyWithImpl<_CloudItemsMoveRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudItemsMoveRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudItemsMoveRequest&&const DeepCollectionEquality().equals(other.itemIds, _itemIds)&&(identical(other.targetFolderId, targetFolderId) || other.targetFolderId == targetFolderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_itemIds),targetFolderId);
}

@override
String toString() {
    return 'CloudItemsMoveRequest(itemIds: $itemIds, targetFolderId: $targetFolderId)';
}


}

/// @nodoc
abstract mixin class _$CloudItemsMoveRequestCopyWith<$Res> implements $CloudItemsMoveRequestCopyWith<$Res> {
  factory _$CloudItemsMoveRequestCopyWith(_CloudItemsMoveRequest value, $Res Function(_CloudItemsMoveRequest) _then) = __$CloudItemsMoveRequestCopyWithImpl;
@override @useResult
$Res call({
 List<int> itemIds, int? targetFolderId
});




}
/// @nodoc
class __$CloudItemsMoveRequestCopyWithImpl<$Res>
    implements _$CloudItemsMoveRequestCopyWith<$Res> {
  __$CloudItemsMoveRequestCopyWithImpl(this._self, this._then);

  final _CloudItemsMoveRequest _self;
  final $Res Function(_CloudItemsMoveRequest) _then;

/// Create a copy of CloudItemsMoveRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemIds = null,Object? targetFolderId = freezed,}) {
  return _then(_CloudItemsMoveRequest(
itemIds: null == itemIds ? _self._itemIds : itemIds // ignore: cast_nullable_to_non_nullable
as List<int>,targetFolderId: freezed == targetFolderId ? _self.targetFolderId : targetFolderId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$CloudLinkCreateRequest {

 String get linkUrl; String get itemName;
/// Create a copy of CloudLinkCreateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CloudLinkCreateRequestCopyWith<CloudLinkCreateRequest> get copyWith => _$CloudLinkCreateRequestCopyWithImpl<CloudLinkCreateRequest>(this as CloudLinkCreateRequest, _$identity);

  /// Serializes this CloudLinkCreateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CloudLinkCreateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CloudLinkCreateRequest&&(identical(other.linkUrl, _this.linkUrl) || other.linkUrl == _this.linkUrl)&&(identical(other.itemName, _this.itemName) || other.itemName == _this.itemName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CloudLinkCreateRequest;
  return Object.hash(runtimeType,_this.linkUrl,_this.itemName);
}

@override
String toString() {
  final _this = this as CloudLinkCreateRequest;
  return 'CloudLinkCreateRequest(linkUrl: ${_this.linkUrl}, itemName: ${_this.itemName})';
}


}

/// @nodoc
abstract mixin class $CloudLinkCreateRequestCopyWith<$Res>  {
  factory $CloudLinkCreateRequestCopyWith(CloudLinkCreateRequest value, $Res Function(CloudLinkCreateRequest) _then) = _$CloudLinkCreateRequestCopyWithImpl;
@useResult
$Res call({
 String linkUrl, String itemName
});




}
/// @nodoc
class _$CloudLinkCreateRequestCopyWithImpl<$Res>
    implements $CloudLinkCreateRequestCopyWith<$Res> {
  _$CloudLinkCreateRequestCopyWithImpl(this._self, this._then);

  final CloudLinkCreateRequest _self;
  final $Res Function(CloudLinkCreateRequest) _then;

/// Create a copy of CloudLinkCreateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? linkUrl = null,Object? itemName = null,}) {
  return _then(CloudLinkCreateRequest(
linkUrl: null == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CloudLinkCreateRequest].
extension CloudLinkCreateRequestPatterns on CloudLinkCreateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CloudLinkCreateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CloudLinkCreateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CloudLinkCreateRequest value)  $default,){
final _that = this;
switch (_that) {
case _CloudLinkCreateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CloudLinkCreateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CloudLinkCreateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String linkUrl,  String itemName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CloudLinkCreateRequest() when $default != null:
return $default(_that.linkUrl,_that.itemName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String linkUrl,  String itemName)  $default,) {final _that = this;
switch (_that) {
case _CloudLinkCreateRequest():
return $default(_that.linkUrl,_that.itemName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String linkUrl,  String itemName)?  $default,) {final _that = this;
switch (_that) {
case _CloudLinkCreateRequest() when $default != null:
return $default(_that.linkUrl,_that.itemName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CloudLinkCreateRequest implements CloudLinkCreateRequest {
  const _CloudLinkCreateRequest({required this.linkUrl, required this.itemName});
  factory _CloudLinkCreateRequest.fromJson(Map<String, dynamic> json) => _$CloudLinkCreateRequestFromJson(json);

@override final  String linkUrl;
@override final  String itemName;

/// Create a copy of CloudLinkCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CloudLinkCreateRequestCopyWith<_CloudLinkCreateRequest> get copyWith => __$CloudLinkCreateRequestCopyWithImpl<_CloudLinkCreateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CloudLinkCreateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CloudLinkCreateRequest&&(identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl)&&(identical(other.itemName, itemName) || other.itemName == itemName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,linkUrl,itemName);
}

@override
String toString() {
    return 'CloudLinkCreateRequest(linkUrl: $linkUrl, itemName: $itemName)';
}


}

/// @nodoc
abstract mixin class _$CloudLinkCreateRequestCopyWith<$Res> implements $CloudLinkCreateRequestCopyWith<$Res> {
  factory _$CloudLinkCreateRequestCopyWith(_CloudLinkCreateRequest value, $Res Function(_CloudLinkCreateRequest) _then) = __$CloudLinkCreateRequestCopyWithImpl;
@override @useResult
$Res call({
 String linkUrl, String itemName
});




}
/// @nodoc
class __$CloudLinkCreateRequestCopyWithImpl<$Res>
    implements _$CloudLinkCreateRequestCopyWith<$Res> {
  __$CloudLinkCreateRequestCopyWithImpl(this._self, this._then);

  final _CloudLinkCreateRequest _self;
  final $Res Function(_CloudLinkCreateRequest) _then;

/// Create a copy of CloudLinkCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? linkUrl = null,Object? itemName = null,}) {
  return _then(_CloudLinkCreateRequest(
linkUrl: null == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
