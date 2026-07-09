// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_service_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-wide [PushService] binding.
///
/// Defaults to [DebugPushService]; when Firebase is enabled the override
/// list in `lib/app/config/firebase_overrides.dart` binds
/// `FirebasePushServiceImpl` instead.

@ProviderFor(pushService)
final pushServiceProvider = PushServiceProvider._();

/// Provides the app-wide [PushService] binding.
///
/// Defaults to [DebugPushService]; when Firebase is enabled the override
/// list in `lib/app/config/firebase_overrides.dart` binds
/// `FirebasePushServiceImpl` instead.

final class PushServiceProvider
    extends $FunctionalProvider<PushService, PushService, PushService>
    with $Provider<PushService> {
  /// Provides the app-wide [PushService] binding.
  ///
  /// Defaults to [DebugPushService]; when Firebase is enabled the override
  /// list in `lib/app/config/firebase_overrides.dart` binds
  /// `FirebasePushServiceImpl` instead.
  PushServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushServiceHash();

  @$internal
  @override
  $ProviderElement<PushService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushService create(Ref ref) {
    return pushService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushService>(value),
    );
  }
}

String _$pushServiceHash() => r'cccf9e7483acff1b84abf68a38036d998feddae3';
