// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_service_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-wide [StorageService] binding.
///
/// Bound to [SecureStorageServiceImpl] by default — a real
/// implementation, so no backend module needs to override it.

@ProviderFor(storageService)
final storageServiceProvider = StorageServiceProvider._();

/// Provides the app-wide [StorageService] binding.
///
/// Bound to [SecureStorageServiceImpl] by default — a real
/// implementation, so no backend module needs to override it.

final class StorageServiceProvider
    extends $FunctionalProvider<StorageService, StorageService, StorageService>
    with $Provider<StorageService> {
  /// Provides the app-wide [StorageService] binding.
  ///
  /// Bound to [SecureStorageServiceImpl] by default — a real
  /// implementation, so no backend module needs to override it.
  StorageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageServiceHash();

  @$internal
  @override
  $ProviderElement<StorageService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StorageService create(Ref ref) {
    return storageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StorageService>(value),
    );
  }
}

String _$storageServiceHash() => r'bfb6b2d120cf7ac9f8dad4ea0968186d64ad5bfa';
