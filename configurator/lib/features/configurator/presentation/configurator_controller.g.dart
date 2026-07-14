// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configurator_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the platform [DownloadService].

@ProviderFor(downloadService)
final downloadServiceProvider = DownloadServiceProvider._();

/// Provides the platform [DownloadService].

final class DownloadServiceProvider
    extends
        $FunctionalProvider<DownloadService, DownloadService, DownloadService>
    with $Provider<DownloadService> {
  /// Provides the platform [DownloadService].
  DownloadServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadServiceHash();

  @$internal
  @override
  $ProviderElement<DownloadService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DownloadService create(Ref ref) {
    return downloadService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DownloadService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DownloadService>(value),
    );
  }
}

String _$downloadServiceHash() => r'c1c04928b460401545c628aa5756ebfad512d77e';

/// Holds the buyer's configuration and applies every mutation the form
/// can make; widgets stay logic-free and only call these methods.

@ProviderFor(ConfiguratorController)
final configuratorControllerProvider = ConfiguratorControllerProvider._();

/// Holds the buyer's configuration and applies every mutation the form
/// can make; widgets stay logic-free and only call these methods.
final class ConfiguratorControllerProvider
    extends $NotifierProvider<ConfiguratorController, ConfigurationEntity> {
  /// Holds the buyer's configuration and applies every mutation the form
  /// can make; widgets stay logic-free and only call these methods.
  ConfiguratorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'configuratorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$configuratorControllerHash();

  @$internal
  @override
  ConfiguratorController create() => ConfiguratorController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConfigurationEntity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConfigurationEntity>(value),
    );
  }
}

String _$configuratorControllerHash() =>
    r'1050964313dfff8b0bd792edacbc60fa8aa2aeac';

/// Holds the buyer's configuration and applies every mutation the form
/// can make; widgets stay logic-free and only call these methods.

abstract class _$ConfiguratorController extends $Notifier<ConfigurationEntity> {
  ConfigurationEntity build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ConfigurationEntity, ConfigurationEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConfigurationEntity, ConfigurationEntity>,
              ConfigurationEntity,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
