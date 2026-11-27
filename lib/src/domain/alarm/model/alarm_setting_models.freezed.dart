// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_setting_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlarmSettingsResponse {

 bool get success; int get status; String? get message; AlarmSettingsData get data;
/// Create a copy of AlarmSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmSettingsResponseCopyWith<AlarmSettingsResponse> get copyWith => _$AlarmSettingsResponseCopyWithImpl<AlarmSettingsResponse>(this as AlarmSettingsResponse, _$identity);

  /// Serializes this AlarmSettingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlarmSettingsResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmSettingsResponse&&(identical(other.success, _this.success) || other.success == _this.success)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.data, _this.data) || other.data == _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlarmSettingsResponse;
  return Object.hash(runtimeType,_this.success,_this.status,_this.message,_this.data);
}

@override
String toString() {
  final _this = this as AlarmSettingsResponse;
  return 'AlarmSettingsResponse(success: ${_this.success}, status: ${_this.status}, message: ${_this.message}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $AlarmSettingsResponseCopyWith<$Res>  {
  factory $AlarmSettingsResponseCopyWith(AlarmSettingsResponse value, $Res Function(AlarmSettingsResponse) _then) = _$AlarmSettingsResponseCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String? message, AlarmSettingsData data
});


$AlarmSettingsDataCopyWith<$Res> get data;

}
/// @nodoc
class _$AlarmSettingsResponseCopyWithImpl<$Res>
    implements $AlarmSettingsResponseCopyWith<$Res> {
  _$AlarmSettingsResponseCopyWithImpl(this._self, this._then);

  final AlarmSettingsResponse _self;
  final $Res Function(AlarmSettingsResponse) _then;

/// Create a copy of AlarmSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(AlarmSettingsResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AlarmSettingsData,
  ));
}
/// Create a copy of AlarmSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlarmSettingsDataCopyWith<$Res> get data {
  
  return $AlarmSettingsDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AlarmSettingsResponse].
extension AlarmSettingsResponsePatterns on AlarmSettingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmSettingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmSettingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _AlarmSettingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmSettingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  AlarmSettingsData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String? message,  AlarmSettingsData data)  $default,) {final _that = this;
switch (_that) {
case _AlarmSettingsResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String? message,  AlarmSettingsData data)?  $default,) {final _that = this;
switch (_that) {
case _AlarmSettingsResponse() when $default != null:
return $default(_that.success,_that.status,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlarmSettingsResponse implements AlarmSettingsResponse {
  const _AlarmSettingsResponse({required this.success, required this.status, this.message, required this.data});
  factory _AlarmSettingsResponse.fromJson(Map<String, dynamic> json) => _$AlarmSettingsResponseFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String? message;
@override final  AlarmSettingsData data;

/// Create a copy of AlarmSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmSettingsResponseCopyWith<_AlarmSettingsResponse> get copyWith => __$AlarmSettingsResponseCopyWithImpl<_AlarmSettingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmSettingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmSettingsResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,success,status,message,data);
}

@override
String toString() {
    return 'AlarmSettingsResponse(success: $success, status: $status, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AlarmSettingsResponseCopyWith<$Res> implements $AlarmSettingsResponseCopyWith<$Res> {
  factory _$AlarmSettingsResponseCopyWith(_AlarmSettingsResponse value, $Res Function(_AlarmSettingsResponse) _then) = __$AlarmSettingsResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String? message, AlarmSettingsData data
});


@override $AlarmSettingsDataCopyWith<$Res> get data;

}
/// @nodoc
class __$AlarmSettingsResponseCopyWithImpl<$Res>
    implements _$AlarmSettingsResponseCopyWith<$Res> {
  __$AlarmSettingsResponseCopyWithImpl(this._self, this._then);

  final _AlarmSettingsResponse _self;
  final $Res Function(_AlarmSettingsResponse) _then;

/// Create a copy of AlarmSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = freezed,Object? data = null,}) {
  return _then(_AlarmSettingsResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AlarmSettingsData,
  ));
}

