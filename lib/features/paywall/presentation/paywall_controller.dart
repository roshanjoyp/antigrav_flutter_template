import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:craft_flutter_template/features/paywall/data/subscription_repository_impl.dart';
import 'package:craft_flutter_template/features/paywall/domain/paywall_offering_entity.dart';
import 'package:craft_flutter_template/features/paywall/domain/subscription_repository.dart';
import 'package:craft_flutter_template/features/paywall/domain/subscription_status_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paywall_controller.g.dart';

/// Streams the user's subscription status to the UI.
///
/// Gate premium content anywhere in the app by watching this provider
/// and checking `isSubscribed` — the stream updates on purchase,
/// restore, renewal, and expiration.
@riverpod
Stream<SubscriptionStatusEntity> subscriptionStatus(Ref ref) {
  return ref.watch(subscriptionRepositoryProvider).watchStatus();
}

/// Controller for the paywall screen.
///
/// `build()` loads the offering to display; [purchase] and [restore]
/// return their [Result] so the view can show feedback without owning
/// any business logic. Subscription state itself comes from the
/// separate [subscriptionStatus] stream provider, which updates
/// automatically after either action succeeds.
@riverpod
class PaywallController extends _$PaywallController {
  @override
  Future<PaywallOfferingEntity?> build() async {
    final SubscriptionRepository repository = ref.watch(
      subscriptionRepositoryProvider,
    );
    final Result<PaywallOfferingEntity?> result = await repository
        .fetchOffering();
    // Surface failures as AsyncError so the view's error state renders.
    return result.fold(
      onSuccess: (PaywallOfferingEntity? offering) => offering,
      onFailure: (AppException exception) => throw exception,
    );
  }

  /// Purchases [package] and returns the outcome.
  ///
  /// A failure with code `'paywall/purchase-cancelled'` means the user
  /// closed the store sheet — the view should ignore it silently.
  Future<Result<SubscriptionStatusEntity>> purchase(
    PaywallPackageEntity package,
  ) {
    return ref.read(subscriptionRepositoryProvider).purchase(package);
  }

  /// Restores previous purchases and returns the updated status.
  Future<Result<SubscriptionStatusEntity>> restore() {
    return ref.read(subscriptionRepositoryProvider).restorePurchases();
  }
}
