import 'package:craft_flutter_template/features/profile/domain/profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// Data-layer representation of a profile document.
///
/// Owns everything the domain's [ProfileEntity] must not know about:
/// JSON field names, Firestore [Timestamp] conversion, and the
/// entity ↔ document mapping. Repositories convert at the boundary —
/// models never leave the data layer.
@freezed
abstract class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  /// Creates a [ProfileModel].
  const factory ProfileModel({
    /// The owning user's unique ID (also the Firestore document ID).
    required String uid,

    /// The user's chosen display name.
    String? displayName,

    /// Free-form short biography text.
    String? bio,

    /// URL of the profile picture, if set.
    String? photoUrl,

    /// Last write time; stored as a Firestore [Timestamp].
    @TimestampConverter() DateTime? updatedAt,
  }) = _ProfileModel;

  /// Creates a [ProfileModel] from a Firestore document map.
  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  /// Creates a [ProfileModel] from the domain [entity].
  factory ProfileModel.fromEntity(ProfileEntity entity) => ProfileModel(
    uid: entity.uid,
    displayName: entity.displayName,
    bio: entity.bio,
    photoUrl: entity.photoUrl,
    updatedAt: entity.updatedAt,
  );

  /// Converts this model to the domain [ProfileEntity].
  ProfileEntity toEntity() => ProfileEntity(
    uid: uid,
    displayName: displayName,
    bio: bio,
    photoUrl: photoUrl,
    updatedAt: updatedAt,
  );
}

/// Converts between Firestore [Timestamp] values and Dart [DateTime].
///
/// Firestore stores dates as [Timestamp]; the domain uses [DateTime].
/// Tolerates `null` and unexpected types by returning `null` rather
/// than throwing during deserialization.
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  /// Creates a [TimestampConverter].
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) => json is Timestamp ? json.toDate() : null;

  @override
  Object? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}
