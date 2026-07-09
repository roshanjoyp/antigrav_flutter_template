import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:antigrav_flutter_template/features/paywall/domain/paywall_offering_entity.dart';
import 'package:antigrav_flutter_template/features/paywall/domain/subscription_status_entity.dart';

/// Contract for subscription status and in-app purchases.
///
/// Implementations wrap a monetization provider (RevenueCat in this
/// template) or a stub. Access it via the `subscriptionRepositoryProvider`
/// Riverpod provider — never construct implementations directly in the
/// presentation layer.
///
/// Error codes follow the `'paywall/...'` convention. One code is special:
/// `'paywall/purchase-cancelled'` means the **user** dismissed the store
/// sheet — treat it as a non-event in the UI (no error message), not a
/// failure to report.
abstract class SubscriptionRepository {
  /// Emits the subscription status now and whenever it changes
  /// (purchase, renewal, expiration, restore).
  ///
  /// Emits [AppException] as a stream error if the provider fails.
  Stream<SubscriptionStatusEntity> watchStatus();

  /// Fetches the current subscription status once.
  Future<Result<SubscriptionStatusEntity>> fetchStatus();

  /// Fetches the offering to display on the paywall.
  ///
  /// Returns `Success(null)` when the provider has no current offering
  /// configured (an empty paywall, not an error).
  Future<Result<PaywallOfferingEntity?>> fetchOffering();

  /// Purchases [package] through the store.
  ///
  /// Returns the updated status on success. Fails with code
  /// `'paywall/purchase-cancelled'` when the user dismisses the store
  /// sheet — callers should ignore that failure silently.
  Future<Result<SubscriptionStatusEntity>> purchase(
    PaywallPackageEntity package,
  );

  /// Restores previously made purchases for the signed-in store account.
  ///
  /// Returns the updated status; check `isSubscribed` to tell the user
  /// whether anything was restored.
  Future<Result<SubscriptionStatusEntity>> restorePurchases();
}