/// Create a copy of AlarmSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlarmSettingsDataCopyWith<$Res> get data {
  
  return $AlarmSettingsDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AlarmSettingsData {

 bool get allNotification; bool get activitySection; bool get calendarSchedule; bool get teamActivitySpace; bool get activityCommentMention; bool get collaborationSection; bool get notice; bool get pollAndMeetit; bool get progressResult; bool get collaborationCommentMention; bool get chatMessage; bool get teamManageSection; bool get positionChange; bool? get memberChange;@JsonKey(name: 'isManager', readValue: _readIsManager) bool get isManager;
/// Create a copy of AlarmSettingsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmSettingsDataCopyWith<AlarmSettingsData> get copyWith => _$AlarmSettingsDataCopyWithImpl<AlarmSettingsData>(this as AlarmSettingsData, _$identity);

  /// Serializes this AlarmSettingsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlarmSettingsData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmSettingsData&&(identical(other.allNotification, _this.allNotification) || other.allNotification == _this.allNotification)&&(identical(other.activitySection, _this.activitySection) || other.activitySection == _this.activitySection)&&(identical(other.calendarSchedule, _this.calendarSchedule) || other.calendarSchedule == _this.calendarSchedule)&&(identical(other.teamActivitySpace, _this.teamActivitySpace) || other.teamActivitySpace == _this.teamActivitySpace)&&(identical(other.activityCommentMention, _this.activityCommentMention) || other.activityCommentMention == _this.activityCommentMention)&&(identical(other.collaborationSection, _this.collaborationSection) || other.collaborationSection == _this.collaborationSection)&&(identical(other.notice, _this.notice) || other.notice == _this.notice)&&(identical(other.pollAndMeetit, _this.pollAndMeetit) || other.pollAndMeetit == _this.pollAndMeetit)&&(identical(other.progressResult, _this.progressResult) || other.progressResult == _this.progressResult)&&(identical(other.collaborationCommentMention, _this.collaborationCommentMention) || other.collaborationCommentMention == _this.collaborationCommentMention)&&(identical(other.chatMessage, _this.chatMessage) || other.chatMessage == _this.chatMessage)&&(identical(other.teamManageSection, _this.teamManageSection) || other.teamManageSection == _this.teamManageSection)&&(identical(other.positionChange, _this.positionChange) || other.positionChange == _this.positionChange)&&(identical(other.memberChange, _this.memberChange) || other.memberChange == _this.memberChange)&&(identical(other.isManager, _this.isManager) || other.isManager == _this.isManager));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlarmSettingsData;
  return Object.hash(runtimeType,_this.allNotification,_this.activitySection,_this.calendarSchedule,_this.teamActivitySpace,_this.activityCommentMention,_this.collaborationSection,_this.notice,_this.pollAndMeetit,_this.progressResult,_this.collaborationCommentMention,_this.chatMessage,_this.teamManageSection,_this.positionChange,_this.memberChange,_this.isManager);
}

@override
String toString() {
  final _this = this as AlarmSettingsData;
  return 'AlarmSettingsData(allNotification: ${_this.allNotification}, activitySection: ${_this.activitySection}, calendarSchedule: ${_this.calendarSchedule}, teamActivitySpace: ${_this.teamActivitySpace}, activityCommentMention: ${_this.activityCommentMention}, collaborationSection: ${_this.collaborationSection}, notice: ${_this.notice}, pollAndMeetit: ${_this.pollAndMeetit}, progressResult: ${_this.progressResult}, collaborationCommentMention: ${_this.collaborationCommentMention}, chatMessage: ${_this.chatMessage}, teamManageSection: ${_this.teamManageSection}, positionChange: ${_this.positionChange}, memberChange: ${_this.memberChange}, isManager: ${_this.isManager})';
}


}

