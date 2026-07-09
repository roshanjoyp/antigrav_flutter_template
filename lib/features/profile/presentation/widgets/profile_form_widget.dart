import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/features/profile/domain/profile_entity.dart';
import 'package:craft_flutter_template/features/profile/presentation/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Editable form for the profile's display name and bio.
///
/// Local-only widget state ([TextEditingController]s, save-in-flight
/// flag) lives here; the actual save goes through
/// `ProfileController.save`, and its [Result] drives the feedback
/// snackbar. When [profile] is `null` the user has no profile document
/// yet — saving creates it.
class ProfileFormWidget extends ConsumerStatefulWidget {
  /// Creates a [ProfileFormWidget] pre-filled from [profile].
  const ProfileFormWidget({required this.profile, super.key});

  /// The current profile, or `null` when none exists yet.
  final ProfileEntity? profile;

  @override
  ConsumerState<ProfileFormWidget> createState() => _ProfileFormWidgetState();
}

class _ProfileFormWidgetState extends ConsumerState<ProfileFormWidget> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _bioController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.profile?.displayName,
    );
    _bioController = TextEditingController(text: widget.profile?.bio);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final Result<void> result = await ref
        .read(profileControllerProvider.notifier)
        .save(
          displayName: _displayNameController.text,
          bio: _bioController.text,
        );
    if (!mounted) return;
    setState(() => _isSaving = false);
    final String feedback = result.fold(
      onSuccess: (_) => 'Profile saved.',
      onFailure: (AppException exception) => exception.message,
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(feedback)));
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? updatedAt = widget.profile?.updatedAt;

    return ListView(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      children: [
        AppText.headingMedium(
          widget.profile == null ? 'Create your profile' : 'Your profile',
        ),
        const SizedBox(height: AppConstants.spaceXl),
        TextField(
          controller: _displayNameController,
          decoration: const InputDecoration(
            labelText: 'Display name',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppConstants.spaceLg),
        TextField(
          controller: _bioController,
          decoration: const InputDecoration(
            labelText: 'Bio',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: AppConstants.spaceXl),
        AppButton(
          label: 'Save profile',
          onPressed: _isSaving ? null : _save,
          isLoading: _isSaving,
        ),
        if (updatedAt != null) ...[
          const SizedBox(height: AppConstants.spaceLg),
          AppText.bodySmall('Last updated: $updatedAt'),
        ],
      ],
    );
  }
}
