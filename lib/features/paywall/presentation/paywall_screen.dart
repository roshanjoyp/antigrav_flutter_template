import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/features/paywall/domain/paywall_offering_entity.dart';
import 'package:craft_flutter_template/features/paywall/domain/subscription_status_entity.dart';
import 'package:craft_flutter_template/features/paywall/presentation/paywall_controller.dart';
import 'package:craft_flutter_template/features/paywall/presentation/widgets/paywall_package_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The paywall: presents the current offering's packages, handles
/// purchase and restore, and shows the unlocked state once subscribed.
///
/// All store logic lives in [PaywallController] and the repository; the
/// only state held here is *which* button is showing a spinner. A
/// `'paywall/purchase-cancelled'` failure is deliberately silent — the
/// user closed the store sheet themselves.
class PaywallScreen extends ConsumerStatefulWidget {
  /// Creates a [PaywallScreen].
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  /// Id of the package whose purchase is in flight, if any.
  String? _purchasingPackageId;

  /// Whether a restore is in flight.
  bool _isRestoring = false;

  bool get _isBusy => _purchasingPackageId != null || _isRestoring;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<SubscriptionStatusEntity> status = ref.watch(
      subscriptionStatusProvider,
    );
    final bool isSubscribed = status.value?.isSubscribed ?? false;

    return AppScaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: isSubscribed ? _buildSubscribed() : _buildPaywall(),
    );
  }

  Widget _buildSubscribed() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.workspace_premium,
              size: AppConstants.iconXxl,
              color: AppColors.success,
            ),
            const SizedBox(height: AppConstants.spaceLg),
            AppText.headingMedium("You're premium!"),
            const SizedBox(height: AppConstants.spaceSm),
            AppText.bodyMedium(
              'All premium features are unlocked on this account.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaywall() {
    final AsyncValue<PaywallOfferingEntity?> offering = ref.watch(
      paywallControllerProvider,
    );

    return offering.when(
      // Riverpod 3 auto-retries failed providers and reports the retry
      // as a reload (AsyncLoading). Without this flag the screen would
      // show an infinite spinner on persistent errors instead of the
      // error state.
      skipLoadingOnReload: true,
      loading: () => const AppLoading(message: 'Loading offers...'),
      error: (Object error, StackTrace stackTrace) => AppError(
        message: error is AppException
            ? error.message
            : 'Failed to load offers.',
        onRetry: () => ref.invalidate(paywallControllerProvider),
      ),
      data: (PaywallOfferingEntity? offering) => _buildOffering(offering),
    );
  }

  Widget _buildOffering(PaywallOfferingEntity? offering) {
    if (offering == null || offering.packages.isEmpty) {
      return const Center(
        child: AppError(message: 'No offers are available right now.'),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      children: [
        AppText.headingMedium('Go Premium'),
        const SizedBox(height: AppConstants.spaceSm),
        AppText.bodyMedium(
          'Unlock every feature with the plan that suits you.',
        ),
        const SizedBox(height: AppConstants.spaceLg),
        for (final PaywallPackageEntity package in offering.packages)
          PaywallPackageCardWidget(
            package: package,
            isLoading: _purchasingPackageId == package.id,
            onPressed: _isBusy ? null : () => _purchase(package),
          ),
        const SizedBox(height: AppConstants.spaceLg),
        Center(
          child: TextButton(
            onPressed: _isBusy ? null : _restore,
            child: Text(_isRestoring ? 'Restoring...' : 'Restore purchases'),
          ),
        ),
      ],
    );
  }

  Future<void> _purchase(PaywallPackageEntity package) async {
    setState(() => _purchasingPackageId = package.id);
    final Result<SubscriptionStatusEntity> result = await ref
        .read(paywallControllerProvider.notifier)
        .purchase(package);
    if (!mounted) return;
    setState(() => _purchasingPackageId = null);
    result.fold(
      onSuccess: (SubscriptionStatusEntity status) =>
          _showFeedback('Purchase successful — welcome aboard!'),
      onFailure: (AppException exception) {
        // The user closed the store sheet — not an error.
        if (exception.code == 'paywall/purchase-cancelled') return;
        _showFeedback(exception.message);
      },
    );
  }

  Future<void> _restore() async {
    setState(() => _isRestoring = true);
    final Result<SubscriptionStatusEntity> result = await ref
        .read(paywallControllerProvider.notifier)
        .restore();
    if (!mounted) return;
    setState(() => _isRestoring = false);
    result.fold(
      onSuccess: (SubscriptionStatusEntity status) => _showFeedback(
        status.isSubscribed
            ? 'Purchases restored.'
            : 'No previous purchases found.',
      ),
      onFailure: (AppException exception) => _showFeedback(exception.message),
    );
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
