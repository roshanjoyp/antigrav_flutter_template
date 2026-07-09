import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Maps RevenueCat/store errors into the app's [AppException] contract.
///
/// RevenueCat surfaces errors as [PlatformException]s whose code resolves
/// to a [PurchasesErrorCode] via [PurchasesErrorHelper]. This mapper
/// translates the ones a paywall UI must distinguish into stable
/// `'paywall/...'` codes; everything else becomes `'paywall/unknown'`.
///
/// `'paywall/purchase-cancelled'` is special: the user closed the store
/// sheet on purpose. Callers must treat it as a non-event, not an error.
AppException mapRevenueCatError(Object error, StackTrace stackTrace) {
  // Already mapped — pass through untouched.
  if (error is AppException) return error;

  if (error is PlatformException) {
    final PurchasesErrorCode code = PurchasesErrorHelper.getErrorCode(error);
    final (String appCode, String message) = switch (code) {
      PurchasesErrorCode.purchaseCancelledError => (
        'paywall/purchase-cancelled',
        'Purchase cancelled.',
      ),
      PurchasesErrorCode.networkError ||
      PurchasesErrorCode.offlineConnectionError => (
        'paywall/network',
        'A network error occurred. Check your connection and try again.',
      ),
      PurchasesErrorCode.purchaseNotAllowedError => (
        'paywall/not-allowed',
        'Purchases are not allowed on this device or account.',
      ),
      PurchasesErrorCode.paymentPendingError => (
        'paywall/payment-pending',
        'Your payment is pending approval. Access unlocks once it '
            'completes.',
      ),
      PurchasesErrorCode.productAlreadyPurchasedError => (
        'paywall/already-purchased',
        'You already own this product. Try restoring purchases.',
      ),
      PurchasesErrorCode.productNotAvailableForPurchaseError => (
        'paywall/product-unavailable',
        'This product is not available for purchase right now.',
      ),
      PurchasesErrorCode.storeProblemError => (
        'paywall/store-problem',
        'The store had a problem processing the request. '
            'Try again later.',
      ),
      PurchasesErrorCode.configurationError ||
      PurchasesErrorCode.invalidCredentialsError => (
        'paywall/configuration',
        'The store is misconfigured. See docs/setup/REVENUECAT_SETUP.md.',
      ),
      _ => (
        'paywall/unknown',
        'Something went wrong with the store. Please try again.',
      ),
    };
    return AppException(
      message: message,
      code: appCode,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  return AppException(
    message: 'Something went wrong with the store. Please try again.',
    code: 'paywall/unknown',
    originalError: error,
    stackTrace: stackTrace,
  );
}
