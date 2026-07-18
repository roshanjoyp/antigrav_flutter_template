import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/features/startup/presentation/startup_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The startup/splash screen shown while the app initialises.
///
/// Triggers [StartupController.runStartupLogic] on mount and, once the
/// services are up, acts as the template's demo hub: a uniform list of
/// [AppNavTile]s linking to every example feature.
class StartupView extends ConsumerStatefulWidget {
  /// Creates a [StartupView].
  const StartupView({super.key});

  @override
  ConsumerState<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends ConsumerState<StartupView> {
  @override
  void initState() {
    super.initState();
    // Trigger startup logic after the first frame so the widget tree is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(startupControllerProvider.notifier).runStartupLogic();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<String?> startup = ref.watch(startupControllerProvider);

    // Note: Auto-navigation to home removed for Test Control Panel
    // purpose — this screen stays up as the template's demo hub. The
    // one exception: a first-run redirect resolved by the startup hook
    // (any route other than home) is followed immediately.
    ref.listen(startupControllerProvider, (previous, next) {
      final String? route = next.value;
      if (route != null && route != '/') context.go(route);
    });

    return AppScaffold(
      useSafeArea: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spaceXl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConstants.breakpointMobileXs,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: AppConstants.spaceXxl),
                _buildStatusLine(startup),
                const SizedBox(height: AppConstants.space3xl),
                ..._buildTiles(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Monogram mark, app name, and tagline.
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: AppConstants.space5xl,
          height: AppConstants.space5xl,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          ),
          alignment: Alignment.center,
          child: AppText.headingLarge(
            AppConstants.appName.substring(0, 1).toUpperCase(),
            color: AppColors.textOnAccent,
          ),
        ),
        const SizedBox(height: AppConstants.spaceXl),
        AppText.headingMedium(AppConstants.appName, textAlign: TextAlign.center),
        const SizedBox(height: AppConstants.spaceXs),
        AppText.bodySmall(
          'Clean Riverpod Architecture Flutter Template',
          color: AppColors.textSecondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// One quiet line reporting the startup hook's progress.
  Widget _buildStatusLine(AsyncValue<String?> startup) {
    // The controller starts as `data(null)` before `runStartupLogic`
    // flips it to loading, so a null value still means "starting".
    final bool starting = startup.isLoading || startup.value == null;
    final Widget leading;
    final String message;
    if (startup.hasError) {
      leading = const Icon(
        Icons.error_outline,
        size: AppConstants.iconXs,
        color: AppColors.error,
      );
      message = 'Startup failed — see logs';
    } else if (starting) {
      leading = const SizedBox(
        width: AppConstants.iconXs,
        height: AppConstants.iconXs,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentLight),
        ),
      );
      message = 'Starting services…';
    } else {
      leading = const Icon(
        Icons.check_circle_outline,
        size: AppConstants.iconXs,
        color: AppColors.success,
      );
      message = 'Services ready';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        leading,
        const SizedBox(width: AppConstants.spaceXs),
        AppText.caption(message, color: AppColors.textSecondary),
      ],
    );
  }

  /// The demo hub: uniform navigation tiles, grouped Explore / Development.
  List<Widget> _buildTiles(BuildContext context) {
    return [
      AppText.caption('EXPLORE', color: AppColors.textTertiary),
      const SizedBox(height: AppConstants.spaceSm),
      AppNavTile(
        icon: Icons.home_outlined,
        label: 'Home',
        sublabel: 'Your app starts here',
        onTap: () => context.go('/'),
      ),
      const SizedBox(height: AppConstants.spaceSm),
      AppNavTile(
        icon: Icons.person_outlined,
        label: 'Profile',
        sublabel: 'Full clean-architecture example',
        onTap: () => context.push('/profile'),
      ),
      // MODULE(revenuecat): begin
      const SizedBox(height: AppConstants.spaceSm),
      AppNavTile(
        icon: Icons.workspace_premium_outlined,
        label: 'Paywall',
        sublabel: 'RevenueCat subscription flow',
        onTap: () => context.push('/paywall'),
      ),
      // MODULE(revenuecat): end
      // MODULE(onboarding): begin
      const SizedBox(height: AppConstants.spaceSm),
      AppNavTile(
        icon: Icons.explore_outlined,
        label: 'Onboarding',
        sublabel: 'Replay the first-run flow',
        onTap: () => context.push('/onboarding'),
      ),
      // MODULE(onboarding): end
      // Dev-only: these routes are compiled out of release builds, so
      // the whole section must be too.
      if (kDebugMode) ...[
        const SizedBox(height: AppConstants.spaceXl),
        AppText.caption('DEVELOPMENT', color: AppColors.textTertiary),
        const SizedBox(height: AppConstants.spaceSm),
        AppNavTile(
          icon: Icons.build_outlined,
          label: 'Test services',
          sublabel: 'Exercise every core service',
          onTap: () => context.push('/test'),
        ),
        const SizedBox(height: AppConstants.spaceSm),
        AppNavTile(
          icon: Icons.fact_check_outlined,
          label: 'Setup status',
          sublabel: 'Runtime checks and readiness',
          onTap: () => context.push('/setup-status'),
        ),
      ],
    ];
  }
}
