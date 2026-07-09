import 'package:antigrav_flutter_template/core/services/storage_service/storage_service.dart';
import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_service_impl.g.dart';

/// [StorageService] backed by the platform keychain/keystore via
/// `flutter_secure_storage`.
///
/// Encrypted at rest on both platforms, so it is safe for tokens as
/// well as plain flags. This is a real implementation (not a stub) —
/// it needs no backend and works on a fresh checkout.
class SecureStorageServiceImpl implements StorageService {
  /// Creates a [SecureStorageServiceImpl].
  ///
  /// [storage] is injectable for tests; defaults to a standard
  /// [FlutterSecureStorage].
  SecureStorageServiceImpl({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<Result<String?>> read(String key) =>
      _guard('read', key, () => _storage.read(key: key));

  @override
  Future<Result<void>> write(String key, String value) =>
      _guard('write', key, () => _storage.write(key: key, value: value));

  @override
  Future<Result<void>> delete(String key) =>
      _guard('delete', key, () => _storage.delete(key: key));

  /// Runs [action], wrapping the outcome in a [Result] with a
  /// `storage/<operation>-failed` code on failure.
  Future<Result<T>> _guard<T>(
    String operation,
    String key,
    Future<T> Function() action,
  ) async {
    try {
      return Success<T>(await action());
    } catch (error, stackTrace) {
      return Failure<T>(
        AppException(
          message: 'Failed to $operation storage key "$key".',
          code: 'storage/$operation-failed',
          originalError: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}

/// [StorageService] holding values in memory only.
///
/// Nothing survives a restart — meant for tests and for provider
/// overrides on platforms without secure storage support.
class InMemoryStorageService implements StorageService {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<Result<String?>> read(String key) async =>
      Success<String?>(_values[key]);

  @override
  Future<Result<void>> write(String key, String value) async {
    _values[key] = value;
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> delete(String key) async {
    _values.remove(key);
    return const Success<void>(null);
  }
}

/// Provides the app-wide [StorageService] binding.
///
/// Bound to [SecureStorageServiceImpl] by default — a real
/// implementation, so no backend module needs to override it.
@Riverpod(keepAlive: true)
StorageService storageService(Ref ref) {
  return SecureStorageServiceImpl();
}
