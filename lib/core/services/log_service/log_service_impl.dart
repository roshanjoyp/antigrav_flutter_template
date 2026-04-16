import 'package:antigrav_flutter_template/core/config/app_env.dart';
import 'package:antigrav_flutter_template/core/config/app_flavor.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'log_service_impl.g.dart';

/// A [LogService] implementation backed by the [Logger] package.
///
/// Logger configuration is environment-aware via [AppFlavor]:
///
/// - **Development** — full verbosity, stack traces, colors, emojis,
///   [Level.trace] and above. Designed for local debugging.
/// - **Staging** — reduced verbosity, no colors/emojis, [Level.warning]
///   and above. Matches what QA and testers need without noise.
/// - **Production** — minimal output, [Level.error] and above only.
///   [debug], [info], and [warning] calls are no-ops for performance —
///   no string interpolation, no allocation, no I/O.
///
/// The [LogService] interface is unchanged — callers are unaffected by
/// the environment switching.
class LoggerLogService implements LogService {
  /// Creates a [LoggerLogService], building the [Logger] from the current
  /// [AppFlavor] environment.
  ///
  /// An optional [logger] may be injected for testing purposes.
  LoggerLogService([Logger? logger]) : _logger = logger ?? _buildLogger();

  final Logger _logger;

  /// Whether the current environment suppresses non-critical log calls.
  ///
  /// `true` in production — [debug], [info], and [warning] are no-ops.
  static bool get _isProductionSilent =>
      AppFlavor.instance.env.isProduction;

  // ---------------------------------------------------------------------------
  // Logger factory
  // ---------------------------------------------------------------------------

  /// Builds a [Logger] configured for the current [AppEnv].
  static Logger _buildLogger() {
    final env = AppFlavor.instance.env;

    return switch (env) {
      AppEnv.development => Logger(
          level: Level.trace,
          printer: PrettyPrinter(
            methodCount: 2,
            errorMethodCount: 8,
            lineLength: 120,
            colors: true,
            printEmojis: true,
            dateTimeFormat: DateTimeFormat.none,
          ),
        ),
      AppEnv.staging => Logger(
          level: Level.warning,
          printer: PrettyPrinter(
            methodCount: 1,
            errorMethodCount: 5,
            lineLength: 100,
            colors: false,
            printEmojis: false,
            dateTimeFormat: DateTimeFormat.none,
          ),
        ),
      AppEnv.production => Logger(
          level: Level.error,
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 3,
            lineLength: 80,
            colors: false,
            printEmojis: false,
            dateTimeFormat: DateTimeFormat.none,
          ),
        ),
    };
  }

  // ---------------------------------------------------------------------------
  // LogService interface
  // ---------------------------------------------------------------------------

  @override
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_isProductionSilent) return;
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_isProductionSilent) return;
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  @override
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_isProductionSilent) return;
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  @override
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

@Riverpod(keepAlive: true)
LogService logService(Ref ref) {
  return LoggerLogService();
}
