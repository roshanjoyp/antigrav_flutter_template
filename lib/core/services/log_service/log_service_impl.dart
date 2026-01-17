import 'package:antigrav_flutter_template/core/services/log_service/log_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'log_service_impl.g.dart';

class LoggerLogService implements LogService {
  final Logger _logger;

  LoggerLogService([Logger? logger])
    : _logger =
          logger ??
          Logger(
            printer: PrettyPrinter(
              methodCount: 0,
              errorMethodCount: 5,
              lineLength: 80,
              colors: true,
              printEmojis: true,
              dateTimeFormat: DateTimeFormat.none,
            ),
          );

  @override
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  @override
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
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
