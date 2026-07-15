import 'package:craft_flutter_template/core/config/network/network_config.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/services/log_service/log_service.dart';
import 'package:craft_flutter_template/core/services/network_service/dio_network_error_mapper.dart';
import 'package:craft_flutter_template/core/services/network_service/network_service.dart';
import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:dio/dio.dart';

/// Returns the bearer token to attach to outgoing requests, or `null`
/// when the current user is unauthenticated.
typedef AuthTokenProvider = Future<String?> Function();

/// The real [NetworkService], backed by a [Dio] HTTP client pointed at
/// `NetworkConfig.baseUrl` for the running flavor.
///
/// Behaviour:
/// - When an [AuthTokenProvider] is supplied, every request carries an
///   `Authorization: Bearer <token>` header (skipped while the provider
///   returns `null`).
/// - Transport failures, timeouts, and non-2xx responses are logged via
///   [LogService] and returned as `Failure` results with `network/...`
///   codes — this class never throws.
class DioNetworkService implements NetworkService {
  /// Creates a [DioNetworkService] around an existing [dio] instance —
  /// injectable for tests. Prefer [DioNetworkService.fromConfig] in app
  /// wiring.
  DioNetworkService(this._dio, this._logger, {AuthTokenProvider? tokenProvider})
    : _tokenProvider = tokenProvider;

  /// Creates a [DioNetworkService] configured from [NetworkConfig] —
  /// flavor-resolved base URL and the timeout constants from
  /// [AppConstants].
  factory DioNetworkService.fromConfig(
    LogService logger, {
    AuthTokenProvider? tokenProvider,
  }) {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: NetworkConfig.baseUrl,
        connectTimeout: AppConstants.durationNetworkConnectTimeout,
        receiveTimeout: AppConstants.durationNetworkReceiveTimeout,
        sendTimeout: AppConstants.durationNetworkSendTimeout,
        responseType: ResponseType.json,
      ),
    );
    return DioNetworkService(dio, logger, tokenProvider: tokenProvider);
  }

  final Dio _dio;
  final LogService _logger;
  final AuthTokenProvider? _tokenProvider;

  /// Runs one request and maps every outcome into a [Result].
  Future<Result<NetworkResponse>> _request(
    String method,
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final Map<String, String> mergedHeaders = <String, String>{...?headers};
      final String? token = await _tokenProvider?.call();
      if (token != null) {
        mergedHeaders['Authorization'] = 'Bearer $token';
      }
      final Response<Object?> response = await _dio.request<Object?>(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(method: method, headers: mergedHeaders),
      );
      return Success(
        NetworkResponse(
          // Dio only completes without error for validated (2xx) codes.
          statusCode: response.statusCode ?? 200,
          data: response.data,
          headers: response.headers.map,
        ),
      );
    } on DioException catch (e, st) {
      final AppException exception = mapDioException(method, path, e, st);
      _logger.error(exception.message, e, st);
      return Failure(exception);
    } catch (e, st) {
      final AppException exception = AppException(
        message: 'Unexpected error during $method $path',
        code: 'network/unknown',
        originalError: e,
        stackTrace: st,
      );
      _logger.error(exception.message, e, st);
      return Failure(exception);
    }
  }

  /// Sends a GET request to [path].
  @override
  Future<Result<NetworkResponse>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) =>
      _request('GET', path, queryParameters: queryParameters, headers: headers);

  /// Sends a POST request to [path].
  @override
  Future<Result<NetworkResponse>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _request(
    'POST',
    path,
    body: body,
    queryParameters: queryParameters,
    headers: headers,
  );

  /// Sends a PUT request to [path].
  @override
  Future<Result<NetworkResponse>> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _request(
    'PUT',
    path,
    body: body,
    queryParameters: queryParameters,
    headers: headers,
  );

  /// Sends a PATCH request to [path].
  @override
  Future<Result<NetworkResponse>> patch(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _request(
    'PATCH',
    path,
    body: body,
    queryParameters: queryParameters,
    headers: headers,
  );

  /// Sends a DELETE request to [path].
  @override
  Future<Result<NetworkResponse>> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => _request(
    'DELETE',
    path,
    body: body,
    queryParameters: queryParameters,
    headers: headers,
  );
}
