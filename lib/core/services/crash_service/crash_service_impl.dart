import 'package:antigrav_flutter_template/core/services/crash_service/crash_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crash_service_impl.g.dart';

class DebugCrashService implements CrashService {
  final LogService _logger;
  DebugCrashService(this._logger);

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    _logger.error('CRASH REPORTED: $exception', exception, stack);
  }

  @override
  Future<void> log(String message) async {
    _logger.info('CRASH LOG: $message');
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    _logger.debug('CRASH USER SET: $identifier');
  }
}

@Riverpod(keepAlive: true)
CrashService crashService(Ref ref) {
  return DebugCrashService(ref.watch(logServiceProvider));
}
