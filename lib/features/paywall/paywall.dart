/// Barrel export for the paywall feature.
///
/// Monetization module: subscription status + in-app purchases behind
/// the vendor-agnostic `SubscriptionRepository` contract. Ships bound
/// to a stub; enable RevenueCat via `RevenueCatConfig` and the override
/// list in `lib/app/config/revenuecat_overrides.dart`
/// (see docs/setup/REVENUECAT_SETUP.md).
library;

// Domain
export 'package:craft_flutter_template/features/paywall/domain/paywall_offering_entity.dart';
export 'package:craft_flutter_template/features/paywall/domain/subscription_repository.dart';
export 'package:craft_flutter_template/features/paywall/domain/subscription_status_entity.dart';

// Data — exported for the Riverpod provider (subscriptionRepositoryProvider)
export 'package:craft_flutter_template/features/paywall/data/subscription_repository_impl.dart';

// Data — RevenueCat implementation, bound when RevenueCat is enabled
export 'package:craft_flutter_template/features/paywall/data/revenuecat_subscription_repository_impl.dart';

// Presentation
export 'package:craft_flutter_template/features/paywall/presentation/paywall_controller.dart';
export 'package:craft_flutter_template/features/paywall/presentation/paywall_screen.dart';
