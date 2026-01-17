// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_service_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(logService)
final logServiceProvider = LogServiceProvider._();

final class LogServiceProvider
    extends $FunctionalProvider<LogService, LogService, LogService>
    with $Provider<LogService> {
  LogServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logServiceHash();

  @$internal
  @override
  $ProviderElement<LogService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogService create(Ref ref) {
    return logService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogService>(value),
    );
  }
}

String _$logServiceHash() => r'cfc8e2b44f70a475b50e8683ea5d7883b865a23d';
