// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paywall_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Streams the user's subscription status to the UI.
///
/// Gate premium content anywhere in the app by watching this provider
/// and checking `isSubscribed` — the stream updates on purchase,
/// restore, renewal, and expiration.

@ProviderFor(subscriptionStatus)
final subscriptionStatusProvider = SubscriptionStatusProvider._();

/// Streams the user's subscription status to the UI.
///
/// Gate premium content anywhere in the app by watching this provider
/// and checking `isSubscribed` — the stream updates on purchase,
/// restore, renewal, and expiration.

final class SubscriptionStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubscriptionStatusEntity>,
          SubscriptionStatusEntity,
          Stream<SubscriptionStatusEntity>
        >
    with
        $FutureModifier<SubscriptionStatusEntity>,
        $StreamProvider<SubscriptionStatusEntity> {
  /// Streams the user's subscription status to the UI.
  ///
  /// Gate premium content anywhere in the app by watching this provider
  /// and checking `isSubscribed` — the stream updates on purchase,
  /// restore, renewal, and expiration.
  SubscriptionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionStatusHash();

  @$internal
  @override
  $StreamProviderElement<SubscriptionStatusEntity> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SubscriptionStatusEntity> create(Ref ref) {
    return subscriptionStatus(ref);
  }
}

String _$subscriptionStatusHash() =>
    r'efd6014b34ebf1555289acbddb1f69a5ced17e55';

/// Controller for the paywall screen.
///
/// `build()` loads the offering to display; [purchase] and [restore]
/// return their [Result] so the view can show feedback without owning
/// any business logic. Subscription state itself comes from the
/// separate [subscriptionStatus] stream provider, which updates
/// automatically after either action succeeds.

@ProviderFor(PaywallController)
final paywallControllerProvider = PaywallControllerProvider._();

/// Controller for the paywall screen.
///
/// `build()` loads the offering to display; [purchase] and [restore]
/// return their [Result] so the view can show feedback without owning
/// any business logic. Subscription state itself comes from the
/// separate [subscriptionStatus] stream provider, which updates
/// automatically after either action succeeds.
final class PaywallControllerProvider
    extends $AsyncNotifierProvider<PaywallController, PaywallOfferingEntity?> {
  /// Controller for the paywall screen.
  ///
  /// `build()` loads the offering to display; [purchase] and [restore]
  /// return their [Result] so the view can show feedback without owning
  /// any business logic. Subscription state itself comes from the
  /// separate [subscriptionStatus] stream provider, which updates
  /// automatically after either action succeeds.
  PaywallControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paywallControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paywallControllerHash();

  @$internal
  @override
  PaywallController create() => PaywallController();
}

String _$paywallControllerHash() => r'f2a07bdbbda73283b6f3aa5a52ab600608431a2e';

/// Controller for the paywall screen.
///
/// `build()` loads the offering to display; [purchase] and [restore]
/// return their [Result] so the view can show feedback without owning
/// any business logic. Subscription state itself comes from the
/// separate [subscriptionStatus] stream provider, which updates
/// automatically after either action succeeds.

abstract class _$PaywallController
    extends $AsyncNotifier<PaywallOfferingEntity?> {
  FutureOr<PaywallOfferingEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PaywallOfferingEntity?>, PaywallOfferingEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaywallOfferingEntity?>,
                PaywallOfferingEntity?
              >,
              AsyncValue<PaywallOfferingEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
