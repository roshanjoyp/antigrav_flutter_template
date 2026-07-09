// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for the profile screen.
///
/// Exposes the current user's profile as a reactive stream and handles
/// saves. This is the template's reference example of a controller
/// binding a repository stream to the UI: `build()` returns the stream,
/// Riverpod wraps it in [AsyncValue], and the view renders
/// loading/error/data without any business logic of its own.
///
/// The profile belongs to the signed-in user; when nobody is signed in
/// (the stub template's default state) a fixed demo uid is used so the
/// feature is explorable out of the box.

@ProviderFor(ProfileController)
final profileControllerProvider = ProfileControllerProvider._();

/// Controller for the profile screen.
///
/// Exposes the current user's profile as a reactive stream and handles
/// saves. This is the template's reference example of a controller
/// binding a repository stream to the UI: `build()` returns the stream,
/// Riverpod wraps it in [AsyncValue], and the view renders
/// loading/error/data without any business logic of its own.
///
/// The profile belongs to the signed-in user; when nobody is signed in
/// (the stub template's default state) a fixed demo uid is used so the
/// feature is explorable out of the box.
final class ProfileControllerProvider
    extends $StreamNotifierProvider<ProfileController, ProfileEntity?> {
  /// Controller for the profile screen.
  ///
  /// Exposes the current user's profile as a reactive stream and handles
  /// saves. This is the template's reference example of a controller
  /// binding a repository stream to the UI: `build()` returns the stream,
  /// Riverpod wraps it in [AsyncValue], and the view renders
  /// loading/error/data without any business logic of its own.
  ///
  /// The profile belongs to the signed-in user; when nobody is signed in
  /// (the stub template's default state) a fixed demo uid is used so the
  /// feature is explorable out of the box.
  ProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();
}

String _$profileControllerHash() => r'5dde306f3b275164b980ebb695a7944bd49535e7';

/// Controller for the profile screen.
///
/// Exposes the current user's profile as a reactive stream and handles
/// saves. This is the template's reference example of a controller
/// binding a repository stream to the UI: `build()` returns the stream,
/// Riverpod wraps it in [AsyncValue], and the view renders
/// loading/error/data without any business logic of its own.
///
/// The profile belongs to the signed-in user; when nobody is signed in
/// (the stub template's default state) a fixed demo uid is used so the
/// feature is explorable out of the box.

abstract class _$ProfileController extends $StreamNotifier<ProfileEntity?> {
  Stream<ProfileEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ProfileEntity?>, ProfileEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProfileEntity?>, ProfileEntity?>,
              AsyncValue<ProfileEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
