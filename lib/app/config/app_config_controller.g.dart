// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppConfigController)
final appConfigControllerProvider = AppConfigControllerProvider._();

final class AppConfigControllerProvider
    extends $NotifierProvider<AppConfigController, AppConfigState> {
  AppConfigControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigControllerHash();

  @$internal
  @override
  AppConfigController create() => AppConfigController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppConfigState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppConfigState>(value),
    );
  }
}

String _$appConfigControllerHash() =>
    r'b1fbef22bca32be78d100ea75f3ce5674d8201b8';

abstract class _$AppConfigController extends $Notifier<AppConfigState> {
  AppConfigState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppConfigState, AppConfigState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppConfigState, AppConfigState>,
              AppConfigState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
