// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_service_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-wide [NetworkService].
///
/// Binds the stub by default; `bootstrap.dart` overrides this with the
/// Dio-backed implementation when `NetworkConfig.enabled` is `true`
/// (see lib/app/config/network_overrides.dart).

@ProviderFor(networkService)
final networkServiceProvider = NetworkServiceProvider._();

/// Provides the app-wide [NetworkService].
///
/// Binds the stub by default; `bootstrap.dart` overrides this with the
/// Dio-backed implementation when `NetworkConfig.enabled` is `true`
/// (see lib/app/config/network_overrides.dart).

final class NetworkServiceProvider
    extends $FunctionalProvider<NetworkService, NetworkService, NetworkService>
    with $Provider<NetworkService> {
  /// Provides the app-wide [NetworkService].
  ///
  /// Binds the stub by default; `bootstrap.dart` overrides this with the
  /// Dio-backed implementation when `NetworkConfig.enabled` is `true`
  /// (see lib/app/config/network_overrides.dart).
  NetworkServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkServiceHash();

  @$internal
  @override
  $ProviderElement<NetworkService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NetworkService create(Ref ref) {
    return networkService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkService>(value),
    );
  }
}

String _$networkServiceHash() => r'bf05ca051c0ce39f30adfa39bd1ca77dddb37bf2';
