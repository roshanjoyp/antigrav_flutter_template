import 'package:craft_flutter_template/core/services/crash_service/crash_service.dart';
import 'package:craft_flutter_template/core/services/log_service/log_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase Crashlytics implementation of [CrashService].
///
/// **All methods never throw** — this service sits inside Flutter's global
/// error handlers, so any failure here is swallowed after being logged
/// (via [LogService], falling back to [debugPrint]). On platforms without
/// Crashlytics support (web, desktop) calls degrade to logged no-ops
/// rather than crashing.
///
/// Not bound by default — `crashServiceProvider` returns the debug
/// implementation. To activate (see docs/setup/FIREBASE_SETUP.md):
///
/// ```dart
/// crashServiceProvider.overrideWith(
///   (ref) => FirebaseCrashServiceImpl(ref.watch(logServiceProvider)),
/// )
/// ```
class FirebaseCrashServiceImpl implements CrashService {
  /// Creates the service.
  ///
  /// [crashlytics] defaults to [FirebaseCrashlytics.instance]; inject a
  /// fake in tests.
  FirebaseCrashServiceImpl(this._logger, {FirebaseCrashlytics? crashlytics})
    : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  final LogService _logger;
  final FirebaseCrashlytics _crashlytics;

  /// Records an error to Crashlytics. Never throws.
  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    try {
      await _crashlytics.recordError(
        exception,
        stack,
        reason: reason,
        fatal: fatal,
      );
    } catch (e, st) {
      _logSafely('recordError failed (original error: $exception)', e, st);
    }
  }

  /// Logs a breadcrumb message to Crashlytics. Never throws.
  @override
  Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);
    } catch (e, st) {
      _logSafely('log failed', e, st);
    }
  }

  /// Associates [identifier] with subsequent crash reports. Never throws.
  @override
  Future<void> setUserIdentifier(String identifier) async {
    try {
      await _crashlytics.setUserIdentifier(identifier);
    } catch (e, st) {
      _logSafely('setUserIdentifier failed', e, st);
    }
  }

  /// Logs a Crashlytics failure without ever letting the failure escape —
  /// falls back to [debugPrint] if even the [LogService] throws.
  void _logSafely(String context, Object error, StackTrace stackTrace) {
    try {
      _logger.error('[Crashlytics] $context', error, stackTrace);
    } catch (_) {
      debugPrint('[Crashlytics] $context: $error');
    }
  }
}
