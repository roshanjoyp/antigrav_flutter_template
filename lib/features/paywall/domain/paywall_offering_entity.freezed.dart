// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paywall_offering_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaywallOfferingEntity {

/// The offering's unique identifier (e.g. `'default'`).
 String get id;/// The purchasable packages in display order.
 List<PaywallPackageEntity> get packages;
/// Create a copy of PaywallOfferingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywallOfferingEntityCopyWith<PaywallOfferingEntity> get copyWith => _$PaywallOfferingEntityCopyWithImpl<PaywallOfferingEntity>(this as PaywallOfferingEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallOfferingEntity&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.packages, packages));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(packages));

@override
String toString() {
  return 'PaywallOfferingEntity(id: $id, packages: $packages)';
}


}

/// @nodoc
abstract mixin class $PaywallOfferingEntityCopyWith<$Res>  {
  factory $PaywallOfferingEntityCopyWith(PaywallOfferingEntity value, $Res Function(PaywallOfferingEntity) _then) = _$PaywallOfferingEntityCopyWithImpl;
@useResult
$Res call({
 String id, List<PaywallPackageEntity> packages
});




}
/// @nodoc
class _$PaywallOfferingEntityCopyWithImpl<$Res>
    implements $PaywallOfferingEntityCopyWith<$Res> {
  _$PaywallOfferingEntityCopyWithImpl(this._self, this._then);

  final PaywallOfferingEntity _self;
  final $Res Function(PaywallOfferingEntity) _then;

/// Create a copy of PaywallOfferingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? packages = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,packages: null == packages ? _self.packages : packages // ignore: cast_nullable_to_non_nullable
as List<PaywallPackageEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaywallOfferingEntity].
extension PaywallOfferingEntityPatterns on PaywallOfferingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaywallOfferingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaywallOfferingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaywallOfferingEntity value)  $default,){
final _that = this;
switch (_that) {
case _PaywallOfferingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaywallOfferingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PaywallOfferingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<PaywallPackageEntity> packages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaywallOfferingEntity() when $default != null:
return $default(_that.id,_that.packages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<PaywallPackageEntity> packages)  $default,) {final _that = this;
switch (_that) {
case _PaywallOfferingEntity():
return $default(_that.id,_that.packages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<PaywallPackageEntity> packages)?  $default,) {final _that = this;
switch (_that) {
case _PaywallOfferingEntity() when $default != null:
return $default(_that.id,_that.packages);case _:
  return null;

}
}

}

/// @nodoc


class _PaywallOfferingEntity implements PaywallOfferingEntity {
  const _PaywallOfferingEntity({required this.id, final  List<PaywallPackageEntity> packages = const <PaywallPackageEntity>[]}): _packages = packages;
  

/// The offering's unique identifier (e.g. `'default'`).
@override final  String id;
/// The purchasable packages in display order.
 final  List<PaywallPackageEntity> _packages;
/// The purchasable packages in display order.
@override@JsonKey() List<PaywallPackageEntity> get packages {
  if (_packages is EqualUnmodifiableListView) return _packages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_packages);
}


/// Create a copy of PaywallOfferingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaywallOfferingEntityCopyWith<_PaywallOfferingEntity> get copyWith => __$PaywallOfferingEntityCopyWithImpl<_PaywallOfferingEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaywallOfferingEntity&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._packages, _packages));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_packages));

@override
String toString() {
  return 'PaywallOfferingEntity(id: $id, packages: $packages)';
}


}

/// @nodoc
abstract mixin class _$PaywallOfferingEntityCopyWith<$Res> implements $PaywallOfferingEntityCopyWith<$Res> {
  factory _$PaywallOfferingEntityCopyWith(_PaywallOfferingEntity value, $Res Function(_PaywallOfferingEntity) _then) = __$PaywallOfferingEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, List<PaywallPackageEntity> packages
});




}
/// @nodoc
class __$PaywallOfferingEntityCopyWithImpl<$Res>
    implements _$PaywallOfferingEntityCopyWith<$Res> {
  __$PaywallOfferingEntityCopyWithImpl(this._self, this._then);

  final _PaywallOfferingEntity _self;
  final $Res Function(_PaywallOfferingEntity) _then;

/// Create a copy of PaywallOfferingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? packages = null,}) {
  return _then(_PaywallOfferingEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,packages: null == packages ? _self._packages : packages // ignore: cast_nullable_to_non_nullable
as List<PaywallPackageEntity>,
  ));
}


}

