import 'package:antigrav_flutter_template/core/services/analytics_service/analytics_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service_impl.g.dart';

/// A debug [AnalyticsService] that logs events to [LogService] instead of
/// sending them to a real analytics backend.
///
/// All methods wrap their operations in try/catch and throw [AppException]
/// on unexpected failure. This ensures callers are never silently dropped
/// without knowing something went wrong.
///
/// Replace this with a real implementation (e.g. Firebase Analytics)
/// when the analytics backend is configured.
class DebugAnalyticsService implements AnalyticsService {
  /// Creates a [DebugAnalyticsService] backed by the given [LogService].
  DebugAnalyticsService(this._logger);

  final LogService _logger;

  /// Logs an analytics event by name with optional parameters.
  ///
  /// Throws [AppException] if the underlying log call fails unexpectedly.
  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      _logger.debug('ANALYTICS EVENT: $name, params: $parameters');
    } catch (e, st) {
      _logger.error('Failed to log analytics event: $name', e, st);
      throw AppException(
        message: 'Failed to log analytics event: $name',
        code: 'analytics/log-event-failed',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Records a screen view with the given [screenName].
  ///
  /// Throws [AppException] if the underlying log call fails unexpectedly.
  @override
  Future<void> logScreenView(String screenName) async {
    try {
      _logger.debug('ANALYTICS SCREEN: $screenName');
    } catch (e, st) {
      _logger.error('Failed to log screen view: $screenName', e, st);
      throw AppException(
        message: 'Failed to log screen view: $screenName',
        code: 'analytics/log-screen-failed',
        originalError: e,
        stackTrace: st,
      );
    }
  }

  /// Sets a user property by [name] to [value].
  ///
  /// Throws [AppException] if the underlying log call fails unexpectedly.
  @override
  Future<void> setUserProperty(String name, String value) async {
    try {
      _logger.debug('ANALYTICS USER PROP: $name = $value');
    } catch (e, st) {
      _logger.error('Failed to set user property: $name', e, st);
      throw AppException(
        message: 'Failed to set user property: $name',
        code: 'analytics/set-property-failed',
        originalError: e,
        stackTrace: st,
      );
    }
  }
}

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return DebugAnalyticsService(ref.watch(logServiceProvider));
}
