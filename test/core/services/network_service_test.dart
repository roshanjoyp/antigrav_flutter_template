import 'dart:convert';
import 'dart:typed_data';

import 'package:craft_flutter_template/core/services/log_service/log_service.dart';
import 'package:craft_flutter_template/core/services/network_service/dio_network_error_mapper.dart';
import 'package:craft_flutter_template/core/services/network_service/dio_network_service_impl.dart';
import 'package:craft_flutter_template/core/services/network_service/network_service.dart';
import 'package:craft_flutter_template/core/services/network_service/network_service_impl.dart';
import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// A [LogService] that records every call for assertions.
class RecordingLogService implements LogService {
  /// Messages received, prefixed with their level.
  final List<String> lines = <String>[];

  void _add(String level, String message) => lines.add('$level: $message');

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

/// An [HttpClientAdapter] that answers every request via [handler] and
/// records the last [RequestOptions] seen for assertions.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.handler);

  /// Produces the canned response (or throws) for each request.
  final Future<ResponseBody> Function(RequestOptions options) handler;

  /// The options of the most recent request.
  RequestOptions? lastOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    lastOptions = options;
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonBody(Object payload, int status) => ResponseBody.fromString(
  jsonEncode(payload),
  status,
  headers: <String, List<String>>{
    Headers.contentTypeHeader: <String>[Headers.jsonContentType],
  },
);

void main() {
  late RecordingLogService logger;

  setUp(() => logger = RecordingLogService());

  group('DebugNetworkService', () {
    test('returns an empty 200 success and logs the request', () async {
      final DebugNetworkService service = DebugNetworkService(logger);

      final Result<NetworkResponse> result = await service.get('/v1/thing');

      expect(result.isSuccess, isTrue);
      final NetworkResponse response = result.getOrNull()!;
      expect(response.statusCode, 200);
      expect(response.data, <String, dynamic>{});
      expect(logger.lines.single, contains('GET /v1/thing'));
    });
  });

  group('DioNetworkService', () {
    Dio dioWith(FakeHttpAdapter adapter) {
      final Dio dio = Dio(BaseOptions(baseUrl: 'https://test.example.com'));
      dio.httpClientAdapter = adapter;
      return dio;
    }

    test('decodes a JSON success response', () async {
      final FakeHttpAdapter adapter = FakeHttpAdapter(
        (RequestOptions o) async => _jsonBody(<String, String>{'id': '7'}, 200),
      );
      final DioNetworkService service = DioNetworkService(
        dioWith(adapter),
        logger,
      );

      final Result<NetworkResponse> result = await service.get(
        '/v1/profile',
        queryParameters: <String, dynamic>{'full': true},
      );

      final NetworkResponse response = result.getOrNull()!;
      expect(response.statusCode, 200);
      expect(response.data, <String, String>{'id': '7'});
      expect(adapter.lastOptions!.method, 'GET');
      expect(adapter.lastOptions!.uri.queryParameters, {'full': 'true'});
    });

    test('attaches the bearer token from the token provider', () async {
      final FakeHttpAdapter adapter = FakeHttpAdapter(
        (RequestOptions o) async => _jsonBody(<String, String>{}, 200),
      );
      final DioNetworkService service = DioNetworkService(
        dioWith(adapter),
        logger,
        tokenProvider: () async => 'token-123',
      );

      await service.post('/v1/items', body: <String, String>{'name': 'x'});

      expect(adapter.lastOptions!.headers['Authorization'], 'Bearer token-123');
      expect(adapter.lastOptions!.method, 'POST');
      expect(adapter.lastOptions!.data, <String, String>{'name': 'x'});
    });

    test('maps a non-2xx response to a network/http-<status> failure '
        'and logs it', () async {
      final FakeHttpAdapter adapter = FakeHttpAdapter(
        (RequestOptions o) async =>
            _jsonBody(<String, String>{'error': 'gone'}, 404),
      );
      final DioNetworkService service = DioNetworkService(
        dioWith(adapter),
        logger,
      );

      final Result<NetworkResponse> result = await service.delete('/v1/x');

      expect(result.isFailure, isTrue);
      result.fold(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (AppException e) {
          expect(e.code, 'network/http-404');
          expect(e.message, contains('DELETE /v1/x'));
        },
      );
      expect(logger.lines.single, startsWith('error:'));
    });
  });

  group('mapDioException', () {
    RequestOptions options() => RequestOptions(path: '/v1/x');

    test('maps every DioExceptionType to a stable network code', () {
      final Map<DioExceptionType, String> expected = <DioExceptionType, String>{
        DioExceptionType.connectionTimeout: 'network/timeout',
        DioExceptionType.sendTimeout: 'network/timeout',
        DioExceptionType.receiveTimeout: 'network/timeout',
        DioExceptionType.connectionError: 'network/no-connection',
        DioExceptionType.cancel: 'network/cancelled',
        DioExceptionType.badCertificate: 'network/bad-certificate',
        DioExceptionType.unknown: 'network/unknown',
      };
      expected.forEach((DioExceptionType type, String code) {
        final AppException mapped = mapDioException(
          'GET',
          '/v1/x',
          DioException(requestOptions: options(), type: type),
          StackTrace.current,
        );
        expect(mapped.code, code, reason: '$type');
      });
    });

    test('includes the status code for bad responses', () {
      final AppException mapped = mapDioException(
        'GET',
        '/v1/x',
        DioException.badResponse(
          statusCode: 503,
          requestOptions: options(),
          response: Response<Object?>(
            requestOptions: options(),
            statusCode: 503,
          ),
        ),
        StackTrace.current,
      );
      expect(mapped.code, 'network/http-503');
    });
  });
}
