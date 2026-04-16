import 'package:antigrav_flutter_template/core/services/log_service/log_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/update_service/update_service.dart';
import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_service_impl.g.dart';

/// A stub [UpdateService] implementation.
///
/// [checkForUpdate] always returns `null` (no update available) until a real
/// backend check is implemented. Returning `null` is a valid, non-error
/// result meaning the app is up-to-date.
///
/// On unexpected failure, [checkForUpdate] throws [AppException] so callers
/// can distinguish a failed check from a clean "no update" response.
///
/// ⚠️ SETUP_MANAGED — the real implementation wired to a version endpoint
/// will be injected via setup.sh when a backend is configured.
class CustomUpdateService implements UpdateService {
  /// Creates a [CustomUpdateService].
  ///
  /// [logger] is used to log errors before propagating them.
  CustomUpdateService({required LogService logger}) : _logger = logger;

  final LogService _logger;

  /// Checks whether an app update is available.
  ///
  /// Returns an [AppUpdateInfo] if an update is available, or `null` if the
  /// app is already up-to-date. Throws [AppException] if the check itself
  /// fails (e.g. network error, malformed response).
  @override
  Future<AppUpdateInfo?> checkForUpdate() async {
    try {
      // TODO: Implement your backend check here.
      // Example:
      // final response = await httpClient.get('https://api.myapp.com/version');
      // if (response.version > currentVersion) return AppUpdateInfo(...);

      // Returning null means no update available — this is not an error.
      return null;
    } catch (e, st) {
      _logger.error('Failed to check for app update', e, st);
      throw AppException(
        message: 'Failed to check for app update',
        code: 'update/check-failed',
        originalError: e,
        stackTrace: st,
      );
    }
  }
}

@Riverpod(keepAlive: true)
UpdateService updateService(Ref ref) {
  return CustomUpdateService(logger: ref.watch(logServiceProvider));
}
