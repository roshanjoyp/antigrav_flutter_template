import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:antigrav_flutter_template/features/profile/data/profile_model.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_entity.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore implementation of [ProfileRepository].
///
/// Stores each profile as a document in the `profiles` collection, keyed
/// by the owning user's uid. Maps documents through [ProfileModel] at the
/// boundary and Firestore errors into [AppException] — no Firestore type
/// leaks past this layer.
///
/// Requires `FirebaseConfig.initialize()` to have run and Firestore
/// security rules allowing the signed-in user to read/write their own
/// `profiles/{uid}` document (see docs/setup/FIREBASE_SETUP.md).
class FirestoreProfileRepositoryImpl implements ProfileRepository {
  /// Creates the repository.
  ///
  /// [firestore] defaults to [FirebaseFirestore.instance]; inject a fake
  /// in tests.
  FirestoreProfileRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Name of the Firestore collection holding profile documents.
  static const String collectionName = 'profiles';

  CollectionReference<Map<String, dynamic>> get _profiles =>
      _firestore.collection(collectionName);

  @override
  Stream<ProfileEntity?> watchProfile(String uid) =>
      _profiles.doc(uid).snapshots().map(_toEntityOrNull).handleError(
        // Re-throw as AppException so stream consumers never see
        // Firestore types.
        (Object error, StackTrace stackTrace) =>
            throw _mapError(error, stackTrace),
      );

  @override
  Future<Result<ProfileEntity?>> fetchProfile(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _profiles.doc(uid).get();
      return Success<ProfileEntity?>(_toEntityOrNull(snapshot));
    } catch (error, stackTrace) {
      return Failure<ProfileEntity?>(_mapError(error, stackTrace));
    }
  }

  @override
  Future<Result<void>> saveProfile(ProfileEntity profile) async {
    try {
      final Map<String, dynamic> data =
          ProfileModel.fromEntity(profile).toJson()
            // The server owns updatedAt so client clock skew never
            // corrupts ordering.
            ..['updatedAt'] = FieldValue.serverTimestamp()
            // Merge semantics per the contract: null fields don't
            // overwrite existing values.
            ..removeWhere((String key, dynamic value) => value == null);
      await _profiles.doc(profile.uid).set(data, SetOptions(merge: true));
      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(_mapError(error, stackTrace));
    }
  }

  /// Maps a Firestore document snapshot to a domain entity
  /// (missing document → `null`).
  ProfileEntity? _toEntityOrNull(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final Map<String, dynamic>? data = snapshot.data();
    if (data == null) return null;
    return ProfileModel.fromJson(data).toEntity();
  }

  /// Maps any thrown error into an [AppException] with a
  /// user-presentable message and a `profile/*` code.
  AppException _mapError(Object error, StackTrace stackTrace) {
    if (error is AppException) return error;
    final String code =
        error is FirebaseException ? error.code : 'unknown';
    final String message = switch (code) {
      'permission-denied' =>
        'You do not have permission to access this profile.',
      'unavailable' =>
        'Profile service is unreachable. Check your connection.',
      'deadline-exceeded' => 'The request timed out. Please try again.',
      _ => 'Failed to access profile data. Please try again.',
    };
    return AppException(
      message: message,
      code: 'profile/$code',
      originalError: error,
      stackTrace: stackTrace,
    );
  }
}
