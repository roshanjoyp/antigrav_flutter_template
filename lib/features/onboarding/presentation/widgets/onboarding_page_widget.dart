import 'package:antigrav_flutter_template/core/constants/app_colors.dart';
import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:antigrav_flutter_template/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// The content of one onboarding page: icon, title, and description.
///
/// Pure presentation — the page data lives in the screen's const page
/// list and the [PageView] wiring stays in the screen.
class OnboardingPageWidget extends StatelessWidget {
  /// Creates an [OnboardingPageWidget].
  const OnboardingPageWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  /// The page's illustration icon.
  final IconData icon;

  /// The page's headline.
  final String title;

  /// The page's supporting copy.
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spaceXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppConstants.iconXxl, color: AppColors.accent),
          const SizedBox(height: AppConstants.spaceXl),
          AppText.headingMedium(title, textAlign: TextAlign.center),
          const SizedBox(height: AppConstants.spaceMd),
          AppText.bodyMedium(description, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