/// @nodoc
abstract mixin class $AlarmSettingsDataCopyWith<$Res>  {
  factory $AlarmSettingsDataCopyWith(AlarmSettingsData value, $Res Function(AlarmSettingsData) _then) = _$AlarmSettingsDataCopyWithImpl;
@useResult
$Res call({
 bool allNotification, bool activitySection, bool calendarSchedule, bool teamActivitySpace, bool activityCommentMention, bool collaborationSection, bool notice, bool pollAndMeetit, bool progressResult, bool collaborationCommentMention, bool chatMessage, bool teamManageSection, bool positionChange, bool? memberChange,@JsonKey(name: 'isManager', readValue: _readIsManager) bool isManager
});




}
/// @nodoc
class _$AlarmSettingsDataCopyWithImpl<$Res>
    implements $AlarmSettingsDataCopyWith<$Res> {
  _$AlarmSettingsDataCopyWithImpl(this._self, this._then);

  final AlarmSettingsData _self;
  final $Res Function(AlarmSettingsData) _then;

/// Create a copy of AlarmSettingsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allNotification = null,Object? activitySection = null,Object? calendarSchedule = null,Object? teamActivitySpace = null,Object? activityCommentMention = null,Object? collaborationSection = null,Object? notice = null,Object? pollAndMeetit = null,Object? progressResult = null,Object? collaborationCommentMention = null,Object? chatMessage = null,Object? teamManageSection = null,Object? positionChange = null,Object? memberChange = freezed,Object? isManager = null,}) {
  return _then(AlarmSettingsData(
allNotification: null == allNotification ? _self.allNotification : allNotification // ignore: cast_nullable_to_non_nullable
as bool,activitySection: null == activitySection ? _self.activitySection : activitySection // ignore: cast_nullable_to_non_nullable
as bool,calendarSchedule: null == calendarSchedule ? _self.calendarSchedule : calendarSchedule // ignore: cast_nullable_to_non_nullable
as bool,teamActivitySpace: null == teamActivitySpace ? _self.teamActivitySpace : teamActivitySpace // ignore: cast_nullable_to_non_nullable
as bool,activityCommentMention: null == activityCommentMention ? _self.activityCommentMention : activityCommentMention // ignore: cast_nullable_to_non_nullable
as bool,collaborationSection: null == collaborationSection ? _self.collaborationSection : collaborationSection // ignore: cast_nullable_to_non_nullable
as bool,notice: null == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as bool,pollAndMeetit: null == pollAndMeetit ? _self.pollAndMeetit : pollAndMeetit // ignore: cast_nullable_to_non_nullable
as bool,progressResult: null == progressResult ? _self.progressResult : progressResult // ignore: cast_nullable_to_non_nullable
as bool,collaborationCommentMention: null == collaborationCommentMention ? _self.collaborationCommentMention : collaborationCommentMention // ignore: cast_nullable_to_non_nullable
as bool,chatMessage: null == chatMessage ? _self.chatMessage : chatMessage // ignore: cast_nullable_to_non_nullable
as bool,teamManageSection: null == teamManageSection ? _self.teamManageSection : teamManageSection // ignore: cast_nullable_to_non_nullable
as bool,positionChange: null == positionChange ? _self.positionChange : positionChange // ignore: cast_nullable_to_non_nullable
as bool,memberChange: freezed == memberChange ? _self.memberChange : memberChange // ignore: cast_nullable_to_non_nullable
as bool?,isManager: null == isManager ? _self.isManager : isManager // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AlarmSettingsData].
extension AlarmSettingsDataPatterns on AlarmSettingsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmSettingsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmSettingsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmSettingsData value)  $default,){
final _that = this;
switch (_that) {
case _AlarmSettingsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmSettingsData value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmSettingsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool allNotification,  bool activitySection,  bool calendarSchedule,  bool teamActivitySpace,  bool activityCommentMention,  bool collaborationSection,  bool notice,  bool pollAndMeetit,  bool progressResult,  bool collaborationCommentMention,  bool chatMessage,  bool teamManageSection,  bool positionChange,  bool? memberChange, @JsonKey(name: 'isManager', readValue: _readIsManager)  bool isManager)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmSettingsData() when $default != null:
return $default(_that.allNotification,_that.activitySection,_that.calendarSchedule,_that.teamActivitySpace,_that.activityCommentMention,_that.collaborationSection,_that.notice,_that.pollAndMeetit,_that.progressResult,_that.collaborationCommentMention,_that.chatMessage,_that.teamManageSection,_that.positionChange,_that.memberChange,_that.isManager);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool allNotification,  bool activitySection,  bool calendarSchedule,  bool teamActivitySpace,  bool activityCommentMention,  bool collaborationSection,  bool notice,  bool pollAndMeetit,  bool progressResult,  bool collaborationCommentMention,  bool chatMessage,  bool teamManageSection,  bool positionChange,  bool? memberChange, @JsonKey(name: 'isManager', readValue: _readIsManager)  bool isManager)  $default,) {final _that = this;
switch (_that) {
case _AlarmSettingsData():
return $default(_that.allNotification,_that.activitySection,_that.calendarSchedule,_that.teamActivitySpace,_that.activityCommentMention,_that.collaborationSection,_that.notice,_that.pollAndMeetit,_that.progressResult,_that.collaborationCommentMention,_that.chatMessage,_that.teamManageSection,_that.positionChange,_that.memberChange,_that.isManager);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool allNotification,  bool activitySection,  bool calendarSchedule,  bool teamActivitySpace,  bool activityCommentMention,  bool collaborationSection,  bool notice,  bool pollAndMeetit,  bool progressResult,  bool collaborationCommentMention,  bool chatMessage,  bool teamManageSection,  bool positionChange,  bool? memberChange, @JsonKey(name: 'isManager', readValue: _readIsManager)  bool isManager)?  $default,) {final _that = this;
switch (_that) {
case _AlarmSettingsData() when $default != null:
return $default(_that.allNotification,_that.activitySection,_that.calendarSchedule,_that.teamActivitySpace,_that.activityCommentMention,_that.collaborationSection,_that.notice,_that.pollAndMeetit,_that.progressResult,_that.collaborationCommentMention,_that.chatMessage,_that.teamManageSection,_that.positionChange,_that.memberChange,_that.isManager);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlarmSettingsData implements AlarmSettingsData {
  const _AlarmSettingsData({required this.allNotification, required this.activitySection, required this.calendarSchedule, required this.teamActivitySpace, required this.activityCommentMention, required this.collaborationSection, required this.notice, required this.pollAndMeetit, required this.progressResult, required this.collaborationCommentMention, required this.chatMessage, required this.teamManageSection, required this.positionChange, this.memberChange, @JsonKey(name: 'isManager', readValue: _readIsManager) required this.isManager});
  factory _AlarmSettingsData.fromJson(Map<String, dynamic> json) => _$AlarmSettingsDataFromJson(json);

@override final  bool allNotification;
@override final  bool activitySection;
@override final  bool calendarSchedule;
@override final  bool teamActivitySpace;
@override final  bool activityCommentMention;
@override final  bool collaborationSection;
@override final  bool notice;
@override final  bool pollAndMeetit;
@override final  bool progressResult;
@override final  bool collaborationCommentMention;
@override final  bool chatMessage;
@override final  bool teamManageSection;
@override final  bool positionChange;
@override final  bool? memberChange;
@override@JsonKey(name: 'isManager', readValue: _readIsManager) final  bool isManager;

/// Create a copy of AlarmSettingsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmSettingsDataCopyWith<_AlarmSettingsData> get copyWith => __$AlarmSettingsDataCopyWithImpl<_AlarmSettingsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmSettingsDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmSettingsData&&(identical(other.allNotification, allNotification) || other.allNotification == allNotification)&&(identical(other.activitySection, activitySection) || other.activitySection == activitySection)&&(identical(other.calendarSchedule, calendarSchedule) || other.calendarSchedule == calendarSchedule)&&(identical(other.teamActivitySpace, teamActivitySpace) || other.teamActivitySpace == teamActivitySpace)&&(identical(other.activityCommentMention, activityCommentMention) || other.activityCommentMention == activityCommentMention)&&(identical(other.collaborationSection, collaborationSection) || other.collaborationSection == collaborationSection)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.pollAndMeetit, pollAndMeetit) || other.pollAndMeetit == pollAndMeetit)&&(identical(other.progressResult, progressResult) || other.progressResult == progressResult)&&(identical(other.collaborationCommentMention, collaborationCommentMention) || other.collaborationCommentMention == collaborationCommentMention)&&(identical(other.chatMessage, chatMessage) || other.chatMessage == chatMessage)&&(identical(other.teamManageSection, teamManageSection) || other.teamManageSection == teamManageSection)&&(identical(other.positionChange, positionChange) || other.positionChange == positionChange)&&(identical(other.memberChange, memberChange) || other.memberChange == memberChange)&&(identical(other.isManager, isManager) || other.isManager == isManager));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,allNotification,activitySection,calendarSchedule,teamActivitySpace,activityCommentMention,collaborationSection,notice,pollAndMeetit,progressResult,collaborationCommentMention,chatMessage,teamManageSection,positionChange,memberChange,isManager);
}

@override
String toString() {
    return 'AlarmSettingsData(allNotification: $allNotification, activitySection: $activitySection, calendarSchedule: $calendarSchedule, teamActivitySpace: $teamActivitySpace, activityCommentMention: $activityCommentMention, collaborationSection: $collaborationSection, notice: $notice, pollAndMeetit: $pollAndMeetit, progressResult: $progressResult, collaborationCommentMention: $collaborationCommentMention, chatMessage: $chatMessage, teamManageSection: $teamManageSection, positionChange: $positionChange, memberChange: $memberChange, isManager: $isManager)';
}


}

/// @nodoc
abstract mixin class _$AlarmSettingsDataCopyWith<$Res> implements $AlarmSettingsDataCopyWith<$Res> {
  factory _$AlarmSettingsDataCopyWith(_AlarmSettingsData value, $Res Function(_AlarmSettingsData) _then) = __$AlarmSettingsDataCopyWithImpl;
@override @useResult
$Res call({
 bool allNotification, bool activitySection, bool calendarSchedule, bool teamActivitySpace, bool activityCommentMention, bool collaborationSection, bool notice, bool pollAndMeetit, bool progressResult, bool collaborationCommentMention, bool chatMessage, bool teamManageSection, bool positionChange, bool? memberChange,@JsonKey(name: 'isManager', readValue: _readIsManager) bool isManager
});




}
/// @nodoc
class __$AlarmSettingsDataCopyWithImpl<$Res>
    implements _$AlarmSettingsDataCopyWith<$Res> {
  __$AlarmSettingsDataCopyWithImpl(this._self, this._then);

  final _AlarmSettingsData _self;
  final $Res Function(_AlarmSettingsData) _then;

/// Create a copy of AlarmSettingsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allNotification = null,Object? activitySection = null,Object? calendarSchedule = null,Object? teamActivitySpace = null,Object? activityCommentMention = null,Object? collaborationSection = null,Object? notice = null,Object? pollAndMeetit = null,Object? progressResult = null,Object? collaborationCommentMention = null,Object? chatMessage = null,Object? teamManageSection = null,Object? positionChange = null,Object? memberChange = freezed,Object? isManager = null,}) {
  return _then(_AlarmSettingsData(
allNotification: null == allNotification ? _self.allNotification : allNotification // ignore: cast_nullable_to_non_nullable
as bool,activitySection: null == activitySection ? _self.activitySection : activitySection // ignore: cast_nullable_to_non_nullable
as bool,calendarSchedule: null == calendarSchedule ? _self.calendarSchedule : calendarSchedule // ignore: cast_nullable_to_non_nullable
as bool,teamActivitySpace: null == teamActivitySpace ? _self.teamActivitySpace : teamActivitySpace // ignore: cast_nullable_to_non_nullable
as bool,activityCommentMention: null == activityCommentMention ? _self.activityCommentMention : activityCommentMention // ignore: cast_nullable_to_non_nullable
as bool,collaborationSection: null == collaborationSection ? _self.collaborationSection : collaborationSection // ignore: cast_nullable_to_non_nullable
as bool,notice: null == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as bool,pollAndMeetit: null == pollAndMeetit ? _self.pollAndMeetit : pollAndMeetit // ignore: cast_nullable_to_non_nullable
as bool,progressResult: null == progressResult ? _self.progressResult : progressResult // ignore: cast_nullable_to_non_nullable
as bool,collaborationCommentMention: null == collaborationCommentMention ? _self.collaborationCommentMention : collaborationCommentMention // ignore: cast_nullable_to_non_nullable
as bool,chatMessage: null == chatMessage ? _self.chatMessage : chatMessage // ignore: cast_nullable_to_non_nullable
as bool,teamManageSection: null == teamManageSection ? _self.teamManageSection : teamManageSection // ignore: cast_nullable_to_non_nullable
as bool,positionChange: null == positionChange ? _self.positionChange : positionChange // ignore: cast_nullable_to_non_nullable
as bool,memberChange: freezed == memberChange ? _self.memberChange : memberChange // ignore: cast_nullable_to_non_nullable
as bool?,isManager: null == isManager ? _self.isManager : isManager // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
