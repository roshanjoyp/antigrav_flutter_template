import 'dart:async';

import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:antigrav_flutter_template/features/paywall/data/revenuecat_error_mapper.dart';
import 'package:antigrav_flutter_template/features/paywall/data/revenuecat_mappers.dart';
import 'package:antigrav_flutter_template/features/paywall/domain/paywall_offering_entity.dart';
import 'package:antigrav_flutter_template/features/paywall/domain/subscription_repository.dart';
import 'package:antigrav_flutter_template/features/paywall/domain/subscription_status_entity.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat-backed implementation of [SubscriptionRepository].
///
/// Requires `RevenueCatConfig.initialize()` to have configured the
/// `Purchases` SDK first (done in `main.dart` when RevenueCat is
/// enabled). Bound via `revenueCatServiceOverrides()` — the stub remains
/// the default binding.
///
/// SDK models never escape: mapping lives in [RevenueCatMappers] and
/// errors are normalized by [mapRevenueCatError].
class RevenueCatSubscriptionRepositoryImpl implements SubscriptionRepository {
  /// Store packages from the last fetched offering, keyed by package
  /// identifier — [purchase] resolves the SDK object it needs from here.
  final Map<String, Package> _packagesById = <String, Package>{};

  @override
  Stream<SubscriptionStatusEntity> watchStatus() {
    late final StreamController<SubscriptionStatusEntity> controller;
    void onUpdate(CustomerInfo info) =>
        controller.add(RevenueCatMappers.mapCustomerInfo(info));

    controller = StreamController<SubscriptionStatusEntity>(
      onListen: () {
        // The SDK replays the last-known CustomerInfo on registration,
        // but on a cold start none exists yet — seed with a fetch so
        // subscribers always get an initial value.
        Purchases.addCustomerInfoUpdateListener(onUpdate);
        Purchases.getCustomerInfo().then(onUpdate).catchError((
          Object error,
          StackTrace stackTrace,
        ) {
          controller.addError(mapRevenueCatError(error, stackTrace));
        });
      },
      onCancel: () {
        Purchases.removeCustomerInfoUpdateListener(onUpdate);
        // Each watchStatus() call creates a fresh controller, so the
        // stream is done for good once its subscriber cancels.
        controller.close();
      },
    );
    return controller.stream;
  }

  @override
  Future<Result<SubscriptionStatusEntity>> fetchStatus() => _guard(() async {
    final CustomerInfo info = await Purchases.getCustomerInfo();
    return RevenueCatMappers.mapCustomerInfo(info);
  });

  @override
  Future<Result<PaywallOfferingEntity?>> fetchOffering() => _guard(() async {
    final Offerings offerings = await Purchases.getOfferings();
    final Offering? current = offerings.current;
    if (current == null) return null;
    _packagesById
      ..clear()
      ..addEntries(
        current.availablePackages.map(
          (Package p) => MapEntry<String, Package>(p.identifier, p),
        ),
      );
    return RevenueCatMappers.mapOffering(current);
  });

  @override
  Future<Result<SubscriptionStatusEntity>> purchase(
    PaywallPackageEntity package,
  ) => _guard(() async {
    final Package? storePackage = _packagesById[package.id];
    if (storePackage == null) {
      throw const AppException(
        message:
            'This package is no longer available. '
            'Reload the paywall and try again.',
        code: 'paywall/package-not-found',
      );
    }
    final PurchaseResult result = await Purchases.purchase(
      PurchaseParams.package(storePackage),
    );
    return RevenueCatMappers.mapCustomerInfo(result.customerInfo);
  });

  @override
  Future<Result<SubscriptionStatusEntity>> restorePurchases() =>
      _guard(() async {
        final CustomerInfo info = await Purchases.restorePurchases();
        return RevenueCatMappers.mapCustomerInfo(info);
      });

  /// Runs [action] and wraps the outcome in a [Result], normalizing any
  /// error through [mapRevenueCatError].
  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success<T>(await action());
    } catch (error, stackTrace) {
      return Failure<T>(mapRevenueCatError(error, stackTrace));
    }
  }
}
