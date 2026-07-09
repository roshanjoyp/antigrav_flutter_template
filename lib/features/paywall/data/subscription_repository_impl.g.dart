// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-wide [SubscriptionRepository] binding.
///
/// Defaults to [StubSubscriptionRepository]; when RevenueCat is enabled
/// the override list in `lib/app/config/revenuecat_overrides.dart` binds
/// `RevenueCatSubscriptionRepositoryImpl` instead.

@ProviderFor(subscriptionRepository)
final subscriptionRepositoryProvider = SubscriptionRepositoryProvider._();

/// Provides the app-wide [SubscriptionRepository] binding.
///
/// Defaults to [StubSubscriptionRepository]; when RevenueCat is enabled
/// the override list in `lib/app/config/revenuecat_overrides.dart` binds
/// `RevenueCatSubscriptionRepositoryImpl` instead.

final class SubscriptionRepositoryProvider
    extends
        $FunctionalProvider<
          SubscriptionRepository,
          SubscriptionRepository,
          SubscriptionRepository
        >
    with $Provider<SubscriptionRepository> {
  /// Provides the app-wide [SubscriptionRepository] binding.
  ///
  /// Defaults to [StubSubscriptionRepository]; when RevenueCat is enabled
  /// the override list in `lib/app/config/revenuecat_overrides.dart` binds
  /// `RevenueCatSubscriptionRepositoryImpl` instead.
  SubscriptionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SubscriptionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubscriptionRepository create(Ref ref) {
    return subscriptionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubscriptionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubscriptionRepository>(value),
    );
  }
}

String _$subscriptionRepositoryHash() =>
    r'b4010ac55710441382ba9d4279869e706bf84c11';
