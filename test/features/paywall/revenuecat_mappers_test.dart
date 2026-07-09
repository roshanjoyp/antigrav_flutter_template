import 'package:craft_flutter_template/features/paywall/data/revenuecat_mappers.dart';
import 'package:craft_flutter_template/features/paywall/domain/paywall_offering_entity.dart';
import 'package:craft_flutter_template/features/paywall/domain/subscription_status_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Builds a minimal [CustomerInfo] with the given active entitlements.
CustomerInfo buildCustomerInfo({
  Map<String, EntitlementInfo> active = const <String, EntitlementInfo>{},
  String? managementUrl,
}) => CustomerInfo(
  EntitlementInfos(active, active),
  const <String, String?>{},
  const <String>[],
  const <String>[],
  const <StoreTransaction>[],
  '2026-01-01T00:00:00Z',
  'user-1',
  const <String, String?>{},
  '2026-01-01T00:00:00Z',
  managementURL: managementUrl,
);

/// A representative active entitlement fixture.
const EntitlementInfo premiumEntitlement = EntitlementInfo(
  'premium',
  true,
  true,
  '2026-01-01T00:00:00Z',
  '2026-01-01T00:00:00Z',
  'prod_monthly',
  true,
);

/// Builds a package fixture of the given [type].
Package buildPackage({
  String id = r'$rc_monthly',
  PackageType type = PackageType.monthly,
}) => Package(
  id,
  type,
  const StoreProduct(
    'prod_monthly',
    'Full access, billed monthly.',
    'Premium',
    4.99,
    r'$4.99',
    'USD',
  ),
  const PresentedOfferingContext('default', null, null),
);

void main() {
  group('RevenueCatMappers.mapCustomerInfo', () {
    test('maps active entitlements to a subscribed status', () {
      final SubscriptionStatusEntity status = RevenueCatMappers.mapCustomerInfo(
        buildCustomerInfo(
          active: <String, EntitlementInfo>{'premium': premiumEntitlement},
          managementUrl: 'https://apps.apple.com/account/subscriptions',
        ),
      );

      expect(status.isSubscribed, isTrue);
      expect(status.activeEntitlementIds, <String>['premium']);
      expect(
        status.managementUrl,
        'https://apps.apple.com/account/subscriptions',
      );
    });

    test('maps no active entitlements to an unsubscribed status', () {
      final SubscriptionStatusEntity status = RevenueCatMappers.mapCustomerInfo(
        buildCustomerInfo(),
      );

      expect(status.isSubscribed, isFalse);
      expect(status.activeEntitlementIds, isEmpty);
      expect(status.managementUrl, isNull);
    });
  });

  group('RevenueCatMappers.mapOffering', () {
    test('maps identifier, packages, and store product fields', () {
      final PaywallOfferingEntity offering = RevenueCatMappers.mapOffering(
        Offering('default', 'Main paywall', const <String, Object>{}, <Package>[
          buildPackage(),
          buildPackage(id: r'$rc_annual', type: PackageType.annual),
        ]),
      );

      expect(offering.id, 'default');
      expect(offering.packages, hasLength(2));
      final PaywallPackageEntity monthly = offering.packages.first;
      expect(monthly.id, r'$rc_monthly');
      expect(monthly.title, 'Premium');
      expect(monthly.description, 'Full access, billed monthly.');
      expect(monthly.priceString, r'$4.99');
      expect(monthly.periodLabel, 'Monthly');
      expect(offering.packages.last.periodLabel, 'Annual');
    });
  });

  group('RevenueCatMappers.mapPackageTypeLabel', () {
    test('labels every package type', () {
      expect(
        RevenueCatMappers.mapPackageTypeLabel(PackageType.lifetime),
        'Lifetime',
      );
      expect(
        RevenueCatMappers.mapPackageTypeLabel(PackageType.weekly),
        'Weekly',
      );
      expect(
        RevenueCatMappers.mapPackageTypeLabel(PackageType.custom),
        'One-time',
      );
      expect(
        RevenueCatMappers.mapPackageTypeLabel(PackageType.unknown),
        'One-time',
      );
    });
  });
}
