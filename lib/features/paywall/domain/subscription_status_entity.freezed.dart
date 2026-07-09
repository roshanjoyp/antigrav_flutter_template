// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_status_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubscriptionStatusEntity {

/// Whether the user currently has at least one active entitlement.
 bool get isSubscribed;/// Identifiers of all currently active entitlements
/// (e.g. `['premium']`). Empty when [isSubscribed] is `false`.
 List<String> get activeEntitlementIds;/// URL of the store's subscription-management page for this user,
/// if the provider exposes one. Useful for a "Manage subscription"
/// button.
 String? get managementUrl;
/// Create a copy of SubscriptionStatusEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionStatusEntityCopyWith<SubscriptionStatusEntity> get copyWith => _$SubscriptionStatusEntityCopyWithImpl<SubscriptionStatusEntity>(this as SubscriptionStatusEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionStatusEntity&&(identical(other.isSubscribed, isSubscribed) || other.isSubscribed == isSubscribed)&&const DeepCollectionEquality().equals(other.activeEntitlementIds, activeEntitlementIds)&&(identical(other.managementUrl, managementUrl) || other.managementUrl == managementUrl));
}


@override
int get hashCode => Object.hash(runtimeType,isSubscribed,const DeepCollectionEquality().hash(activeEntitlementIds),managementUrl);

@override
String toString() {
  return 'SubscriptionStatusEntity(isSubscribed: $isSubscribed, activeEntitlementIds: $activeEntitlementIds, managementUrl: $managementUrl)';
}


}

/// @nodoc
abstract mixin class $SubscriptionStatusEntityCopyWith<$Res>  {
  factory $SubscriptionStatusEntityCopyWith(SubscriptionStatusEntity value, $Res Function(SubscriptionStatusEntity) _then) = _$SubscriptionStatusEntityCopyWithImpl;
@useResult
$Res call({
 bool isSubscribed, List<String> activeEntitlementIds, String? managementUrl
});




}
/// @nodoc
class _$SubscriptionStatusEntityCopyWithImpl<$Res>
    implements $SubscriptionStatusEntityCopyWith<$Res> {
  _$SubscriptionStatusEntityCopyWithImpl(this._self, this._then);

  final SubscriptionStatusEntity _self;
  final $Res Function(SubscriptionStatusEntity) _then;

/// Create a copy of SubscriptionStatusEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSubscribed = null,Object? activeEntitlementIds = null,Object? managementUrl = freezed,}) {
  return _then(_self.copyWith(
isSubscribed: null == isSubscribed ? _self.isSubscribed : isSubscribed // ignore: cast_nullable_to_non_nullable
as bool,activeEntitlementIds: null == activeEntitlementIds ? _self.activeEntitlementIds : activeEntitlementIds // ignore: cast_nullable_to_non_nullable
as List<String>,managementUrl: freezed == managementUrl ? _self.managementUrl : managementUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionStatusEntity].
extension SubscriptionStatusEntityPatterns on SubscriptionStatusEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionStatusEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionStatusEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionStatusEntity value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionStatusEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionStatusEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionStatusEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSubscribed,  List<String> activeEntitlementIds,  String? managementUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionStatusEntity() when $default != null:
return $default(_that.isSubscribed,_that.activeEntitlementIds,_that.managementUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSubscribed,  List<String> activeEntitlementIds,  String? managementUrl)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionStatusEntity():
return $default(_that.isSubscribed,_that.activeEntitlementIds,_that.managementUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSubscribed,  List<String> activeEntitlementIds,  String? managementUrl)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionStatusEntity() when $default != null:
return $default(_that.isSubscribed,_that.activeEntitlementIds,_that.managementUrl);case _:
  return null;

}
}

}

/// @nodoc


class _SubscriptionStatusEntity implements SubscriptionStatusEntity {
  const _SubscriptionStatusEntity({this.isSubscribed = false, final  List<String> activeEntitlementIds = const <String>[], this.managementUrl}): _activeEntitlementIds = activeEntitlementIds;
  

/// Whether the user currently has at least one active entitlement.
@override@JsonKey() final  bool isSubscribed;
/// Identifiers of all currently active entitlements
/// (e.g. `['premium']`). Empty when [isSubscribed] is `false`.
 final  List<String> _activeEntitlementIds;
/// Identifiers of all currently active entitlements
/// (e.g. `['premium']`). Empty when [isSubscribed] is `false`.
@override@JsonKey() List<String> get activeEntitlementIds {
  if (_activeEntitlementIds is EqualUnmodifiableListView) return _activeEntitlementIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeEntitlementIds);
}

/// URL of the store's subscription-management page for this user,
/// if the provider exposes one. Useful for a "Manage subscription"
/// button.
@override final  String? managementUrl;

/// Create a copy of SubscriptionStatusEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionStatusEntityCopyWith<_SubscriptionStatusEntity> get copyWith => __$SubscriptionStatusEntityCopyWithImpl<_SubscriptionStatusEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionStatusEntity&&(identical(other.isSubscribed, isSubscribed) || other.isSubscribed == isSubscribed)&&const DeepCollectionEquality().equals(other._activeEntitlementIds, _activeEntitlementIds)&&(identical(other.managementUrl, managementUrl) || other.managementUrl == managementUrl));
}


@override
int get hashCode => Object.hash(runtimeType,isSubscribed,const DeepCollectionEquality().hash(_activeEntitlementIds),managementUrl);

@override
String toString() {
  return 'SubscriptionStatusEntity(isSubscribed: $isSubscribed, activeEntitlementIds: $activeEntitlementIds, managementUrl: $managementUrl)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionStatusEntityCopyWith<$Res> implements $SubscriptionStatusEntityCopyWith<$Res> {
  factory _$SubscriptionStatusEntityCopyWith(_SubscriptionStatusEntity value, $Res Function(_SubscriptionStatusEntity) _then) = __$SubscriptionStatusEntityCopyWithImpl;
@override @useResult
$Res call({
 bool isSubscribed, List<String> activeEntitlementIds, String? managementUrl
});




}
/// @nodoc
class __$SubscriptionStatusEntityCopyWithImpl<$Res>
    implements _$SubscriptionStatusEntityCopyWith<$Res> {
  __$SubscriptionStatusEntityCopyWithImpl(this._self, this._then);

  final _SubscriptionStatusEntity _self;
  final $Res Function(_SubscriptionStatusEntity) _then;

/// Create a copy of SubscriptionStatusEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSubscribed = null,Object? activeEntitlementIds = null,Object? managementUrl = freezed,}) {
  return _then(_SubscriptionStatusEntity(
isSubscribed: null == isSubscribed ? _self.isSubscribed : isSubscribed // ignore: cast_nullable_to_non_nullable
as bool,activeEntitlementIds: null == activeEntitlementIds ? _self._activeEntitlementIds : activeEntitlementIds // ignore: cast_nullable_to_non_nullable
as List<String>,managementUrl: freezed == managementUrl ? _self.managementUrl : managementUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
