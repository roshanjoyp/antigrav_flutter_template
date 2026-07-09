import 'package:craft_flutter_template/core/services/analytics_service/analytics_service.dart';
import 'package:craft_flutter_template/core/services/log_service/log_service.dart';
import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Firebase Analytics implementation of [AnalyticsService].
///
/// Forwards events to Firebase Analytics. Failures are logged via
/// [LogService] and then propagated as [AppException] — analytics loss is
/// surfaced to callers, never silently swallowed.
///
/// Not bound by default — `analyticsServiceProvider` returns the debug
/// implementation. To activate (see docs/setup/FIREBASE_SETUP.md):
///
/// ```dart
/// analyticsServiceProvider.overrideWith(
///   (ref) => FirebaseAnalyticsServiceImpl(ref.watch(logServiceProvider)),
/// )
/// ```
class FirebaseAnalyticsServiceImpl implements AnalyticsService {
  /// Creates the service.
  ///
  /// [analytics] defaults to [FirebaseAnalytics.instance]; inject a fake
  /// in tests.
  FirebaseAnalyticsServiceImpl(this._logger, {FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  final LogService _logger;
  final FirebaseAnalytics _analytics;

  /// Tracks a named event with optional parameters.
  ///
  /// Throws [AppException] (code `analytics/log-event-failed`) on failure.
  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) =>
      _guard(
        () => _analytics.logEvent(name: name, parameters: parameters),
        operation: 'log analytics event: $name',
        code: 'analytics/log-event-failed',
      );

  /// Records a screen view with the given [screenName].
  ///
  /// Throws [AppException] (code `analytics/log-screen-failed`) on failure.
  @override
  Future<void> logScreenView(String screenName) => _guard(
    () => _analytics.logScreenView(screenName: screenName),
    operation: 'log screen view: $screenName',
    code: 'analytics/log-screen-failed',
  );

  /// Sets a persistent user property by [name] to [value].
  ///
  /// Throws [AppException] (code `analytics/set-property-failed`) on
  /// failure.
  @override
  Future<void> setUserProperty(String name, String value) => _guard(
    () => _analytics.setUserProperty(name: name, value: value),
    operation: 'set user property: $name',
    code: 'analytics/set-property-failed',
  );

  /// Runs [run]; on failure logs via [LogService] and throws an
  /// [AppException] with the given [code], per the service error contract.
  Future<void> _guard(
    Future<void> Function() run, {
    required String operation,
    required String code,
  }) async {
    try {
      await run();
    } catch (e, st) {
      _logger.error('Failed to $operation', e, st);
      throw AppException(
        message: 'Failed to $operation',
        code: code,
        originalError: e,
        stackTrace: st,
      );
    }
  }
}
