import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// Domain representation of an authenticated user.
///
/// Backend-agnostic: implementations of `AuthRepository` map their
/// provider-specific user objects (e.g. Firebase `User`) into this entity,
/// so nothing above the data layer ever depends on an auth SDK.
@freezed
abstract class UserEntity with _$UserEntity {
  /// Creates a [UserEntity].
  const factory UserEntity({
    /// Unique, stable identifier for the user (e.g. Firebase UID).
    required String id,

    /// The user's email address, or `null` when the provider supplies none
    /// (e.g. anonymous sign-in, or Apple private relay withheld email).
    String? email,

    /// The user's display name, if the provider supplies one.
    String? displayName,

    /// URL of the user's avatar image, if the provider supplies one.
    String? photoUrl,

    /// Whether this user signed in anonymously (guest session).
    @Default(false) bool isAnonymous,
  }) = _UserEntity;

  /// Creates a [UserEntity] from its JSON representation.
  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
