import 'package:antigrav_flutter_template/core/utils/result.dart';

/// Contract for persistent key/value storage.
///
/// The template's single place for small persisted flags and tokens
/// (onboarding seen, auth tokens — see the `storageKey*` constants in
/// `AppConstants`). Access it via the `storageServiceProvider` Riverpod
/// provider.
///
/// A missing key is a **valid result** (`Success(null)` from [read]),
/// not an error. Error codes follow the `'storage/...'` convention.
abstract class StorageService {
  /// Reads the value stored under [key].
  ///
  /// Returns `Success(null)` when the key has never been written.
  Future<Result<String?>> read(String key);

  /// Writes [value] under [key], overwriting any existing value.
  Future<Result<void>> write(String key, String value);

  /// Deletes the value stored under [key], if any.
  Future<Result<void>> delete(String key);
}
