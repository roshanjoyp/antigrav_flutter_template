import 'package:craft_flutter_template/core/utils/result.dart';

/// A single HTTP response returned by [NetworkService].
///
/// Carries the decoded body rather than raw bytes: JSON responses are
/// decoded into `Map`/`List` structures, plain-text responses into
/// [String]. Repositories should map [data] into typed models — this
/// type never leaves the data layer.
class NetworkResponse {
  /// Creates a response with the given [statusCode], decoded [data],
  /// and response [headers].
  const NetworkResponse({
    required this.statusCode,
    required this.data,
    this.headers = const <String, List<String>>{},
  });

  /// The HTTP status code (always 2xx — non-2xx responses surface as
  /// `Failure` results, never as a [NetworkResponse]).
  final int statusCode;

  /// The decoded response body — typically `Map<String, dynamic>` or
  /// `List<dynamic>` for JSON APIs, [String] for text, `null` for
  /// empty bodies.
  final Object? data;

  /// Response headers, lower-cased header name → values.
  final Map<String, List<String>> headers;
}

/// Contract for HTTP calls to the app's own REST/GraphQL backend.
///
/// This is the single seam between repositories and the wire: data-layer
/// repository implementations depend on this interface, never on an HTTP
/// client directly, so the backend can be swapped (or re-pointed at a
/// new host) without touching call sites.
///
/// All methods return [Result] and never throw: transport errors,
/// timeouts, and non-2xx status codes surface as `Failure` carrying an
/// [AppException] with a `network/...` code (`network/timeout`,
/// `network/no-connection`, `network/http-404`, ...).
///
/// [path] arguments are relative to the configured base URL
/// (`NetworkConfig.baseUrl`), e.g. `'/v1/profile'`.
///
/// Use [NetworkService] via the `networkServiceProvider` Riverpod
/// provider.
abstract class NetworkService {
  /// Sends a GET request to [path].
  Future<Result<NetworkResponse>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Sends a POST request to [path] with an optional JSON-encodable [body].
  Future<Result<NetworkResponse>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Sends a PUT request to [path] with an optional JSON-encodable [body].
  Future<Result<NetworkResponse>> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Sends a PATCH request to [path] with an optional JSON-encodable [body].
  Future<Result<NetworkResponse>> patch(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Sends a DELETE request to [path] with an optional JSON-encodable [body].
  Future<Result<NetworkResponse>> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
}
