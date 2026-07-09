import 'package:craft_flutter_template/features/paywall/domain/paywall_offering_entity.dart';
import 'package:craft_flutter_template/features/paywall/domain/subscription_status_entity.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Pure mapping functions from RevenueCat SDK models to domain entities.
///
/// Kept free of `Purchases` static calls so they are unit-testable by
/// constructing SDK model objects directly (see
/// test/features/paywall/revenuecat_mappers_test.dart). All SDK types
/// stop here — nothing above the data layer sees them.
class RevenueCatMappers {
  /// Not instantiable — all members are static.
  const RevenueCatMappers._();

  /// Maps a RevenueCat [CustomerInfo] to the domain status entity.
  static SubscriptionStatusEntity mapCustomerInfo(CustomerInfo info) {
    final List<String> active = info.entitlements.active.keys.toList();
    return SubscriptionStatusEntity(
      isSubscribed: active.isNotEmpty,
      activeEntitlementIds: active,
      managementUrl: info.managementURL,
    );
  }

  /// Maps a RevenueCat [Offering] to the domain offering entity.
  static PaywallOfferingEntity mapOffering(Offering offering) {
    return PaywallOfferingEntity(
      id: offering.identifier,
      packages: offering.availablePackages
          .map(RevenueCatMappers.mapPackage)
          .toList(),
    );
  }

  /// Maps a RevenueCat [Package] to the domain package entity.
  static PaywallPackageEntity mapPackage(Package package) {
    return PaywallPackageEntity(
      id: package.identifier,
      title: package.storeProduct.title,
      description: package.storeProduct.description,
      priceString: package.storeProduct.priceString,
      periodLabel: mapPackageTypeLabel(package.packageType),
    );
  }

  /// Human-readable billing-period label for a [PackageType].
  ///
  /// Falls back to `'One-time'` for custom/unknown package types, which
  /// RevenueCat uses for non-standard identifiers.
  static String mapPackageTypeLabel(PackageType type) => switch (type) {
    PackageType.monthly => 'Monthly',
    PackageType.annual => 'Annual',
    PackageType.weekly => 'Weekly',
    PackageType.twoMonth => 'Every 2 months',
    PackageType.threeMonth => 'Quarterly',
    PackageType.sixMonth => 'Every 6 months',
    PackageType.lifetime => 'Lifetime',
    PackageType.custom || PackageType.unknown => 'One-time',
  };
}
