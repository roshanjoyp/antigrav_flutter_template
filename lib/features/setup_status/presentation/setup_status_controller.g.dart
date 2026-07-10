// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_status_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs the manifest's runtime setup checks and exposes their states.
///
/// Each runtime [SetupStep] (kind [SetupCheckKind.runtimeCheck]) is bound
/// to an implementation here by its id — things only a running app can
/// verify: Firebase actually initializes, anonymous auth round-trips,
/// an FCM token is issued. Steps of disabled modules start (and stay)
/// [RuntimeCheckStatus.skipped].

@ProviderFor(SetupStatusController)
final setupStatusControllerProvider = SetupStatusControllerProvider._();

/// Runs the manifest's runtime setup checks and exposes their states.
///
/// Each runtime [SetupStep] (kind [SetupCheckKind.runtimeCheck]) is bound
/// to an implementation here by its id — things only a running app can
/// verify: Firebase actually initializes, anonymous auth round-trips,
/// an FCM token is issued. Steps of disabled modules start (and stay)
/// [RuntimeCheckStatus.skipped].
final class SetupStatusControllerProvider
    extends
        $NotifierProvider<
          SetupStatusController,
          Map<String, RuntimeCheckEntity>
        > {
  /// Runs the manifest's runtime setup checks and exposes their states.
  ///
  /// Each runtime [SetupStep] (kind [SetupCheckKind.runtimeCheck]) is bound
  /// to an implementation here by its id — things only a running app can
  /// verify: Firebase actually initializes, anonymous auth round-trips,
  /// an FCM token is issued. Steps of disabled modules start (and stay)
  /// [RuntimeCheckStatus.skipped].
  SetupStatusControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupStatusControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupStatusControllerHash();

  @$internal
  @override
  SetupStatusController create() => SetupStatusController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, RuntimeCheckEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, RuntimeCheckEntity>>(
        value,
      ),
    );
  }
}

String _$setupStatusControllerHash() =>
    r'4e61984d9e2bd1527b5bb5fe1430eaf42129fe5e';

/// Runs the manifest's runtime setup checks and exposes their states.
///
/// Each runtime [SetupStep] (kind [SetupCheckKind.runtimeCheck]) is bound
/// to an implementation here by its id — things only a running app can
/// verify: Firebase actually initializes, anonymous auth round-trips,
/// an FCM token is issued. Steps of disabled modules start (and stay)
/// [RuntimeCheckStatus.skipped].

abstract class _$SetupStatusController
    extends $Notifier<Map<String, RuntimeCheckEntity>> {
  Map<String, RuntimeCheckEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<String, RuntimeCheckEntity>,
              Map<String, RuntimeCheckEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, RuntimeCheckEntity>,
                Map<String, RuntimeCheckEntity>
              >,
              Map<String, RuntimeCheckEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
