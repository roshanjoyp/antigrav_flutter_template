import 'package:antigrav_flutter_template/core/constants/app_colors.dart';
import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:antigrav_flutter_template/core/widgets/widgets.dart';
import 'package:antigrav_flutter_template/features/paywall/domain/paywall_offering_entity.dart';
import 'package:flutter/material.dart';

/// A selectable card presenting one [PaywallPackageEntity] on the
/// paywall: period label, description, price, and a buy button.
class PaywallPackageCardWidget extends StatelessWidget {
  /// Creates a [PaywallPackageCardWidget].
  const PaywallPackageCardWidget({
    super.key,
    required this.package,
    required this.onPressed,
    this.isLoading = false,
  });

  /// The package this card presents.
  final PaywallPackageEntity package;

  /// Called when the buy button is tapped. Pass `null` to disable
  /// (e.g. while another package's purchase is in flight).
  final VoidCallback? onPressed;

  /// Whether this package's purchase is in flight — shows a spinner on
  /// the buy button.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppConstants.spaceSm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.headingSmall(package.periodLabel),
                  const SizedBox(height: AppConstants.spaceXs),
                  AppText.bodySmall(package.description),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.spaceMd),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText.headingSmall(package.priceString),
                const SizedBox(height: AppConstants.spaceXs),
                AppButton(
                  label: 'Buy',
                  onPressed: onPressed,
                  isLoading: isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
