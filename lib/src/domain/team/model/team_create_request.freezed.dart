// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_create_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamCreateRequest {

 String get teamName; String get teamType; String? get description; String? get establishedOn; String? get teamImageUrl;
/// Create a copy of TeamCreateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamCreateRequestCopyWith<TeamCreateRequest> get copyWith => _$TeamCreateRequestCopyWithImpl<TeamCreateRequest>(this as TeamCreateRequest, _$identity);

  /// Serializes this TeamCreateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TeamCreateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamCreateRequest&&(identical(other.teamName, _this.teamName) || other.teamName == _this.teamName)&&(identical(other.teamType, _this.teamType) || other.teamType == _this.teamType)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.establishedOn, _this.establishedOn) || other.establishedOn == _this.establishedOn)&&(identical(other.teamImageUrl, _this.teamImageUrl) || other.teamImageUrl == _this.teamImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TeamCreateRequest;
  return Object.hash(runtimeType,_this.teamName,_this.teamType,_this.description,_this.establishedOn,_this.teamImageUrl);
}

@override
String toString() {
  final _this = this as TeamCreateRequest;
  return 'TeamCreateRequest(teamName: ${_this.teamName}, teamType: ${_this.teamType}, description: ${_this.description}, establishedOn: ${_this.establishedOn}, teamImageUrl: ${_this.teamImageUrl})';
}


}

/// @nodoc
abstract mixin class $TeamCreateRequestCopyWith<$Res>  {
  factory $TeamCreateRequestCopyWith(TeamCreateRequest value, $Res Function(TeamCreateRequest) _then) = _$TeamCreateRequestCopyWithImpl;
@useResult
$Res call({
 String teamName, String teamType, String? description, String? establishedOn, String? teamImageUrl
});




}
/// @nodoc
class _$TeamCreateRequestCopyWithImpl<$Res>
    implements $TeamCreateRequestCopyWith<$Res> {
  _$TeamCreateRequestCopyWithImpl(this._self, this._then);

  final TeamCreateRequest _self;
  final $Res Function(TeamCreateRequest) _then;

/// Create a copy of TeamCreateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamName = null,Object? teamType = null,Object? description = freezed,Object? establishedOn = freezed,Object? teamImageUrl = freezed,}) {
  return _then(TeamCreateRequest(
teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,teamType: null == teamType ? _self.teamType : teamType // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,establishedOn: freezed == establishedOn ? _self.establishedOn : establishedOn // ignore: cast_nullable_to_non_nullable
as String?,teamImageUrl: freezed == teamImageUrl ? _self.teamImageUrl : teamImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamCreateRequest].
extension TeamCreateRequestPatterns on TeamCreateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamCreateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamCreateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamCreateRequest value)  $default,){
final _that = this;
switch (_that) {
case _TeamCreateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamCreateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TeamCreateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String teamName,  String teamType,  String? description,  String? establishedOn,  String? teamImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamCreateRequest() when $default != null:
return $default(_that.teamName,_that.teamType,_that.description,_that.establishedOn,_that.teamImageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String teamName,  String teamType,  String? description,  String? establishedOn,  String? teamImageUrl)  $default,) {final _that = this;
switch (_that) {
case _TeamCreateRequest():
return $default(_that.teamName,_that.teamType,_that.description,_that.establishedOn,_that.teamImageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String teamName,  String teamType,  String? description,  String? establishedOn,  String? teamImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _TeamCreateRequest() when $default != null:
return $default(_that.teamName,_that.teamType,_that.description,_that.establishedOn,_that.teamImageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamCreateRequest implements TeamCreateRequest {
  const _TeamCreateRequest({required this.teamName, required this.teamType, this.description, this.establishedOn, this.teamImageUrl});
  factory _TeamCreateRequest.fromJson(Map<String, dynamic> json) => _$TeamCreateRequestFromJson(json);

@override final  String teamName;
@override final  String teamType;
@override final  String? description;
@override final  String? establishedOn;
@override final  String? teamImageUrl;

/// Create a copy of TeamCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamCreateRequestCopyWith<_TeamCreateRequest> get copyWith => __$TeamCreateRequestCopyWithImpl<_TeamCreateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamCreateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamCreateRequest&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.teamType, teamType) || other.teamType == teamType)&&(identical(other.description, description) || other.description == description)&&(identical(other.establishedOn, establishedOn) || other.establishedOn == establishedOn)&&(identical(other.teamImageUrl, teamImageUrl) || other.teamImageUrl == teamImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,teamName,teamType,description,establishedOn,teamImageUrl);
}

@override
String toString() {
    return 'TeamCreateRequest(teamName: $teamName, teamType: $teamType, description: $description, establishedOn: $establishedOn, teamImageUrl: $teamImageUrl)';
}


}

/// @nodoc
abstract mixin class _$TeamCreateRequestCopyWith<$Res> implements $TeamCreateRequestCopyWith<$Res> {
  factory _$TeamCreateRequestCopyWith(_TeamCreateRequest value, $Res Function(_TeamCreateRequest) _then) = __$TeamCreateRequestCopyWithImpl;
@override @useResult
$Res call({
 String teamName, String teamType, String? description, String? establishedOn, String? teamImageUrl
});




}
/// @nodoc
class __$TeamCreateRequestCopyWithImpl<$Res>
    implements _$TeamCreateRequestCopyWith<$Res> {
  __$TeamCreateRequestCopyWithImpl(this._self, this._then);

  final _TeamCreateRequest _self;
  final $Res Function(_TeamCreateRequest) _then;

/// Create a copy of TeamCreateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamName = null,Object? teamType = null,Object? description = freezed,Object? establishedOn = freezed,Object? teamImageUrl = freezed,}) {
  return _then(_TeamCreateRequest(
teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,teamType: null == teamType ? _self.teamType : teamType // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,establishedOn: freezed == establishedOn ? _self.establishedOn : establishedOn // ignore: cast_nullable_to_non_nullable
as String?,teamImageUrl: freezed == teamImageUrl ? _self.teamImageUrl : teamImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
