import 'package:craft_flutter_template/core/config/revenuecat/revenuecat_config.dart';
import 'package:craft_flutter_template/features/paywall/paywall.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

/// Provider overrides that swap the stub subscription repository for
/// its RevenueCat implementation.
///
/// Same switch mechanism as `firebase_overrides.dart`: `main.dart`
/// applies [revenueCatServiceOverrides] to the root `ProviderContainer`
/// only when [RevenueCatConfig.enabled] is `true` **and** the platform
/// has a store integration ([RevenueCatConfig.isPlatformSupported]), so
/// enabling RevenueCat (see docs/setup/REVENUECAT_SETUP.md) rebinds the
/// paywall with no call-site changes anywhere.
List<Override> revenueCatServiceOverrides() => <Override>[
  subscriptionRepositoryProvider.overrideWith(
    (Ref ref) => RevenueCatSubscriptionRepositoryImpl(),
  ),
];
