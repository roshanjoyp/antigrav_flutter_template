import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:dio/dio.dart';

/// Maps a [DioException] from `method path` onto the template's
/// `network/...` [AppException] codes:
///
/// - `network/timeout` — connect/send/receive/transform timeouts
/// - `network/no-connection` — socket-level connection failures
/// - `network/http-<status>` — non-2xx responses
/// - `network/cancelled` — cancelled requests
/// - `network/bad-certificate` — TLS verification failures
/// - `network/unknown` — anything else
///
/// Repositories can switch on these codes to decide between retry,
/// re-auth, and user-facing messaging without importing dio.
AppException mapDioException(
  String method,
  String path,
  DioException e,
  StackTrace st,
) {
  final (String code, String detail) = switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout => ('network/timeout', 'timed out'),
    DioExceptionType.connectionError => (
      'network/no-connection',
      'could not connect',
    ),
    DioExceptionType.badResponse => (
      'network/http-${e.response?.statusCode}',
      'returned HTTP ${e.response?.statusCode}',
    ),
    DioExceptionType.cancel => ('network/cancelled', 'was cancelled'),
    DioExceptionType.badCertificate => (
      'network/bad-certificate',
      'failed TLS verification',
    ),
    DioExceptionType.unknown => ('network/unknown', 'failed'),
  };
  return AppException(
    message: '$method $path $detail',
    code: code,
    originalError: e,
    stackTrace: st,
  );
}
