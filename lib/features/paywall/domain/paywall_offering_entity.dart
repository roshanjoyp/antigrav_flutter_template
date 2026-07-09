import 'package:freezed_annotation/freezed_annotation.dart';

part 'paywall_offering_entity.freezed.dart';

/// Domain representation of a purchasable paywall offering.
///
/// An offering is the set of packages (monthly, annual, lifetime, …)
/// presented together on one paywall. Vendor-agnostic: the data layer
/// maps provider types (RevenueCat `Offering`/`Package`) into this
/// aggregate so the UI never touches SDK models.
@freezed
abstract class PaywallOfferingEntity with _$PaywallOfferingEntity {
  /// Creates a [PaywallOfferingEntity].
  const factory PaywallOfferingEntity({
    /// The offering's unique identifier (e.g. `'default'`).
    required String id,

    /// The purchasable packages in display order.
    @Default(<PaywallPackageEntity>[]) List<PaywallPackageEntity> packages,
  }) = _PaywallOfferingEntity;
}

/// A single purchasable package within a [PaywallOfferingEntity].
@freezed
abstract class PaywallPackageEntity with _$PaywallPackageEntity {
  /// Creates a [PaywallPackageEntity].
  const factory PaywallPackageEntity({
    /// The package's unique identifier within its offering
    /// (e.g. `'$rc_monthly'`). Used to resolve the underlying store
    /// package at purchase time.
    required String id,

    /// The product's display title from the store (e.g. `'Premium'`).
    required String title,

    /// The product's display description from the store.
    required String description,

    /// The localized, formatted price string (e.g. `'$9.99'`).
    required String priceString,

    /// Human-readable billing period label (e.g. `'Monthly'`,
    /// `'Annual'`, `'Lifetime'`).
    required String periodLabel,
  }) = _PaywallPackageEntity;
}