/// @nodoc
mixin _$PaywallPackageEntity {

/// The package's unique identifier within its offering
/// (e.g. `'$rc_monthly'`). Used to resolve the underlying store
/// package at purchase time.
 String get id;/// The product's display title from the store (e.g. `'Premium'`).
 String get title;/// The product's display description from the store.
 String get description;/// The localized, formatted price string (e.g. `'$9.99'`).
 String get priceString;/// Human-readable billing period label (e.g. `'Monthly'`,
/// `'Annual'`, `'Lifetime'`).
 String get periodLabel;
/// Create a copy of PaywallPackageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywallPackageEntityCopyWith<PaywallPackageEntity> get copyWith => _$PaywallPackageEntityCopyWithImpl<PaywallPackageEntity>(this as PaywallPackageEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallPackageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priceString, priceString) || other.priceString == priceString)&&(identical(other.periodLabel, periodLabel) || other.periodLabel == periodLabel));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,priceString,periodLabel);

@override
String toString() {
  return 'PaywallPackageEntity(id: $id, title: $title, description: $description, priceString: $priceString, periodLabel: $periodLabel)';
}


}

/// @nodoc
abstract mixin class $PaywallPackageEntityCopyWith<$Res>  {
  factory $PaywallPackageEntityCopyWith(PaywallPackageEntity value, $Res Function(PaywallPackageEntity) _then) = _$PaywallPackageEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String priceString, String periodLabel
});




}
/// @nodoc
class _$PaywallPackageEntityCopyWithImpl<$Res>
    implements $PaywallPackageEntityCopyWith<$Res> {
  _$PaywallPackageEntityCopyWithImpl(this._self, this._then);

  final PaywallPackageEntity _self;
  final $Res Function(PaywallPackageEntity) _then;

/// Create a copy of PaywallPackageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? priceString = null,Object? periodLabel = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priceString: null == priceString ? _self.priceString : priceString // ignore: cast_nullable_to_non_nullable
as String,periodLabel: null == periodLabel ? _self.periodLabel : periodLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaywallPackageEntity].
extension PaywallPackageEntityPatterns on PaywallPackageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaywallPackageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaywallPackageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaywallPackageEntity value)  $default,){
final _that = this;
switch (_that) {
case _PaywallPackageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaywallPackageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PaywallPackageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String priceString,  String periodLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaywallPackageEntity() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.priceString,_that.periodLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String priceString,  String periodLabel)  $default,) {final _that = this;
switch (_that) {
case _PaywallPackageEntity():
return $default(_that.id,_that.title,_that.description,_that.priceString,_that.periodLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String priceString,  String periodLabel)?  $default,) {final _that = this;
switch (_that) {
case _PaywallPackageEntity() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.priceString,_that.periodLabel);case _:
  return null;

}
}

}

/// @nodoc


class _PaywallPackageEntity implements PaywallPackageEntity {
  const _PaywallPackageEntity({required this.id, required this.title, required this.description, required this.priceString, required this.periodLabel});
  

/// The package's unique identifier within its offering
/// (e.g. `'$rc_monthly'`). Used to resolve the underlying store
/// package at purchase time.
@override final  String id;
/// The product's display title from the store (e.g. `'Premium'`).
@override final  String title;
/// The product's display description from the store.
@override final  String description;
/// The localized, formatted price string (e.g. `'$9.99'`).
@override final  String priceString;
/// Human-readable billing period label (e.g. `'Monthly'`,
/// `'Annual'`, `'Lifetime'`).
@override final  String periodLabel;

/// Create a copy of PaywallPackageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaywallPackageEntityCopyWith<_PaywallPackageEntity> get copyWith => __$PaywallPackageEntityCopyWithImpl<_PaywallPackageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaywallPackageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priceString, priceString) || other.priceString == priceString)&&(identical(other.periodLabel, periodLabel) || other.periodLabel == periodLabel));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,priceString,periodLabel);

@override
String toString() {
  return 'PaywallPackageEntity(id: $id, title: $title, description: $description, priceString: $priceString, periodLabel: $periodLabel)';
}


}

/// @nodoc
abstract mixin class _$PaywallPackageEntityCopyWith<$Res> implements $PaywallPackageEntityCopyWith<$Res> {
  factory _$PaywallPackageEntityCopyWith(_PaywallPackageEntity value, $Res Function(_PaywallPackageEntity) _then) = __$PaywallPackageEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String priceString, String periodLabel
});




}
/// @nodoc
class __$PaywallPackageEntityCopyWithImpl<$Res>
    implements _$PaywallPackageEntityCopyWith<$Res> {
  __$PaywallPackageEntityCopyWithImpl(this._self, this._then);

  final _PaywallPackageEntity _self;
  final $Res Function(_PaywallPackageEntity) _then;

/// Create a copy of PaywallPackageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? priceString = null,Object? periodLabel = null,}) {
  return _then(_PaywallPackageEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priceString: null == priceString ? _self.priceString : priceString // ignore: cast_nullable_to_non_nullable
as String,periodLabel: null == periodLabel ? _self.periodLabel : periodLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
