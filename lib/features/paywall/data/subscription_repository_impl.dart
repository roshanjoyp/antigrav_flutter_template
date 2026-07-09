import 'dart:async';

import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:craft_flutter_template/features/paywall/domain/paywall_offering_entity.dart';
import 'package:craft_flutter_template/features/paywall/domain/subscription_repository.dart';
import 'package:craft_flutter_template/features/paywall/domain/subscription_status_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_repository_impl.g.dart';

/// Stub [SubscriptionRepository] used while no store is configured.
///
/// Serves a fake offering and flips an in-memory entitlement on
/// "purchase", so the full paywall → purchase → unlocked loop is
/// demonstrable offline with no store accounts. Nothing is persisted
/// across restarts.
///
/// Template note: this stub is the default binding of
/// `subscriptionRepositoryProvider`. Do not replace it — when RevenueCat
/// is enabled, `RevenueCatSubscriptionRepositoryImpl` is bound instead
/// (see docs/setup/REVENUECAT_SETUP.md).
class StubSubscriptionRepository implements SubscriptionRepository {
  /// The entitlement granted by the fake purchase flow.
  static const String stubEntitlementId = 'premium';

  /// The fake offering served by [fetchOffering].
  static const PaywallOfferingEntity stubOffering = PaywallOfferingEntity(
    id: 'default',
    packages: <PaywallPackageEntity>[
      PaywallPackageEntity(
        id: r'$rc_monthly',
        title: 'Premium',
        description: 'Full access, billed monthly.',
        priceString: r'$4.99',
        periodLabel: 'Monthly',
      ),
      PaywallPackageEntity(
        id: r'$rc_annual',
        title: 'Premium',
        description: 'Full access, billed yearly.',
        priceString: r'$39.99',
        periodLabel: 'Annual',
      ),
      PaywallPackageEntity(
        id: r'$rc_lifetime',
        title: 'Premium',
        description: 'Full access, forever.',
        priceString: r'$99.99',
        periodLabel: 'Lifetime',
      ),
    ],
  );

  SubscriptionStatusEntity _status = const SubscriptionStatusEntity();

  /// Emits whenever the in-memory status changes.
  final StreamController<SubscriptionStatusEntity> _changes =
      StreamController<SubscriptionStatusEntity>.broadcast();

  @override
  Stream<SubscriptionStatusEntity> watchStatus() async* {
    yield _status;
    // yield* (not `await for`) so subscription cancellation propagates
    // to the inner stream immediately instead of leaking the generator.
    yield* _changes.stream;
  }

  @override
  Future<Result<SubscriptionStatusEntity>> fetchStatus() async {
    await Future<void>.delayed(AppConstants.durationStubNetwork);
    return Success<SubscriptionStatusEntity>(_status);
  }

  @override
  Future<Result<PaywallOfferingEntity?>> fetchOffering() async {
    await Future<void>.delayed(AppConstants.durationStubNetwork);
    return const Success<PaywallOfferingEntity?>(stubOffering);
  }

  @override
  Future<Result<SubscriptionStatusEntity>> purchase(
    PaywallPackageEntity package,
  ) async {
    await Future<void>.delayed(AppConstants.durationStubNetwork);
    _status = const SubscriptionStatusEntity(
      isSubscribed: true,
      activeEntitlementIds: <String>[stubEntitlementId],
    );
    _changes.add(_status);
    return Success<SubscriptionStatusEntity>(_status);
  }

  @override
  Future<Result<SubscriptionStatusEntity>> restorePurchases() async {
    await Future<void>.delayed(AppConstants.durationStubNetwork);
    // The stub has nothing to restore — it just reports the current
    // in-memory status, mirroring a store account with no purchases.
    return Success<SubscriptionStatusEntity>(_status);
  }
}

/// Provides the app-wide [SubscriptionRepository] binding.
///
/// Defaults to [StubSubscriptionRepository]; when RevenueCat is enabled
/// the override list in `lib/app/config/revenuecat_overrides.dart` binds
/// `RevenueCatSubscriptionRepositoryImpl` instead.
@Riverpod(keepAlive: true)
SubscriptionRepository subscriptionRepository(Ref ref) {
  return StubSubscriptionRepository();
}
