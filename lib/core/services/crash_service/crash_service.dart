/// Contract for crash and error reporting.
///
/// Implementations are responsible for forwarding unhandled errors to a
/// crash reporting backend (e.g. Firebase Crashlytics, Sentry).
///
/// **All methods must never throw.** This service is called from Flutter's
/// global error handler and zone callbacks — if it throws, the original
/// error context is lost.
///
/// Use [CrashService] via the `crashServiceProvider` Riverpod provider.
abstract class CrashService {
  /// Records an error to the crash reporting backend.
  ///
  /// [exception] is the thrown error object.
  /// [stack] is the associated stack trace, if available.
  /// [reason] is an optional human-readable description of the context.
  /// [fatal] indicates whether this error caused the app to crash.
  ///
  /// This method **must never throw**.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  });

  /// Logs a breadcrumb message to the crash reporting backend.
  ///
  /// Breadcrumbs provide context for what happened before a crash.
  /// This method **must never throw**.
  Future<void> log(String message);

  /// Associates a user identifier with subsequent crash reports.
  ///
  /// Call this after a successful sign-in. Clear it on sign-out.
  /// This method **must never throw**.
  Future<void> setUserIdentifier(String identifier);
}
