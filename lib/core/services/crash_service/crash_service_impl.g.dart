// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crash_service_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(crashService)
final crashServiceProvider = CrashServiceProvider._();

final class CrashServiceProvider
    extends $FunctionalProvider<CrashService, CrashService, CrashService>
    with $Provider<CrashService> {
  CrashServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crashServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crashServiceHash();

  @$internal
  @override
  $ProviderElement<CrashService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CrashService create(Ref ref) {
    return crashService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrashService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrashService>(value),
    );
  }
}

String _$crashServiceHash() => r'6981d2f34573cd8b3e0d25deb82bc6d8609dca15';
