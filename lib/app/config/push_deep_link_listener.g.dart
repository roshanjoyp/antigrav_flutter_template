// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_deep_link_listener.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Routes notification taps to their in-app destination.
///
/// Covers both tap entry points: the message that launched the app from
/// a terminated state ([PushService.getInitialMessage]) and taps that
/// foregrounded a backgrounded app ([PushService.onMessageOpened]).
/// Messages carrying a `route` key in their data payload (see
/// [PushMessage.route]) are sent to that go_router location; messages
/// without one are ignored here.
///
/// Activated by a single `ref.watch` in the root `App` widget, so it
/// lives exactly as long as the app UI. Works identically with the
/// debug and FCM implementations.

@ProviderFor(pushDeepLinkListener)
final pushDeepLinkListenerProvider = PushDeepLinkListenerProvider._();

/// Routes notification taps to their in-app destination.
///
/// Covers both tap entry points: the message that launched the app from
/// a terminated state ([PushService.getInitialMessage]) and taps that
/// foregrounded a backgrounded app ([PushService.onMessageOpened]).
/// Messages carrying a `route` key in their data payload (see
/// [PushMessage.route]) are sent to that go_router location; messages
/// without one are ignored here.
///
/// Activated by a single `ref.watch` in the root `App` widget, so it
/// lives exactly as long as the app UI. Works identically with the
/// debug and FCM implementations.

final class PushDeepLinkListenerProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Routes notification taps to their in-app destination.
  ///
  /// Covers both tap entry points: the message that launched the app from
  /// a terminated state ([PushService.getInitialMessage]) and taps that
  /// foregrounded a backgrounded app ([PushService.onMessageOpened]).
  /// Messages carrying a `route` key in their data payload (see
  /// [PushMessage.route]) are sent to that go_router location; messages
  /// without one are ignored here.
  ///
  /// Activated by a single `ref.watch` in the root `App` widget, so it
  /// lives exactly as long as the app UI. Works identically with the
  /// debug and FCM implementations.
  PushDeepLinkListenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushDeepLinkListenerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushDeepLinkListenerHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return pushDeepLinkListener(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pushDeepLinkListenerHash() =>
    r'c798c2c1cd7a05b56cf6d62ce325ee172a865796';
