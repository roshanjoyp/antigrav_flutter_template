import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/services/log_service/log_service.dart';
import 'package:craft_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:craft_flutter_template/core/services/network_service/network_service.dart';
import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_service_impl.g.dart';

/// A stub [NetworkService] that never touches the wire.
///
/// Every call logs the would-be request via [LogService], waits
/// [AppConstants.durationStubNetwork] so loading states are visible, and
/// returns an empty 200 response. This keeps the template runnable with
/// zero backend setup; enable the real implementation by flipping
/// `NetworkConfig.enabled` (see lib/core/config/network/network_config.dart).
class DebugNetworkService implements NetworkService {
  /// Creates a [DebugNetworkService] backed by the given [LogService].
  DebugNetworkService(this._logger);

  final LogService _logger;

  Future<Result<NetworkResponse>> _respond(String method, String path) async {
    _logger.debug('NETWORK (stub) $method $path → 200 {}');
    await Future<void>.delayed(AppConstants.durationStubNetwork);
    return const Success(
      NetworkResponse(statusCode: 200, data: <String, dynamic>{}),
    );
  }

  /// Logs the GET and returns an empty stub response.
  @override
  Future<Result<NetworkResponse>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _respond('GET', path);

  /// Logs the POST and returns an empty stub response.
  @override
  Future<Result<NetworkResponse>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _respond('POST', path);

  /// Logs the PUT and returns an empty stub response.
  @override
  Future<Result<NetworkResponse>> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _respond('PUT', path);

  /// Logs the PATCH and returns an empty stub response.
  @override
  Future<Result<NetworkResponse>> patch(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _respond('PATCH', path);

  /// Logs the DELETE and returns an empty stub response.
  @override
  Future<Result<NetworkResponse>> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _respond('DELETE', path);
}

/// Provides the app-wide [NetworkService].
///
/// Binds the stub by default; `bootstrap.dart` overrides this with the
/// Dio-backed implementation when `NetworkConfig.enabled` is `true`
/// (see lib/app/config/network_overrides.dart).
@Riverpod(keepAlive: true)
NetworkService networkService(Ref ref) {
  return DebugNetworkService(ref.watch(logServiceProvider));
}
