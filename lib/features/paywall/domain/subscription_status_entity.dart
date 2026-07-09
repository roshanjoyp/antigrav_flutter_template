import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_status_entity.freezed.dart';

/// Domain representation of the user's subscription state.
///
/// Pure domain object — deliberately has **no** store/SDK types.
/// Provider-specific concepts (RevenueCat `CustomerInfo`, entitlement
/// objects, store transactions) live in the data layer and are mapped
/// into this entity, keeping the presentation layer vendor-agnostic.
@freezed
abstract class SubscriptionStatusEntity with _$SubscriptionStatusEntity {
  /// Creates a [SubscriptionStatusEntity].
  const factory SubscriptionStatusEntity({
    /// Whether the user currently has at least one active entitlement.
    @Default(false) bool isSubscribed,

    /// Identifiers of all currently active entitlements
    /// (e.g. `['premium']`). Empty when [isSubscribed] is `false`.
    @Default(<String>[]) List<String> activeEntitlementIds,

    /// URL of the store's subscription-management page for this user,
    /// if the provider exposes one. Useful for a "Manage subscription"
    /// button.
    String? managementUrl,
  }) = _SubscriptionStatusEntity;
}
