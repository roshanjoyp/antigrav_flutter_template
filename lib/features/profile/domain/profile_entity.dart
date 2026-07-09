import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_entity.freezed.dart';

/// Domain representation of a user's public profile.
///
/// Pure domain object — deliberately has **no** JSON/serialization code.
/// Persistence concerns (Firestore field names, `Timestamp` conversion)
/// live in the data layer's `ProfileModel`, which converts to and from
/// this entity. This is the template's reference example of the
/// model-vs-entity split.
@freezed
abstract class ProfileEntity with _$ProfileEntity {
  /// Creates a [ProfileEntity].
  const factory ProfileEntity({
    /// The owning user's unique ID — same as `UserEntity.id`.
    required String uid,

    /// The name the user chose to display on their profile.
    String? displayName,

    /// Free-form short biography text.
    String? bio,

    /// URL of the profile picture, if set.
    String? photoUrl,

    /// When the profile was last saved (set by the backend on write).
    DateTime? updatedAt,
  }) = _ProfileEntity;
}
