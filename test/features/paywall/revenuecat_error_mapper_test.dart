import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:antigrav_flutter_template/features/paywall/data/revenuecat_error_mapper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Builds the [PlatformException] RevenueCat throws for [code].
///
/// The SDK encodes the [PurchasesErrorCode] as the exception's `code`
/// string — its enum index, exactly what `PurchasesErrorHelper` parses.
PlatformException exceptionFor(PurchasesErrorCode code) =>
    PlatformException(code: '${code.index}', message: 'store says no');

void main() {
  group('mapRevenueCatError', () {
    test('maps user cancellation to paywall/purchase-cancelled', () {
      final AppException exception = mapRevenueCatError(
        exceptionFor(PurchasesErrorCode.purchaseCancelledError),
        StackTrace.empty,
      );
      expect(exception.code, 'paywall/purchase-cancelled');
    });

    test('maps network and offline errors to paywall/network', () {
      for (final PurchasesErrorCode code in <PurchasesErrorCode>[
        PurchasesErrorCode.networkError,
        PurchasesErrorCode.offlineConnectionError,
      ]) {
        expect(
          mapRevenueCatError(exceptionFor(code), StackTrace.empty).code,
          'paywall/network',
        );
      }
    });

    test('maps configuration problems to paywall/configuration', () {
      for (final PurchasesErrorCode code in <PurchasesErrorCode>[
        PurchasesErrorCode.configurationError,
        PurchasesErrorCode.invalidCredentialsError,
      ]) {
        expect(
          mapRevenueCatError(exceptionFor(code), StackTrace.empty).code,
          'paywall/configuration',
        );
      }
    });

    test('maps already-purchased to a restore hint', () {
      final AppException exception = mapRevenueCatError(
        exceptionFor(PurchasesErrorCode.productAlreadyPurchasedError),
        StackTrace.empty,
      );
      expect(exception.code, 'paywall/already-purchased');
      expect(exception.message, contains('restoring'));
    });

    test('maps unrecognised store errors to paywall/unknown', () {
      final AppException exception = mapRevenueCatError(
        exceptionFor(PurchasesErrorCode.unknownBackendError),
        StackTrace.empty,
      );
      expect(exception.code, 'paywall/unknown');
      expect(exception.originalError, isA<PlatformException>());
    });

    test('passes an existing AppException through untouched', () {
      const AppException original = AppException(
        message: 'stale package',
        code: 'paywall/package-not-found',
      );
      expect(
        identical(mapRevenueCatError(original, StackTrace.empty), original),
        isTrue,
      );
    });

    test('wraps non-platform errors as paywall/unknown', () {
      final AppException exception = mapRevenueCatError(
        StateError('boom'),
        StackTrace.empty,
      );
      expect(exception.code, 'paywall/unknown');
      expect(exception.originalError, isA<StateError>());
    });
  });
}
