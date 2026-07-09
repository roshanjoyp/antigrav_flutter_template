import 'package:antigrav_flutter_template/core/services/analytics_service/analytics_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/crash_service/crash_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// A [LogService] that records every call for assertions.
class RecordingLogService implements LogService {
  /// Messages received, prefixed with their level.
  final List<String> lines = <String>[];

  /// When `true`, every call throws to exercise failure paths.
  bool shouldThrow = false;

  void _add(String level, String message) {
    if (shouldThrow) throw StateError('logger down');
    lines.add('$level: $message');
  }

  @override
  void debug(String message, [dynamic error, StackTrace? stackTrace]) =>
      _add('debug', message);

  @override
  void info(String message, [dynamic error, StackTrace? stackTrace]) =>
      _add('info', message);

  @override
  void warning(String message, [dynamic error, StackTrace? stackTrace]) =>
      _add('warning', message);

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) =>
      _add('error', message);

  @override
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) =>
      _add('wtf', message);
}

void main() {
  late RecordingLogService logger;

  setUp(() => logger = RecordingLogService());

  group('DebugCrashService', () {
    test('routes crash reports to the log service', () async {
      final DebugCrashService service = DebugCrashService(logger);
      await service.recordError(StateError('boom'), StackTrace.current);
      await service.log('breadcrumb');
      await service.setUserIdentifier('user-1');

      expect(logger.lines, hasLength(3));
      expect(logger.lines.first, contains('boom'));
    });

    test('never throws, even when the logger fails', () async {
      final DebugCrashService service = DebugCrashService(logger);
      logger.shouldThrow = true;

      await service.recordError(StateError('boom'), null);
      await service.log('breadcrumb');
      await service.setUserIdentifier('user-1');
      // Reaching here without an exception is the assertion.
    });
  });

  group('DebugAnalyticsService', () {
    test('routes events to the log service', () async {
      final DebugAnalyticsService service = DebugAnalyticsService(logger);
      await service.logEvent('tapped', parameters: <String, Object>{'x': 1});
      await service.logScreenView('home');
      await service.setUserProperty('tier', 'gold');

      expect(logger.lines, hasLength(3));
      expect(logger.lines.first, contains('tapped'));
    });
  });
}
