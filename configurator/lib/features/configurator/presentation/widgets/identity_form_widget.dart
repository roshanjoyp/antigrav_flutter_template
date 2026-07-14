import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/core/widgets/underline_field_widget.dart';
import 'package:craft_configurator/features/configurator/domain/configuration_entity.dart';
import 'package:craft_configurator/features/configurator/presentation/configurator_controller.dart';

/// Identity block: app name, organization, pubspec description, and the
/// derived package id (plus any generator validation errors).
class IdentityFormWidget extends ConsumerWidget {
  /// Creates the identity form.
  const IdentityFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ConfigurationEntity config = ref.watch(
      configuratorControllerProvider,
    );
    final ConfiguratorController controller = ref.read(
      configuratorControllerProvider.notifier,
    );
    final bool narrow = MediaQuery.sizeOf(context).width <= 560;

    final Widget nameField = UnderlineFieldWidget(
      label: 'App name',
      initialValue: config.appName,
      onChanged: controller.setAppName,
    );
    final Widget orgField = UnderlineFieldWidget(
      label: 'Organization',
      initialValue: config.organization,
      onChanged: controller.setOrganization,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (narrow) ...[
          nameField,
          const SizedBox(height: AppConstants.identityGap),
          orgField,
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: nameField),
              const SizedBox(width: AppConstants.identityGap),
              Expanded(child: orgField),
            ],
          ),
        const SizedBox(height: AppConstants.identityGap),
        UnderlineFieldWidget(
          label: 'Description — one line for pubspec.yaml',
          initialValue: config.description,
          onChanged: controller.setDescription,
        ),
        const SizedBox(height: 20),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'package: ',
                style: AppTypography.code(size: 12, color: AppColors.muted),
              ),
              TextSpan(
                text: config.packageId,
                style: AppTypography.code(size: 12, weight: 600),
              ),
            ],
          ),
        ),
        for (final error in config.validationErrors) ...[
          const SizedBox(height: 8),
          Text(error, style: AppTypography.code(size: 10)),
        ],
      ],
    );
  }
}
