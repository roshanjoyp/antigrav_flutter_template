// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StartupController)
final startupControllerProvider = StartupControllerProvider._();

final class StartupControllerProvider
    extends $AsyncNotifierProvider<StartupController, String?> {
  StartupControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startupControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startupControllerHash();

  @$internal
  @override
  StartupController create() => StartupController();
}

String _$startupControllerHash() => r'0121e039f006cf0c580ae4ebd42415bf33833dcf';

abstract class _$StartupController extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
