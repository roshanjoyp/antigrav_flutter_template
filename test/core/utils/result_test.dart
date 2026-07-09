import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const AppException exception = AppException(
    message: 'Something failed',
    code: 'test/failure',
  );

  group('Success', () {
    const Result<int> result = Success<int>(42);

    test('isSuccess / isFailure', () {
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
    });

    test('getOrNull returns the value', () {
      expect(result.getOrNull(), 42);
    });

    test('getOrElse returns the value, not the fallback', () {
      expect(result.getOrElse(0), 42);
    });

    test('fold calls onSuccess', () {
      final String label = result.fold(
        onSuccess: (int value) => 'value: $value',
        onFailure: (AppException e) => 'error: ${e.message}',
      );
      expect(label, 'value: 42');
    });

    test('mapSuccess transforms the value', () {
      final Result<String> mapped =
          result.mapSuccess((int value) => 'v$value');
      expect(mapped.getOrNull(), 'v42');
    });
  });

  group('Failure', () {
    const Result<int> result = Failure<int>(exception);

    test('isSuccess / isFailure', () {
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
    });

    test('getOrNull returns null', () {
      expect(result.getOrNull(), isNull);
    });

    test('getOrElse returns the fallback', () {
      expect(result.getOrElse(7), 7);
    });

    test('fold calls onFailure', () {
      final String label = result.fold(
        onSuccess: (int value) => 'value: $value',
        onFailure: (AppException e) => 'error: ${e.code}',
      );
      expect(label, 'error: test/failure');
    });

    test('mapSuccess keeps the failure untouched', () {
      final Result<String> mapped =
          result.mapSuccess((int value) => 'v$value');
      expect(mapped.isFailure, isTrue);
      expect((mapped as Failure<String>).exception, same(exception));
    });
  });

  group('AppException', () {
    test('toString includes message, code and cause', () {
      final AppException e = AppException(
        message: 'Broken',
        code: 'x/y',
        originalError: StateError('inner'),
      );
      final String text = e.toString();
      expect(text, contains('Broken'));
      expect(text, contains('x/y'));
      expect(text, contains('inner'));
    });

    test('toString omits absent code and cause', () {
      const AppException e = AppException(message: 'Just a message');
      expect(e.toString(), 'AppException: Just a message');
    });
  });
}
