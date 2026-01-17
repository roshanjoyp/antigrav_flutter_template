import 'package:antigrav_flutter_template/core/services/analytics_service/analytics_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service_impl.g.dart';

class DebugAnalyticsService implements AnalyticsService {
  final LogService _logger;
  DebugAnalyticsService(this._logger);

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    _logger.debug('ANALYTICS EVENT: $name, params: $parameters');
  }

  @override
  Future<void> logScreenView(String screenName) async {
    _logger.debug('ANALYTICS SCREEN: $screenName');
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    _logger.debug('ANALYTICS USER PROP: $name = $value');
  }
}

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return DebugAnalyticsService(ref.watch(logServiceProvider));
}
