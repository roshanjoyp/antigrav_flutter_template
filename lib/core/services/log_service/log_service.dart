/// Contract for app-wide structured logging.
///
/// Implementations must never throw — [LogService] is the last line of
/// defence in the error handling chain. If the logger itself fails,
/// it must silently swallow the error.
///
/// Use [LogService] via the `logServiceProvider` Riverpod provider.
abstract class LogService {
  /// Logs a verbose debug message.
  ///
  /// Intended for detailed diagnostics during development. Implementations
  /// may suppress this in staging and production environments.
  void debug(String message, [dynamic error, StackTrace? stackTrace]);

  /// Logs an informational message about normal app behaviour.
  ///
  /// Use for milestones, state transitions, and key user actions.
  void info(String message, [dynamic error, StackTrace? stackTrace]);

  /// Logs a warning about a recoverable or unexpected condition.
  ///
  /// Use when something looks wrong but the app can continue.
  void warning(String message, [dynamic error, StackTrace? stackTrace]);

  /// Logs a non-fatal error.
  ///
  /// Use when an operation fails but the app can recover. Always active
  /// regardless of environment.
  void error(String message, [dynamic error, StackTrace? stackTrace]);

  /// Logs a fatal or completely unexpected condition (what-the-f*ck level).
  ///
  /// Use for errors that should never happen and indicate a serious bug.
  /// Always active regardless of environment.
  void wtf(String message, [dynamic error, StackTrace? stackTrace]);
}
