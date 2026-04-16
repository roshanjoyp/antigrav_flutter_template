import 'package:antigrav_flutter_template/core/services/crash_service/crash_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crash_service_impl.g.dart';

/// A debug [CrashService] that logs crash reports to [LogService].
///
/// **[recordError] must never throw.** It is called from Flutter's global
/// error handlers and zone error callbacks — if it throws, the original
/// error information is lost and the app may enter an unrecoverable state.
///
/// If the [LogService] itself fails, [recordError] falls back to [debugPrint]
/// as an absolute last resort. All other methods follow the same never-throw
/// contract since crash reporting infrastructure must be maximally resilient.
class DebugCrashService implements CrashService {
  /// Creates a [DebugCrashService] backed by the given [LogService].
  DebugCrashService(this._logger);

  final LogService _logger;

  /// Records an error to the crash reporting backend.
  ///
  /// This method **never throws**. If the [LogService] call fails, the error
  /// is written to [debugPrint] as a last resort so it is not lost entirely.
  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    try {
      _logger.error('CRASH REPORTED: $exception', exception, stack);
    } catch (e) {
      // LogService itself failed — use debugPrint as absolute last resort.
      // Do not rethrow: crash reporting must never interrupt the error pipeline.
      debugPrint(
        '[CrashService] Failed to record error via LogService. '
        'Original: $exception | LogService failure: $e',
      );
    }
  }

  /// Logs a breadcrumb message to the crash reporting backend.
  ///
  /// This method **never throws**. Failures are silently swallowed since
  /// breadcrumb loss is preferable to interrupting app flow.
  @override
  Future<void> log(String message) async {
    try {
      _logger.info('CRASH LOG: $message');
    } catch (e) {
      debugPrint('[CrashService] Failed to write crash log: $e');
    }
  }

  /// Associates a user identifier with subsequent crash reports.
  ///
  /// This method **never throws**. Failures are silently swallowed since
  /// missing user context is preferable to interrupting app flow.
  @override
  Future<void> setUserIdentifier(String identifier) async {
    try {
      _logger.debug('CRASH USER SET: $identifier');
    } catch (e) {
      debugPrint('[CrashService] Failed to set user identifier: $e');
    }
  }
}

@Riverpod(keepAlive: true)
CrashService crashService(Ref ref) {
  return DebugCrashService(ref.watch(logServiceProvider));
}
