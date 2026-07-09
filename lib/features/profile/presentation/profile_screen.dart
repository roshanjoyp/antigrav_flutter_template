import 'package:antigrav_flutter_template/core/core.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_entity.dart';
import 'package:antigrav_flutter_template/features/profile/presentation/profile_controller.dart';
import 'package:antigrav_flutter_template/features/profile/presentation/widgets/profile_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen showing and editing the current user's profile.
///
/// The template's reference example of view ↔ controller binding: it
/// watches `profileControllerProvider` and renders the three
/// [AsyncValue] states with core widgets — [AppLoading], [AppError]
/// (with retry via provider invalidation), and the editable form on
/// data. All business logic lives in the controller.
class ProfileScreen extends ConsumerWidget {
  /// Creates a [ProfileScreen].
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ProfileEntity?> profile =
        ref.watch(profileControllerProvider);

    return AppScaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profile.when(
        // Riverpod 3 auto-retries failed providers and reports the retry
        // as a reload (AsyncLoading). Without this flag the screen would
        // show an infinite spinner on persistent errors instead of the
        // error state.
        skipLoadingOnReload: true,
        loading: () => const AppLoading(message: 'Loading profile...'),
        error: (Object error, StackTrace stackTrace) => AppError(
          message: error is AppException
              ? error.message
              : 'Failed to load profile.',
          onRetry: () => ref.invalidate(profileControllerProvider),
        ),
        data: (ProfileEntity? data) => ProfileFormWidget(profile: data),
      ),
    );
  }
}
