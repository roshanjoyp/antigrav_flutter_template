import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/features/onboarding/presentation/onboarding_controller.dart';
import 'package:craft_flutter_template/features/onboarding/presentation/widgets/onboarding_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// One onboarding page's content.
class _OnboardingPage {
  const _OnboardingPage(this.icon, this.title, this.description);

  final IconData icon;
  final String title;
  final String description;
}

/// The first-run onboarding flow: a swipeable [PageView] with skip and
/// completion actions.
///
/// Shown automatically on first launch (startup redirects here while
/// the seen flag is unset) and openable any time from the startup
/// screen. Both "Skip" and "Get started" persist the flag via
/// [OnboardingController.complete] and continue to the home screen —
/// navigation proceeds even if persistence fails, so a broken storage
/// layer can never trap the user here.
///
/// Replace the placeholder page copy with your product's story; the
/// structure (data list + [OnboardingPageWidget]) stays.
class OnboardingScreen extends ConsumerStatefulWidget {
  /// Creates an [OnboardingScreen].
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const List<_OnboardingPage> _pages = <_OnboardingPage>[
    _OnboardingPage(
      Icons.rocket_launch,
      'Welcome aboard',
      'A production-grade Flutter starting point: clean architecture, '
          'Riverpod, theming, and services — already wired.',
    ),
    _OnboardingPage(
      Icons.swap_horiz,
      'Stub-first services',
      'Every integration runs against a stub out of the box. Flip one '
          'switch to bind Firebase, RevenueCat, and push for real.',
    ),
    _OnboardingPage(
      Icons.check_circle_outline,
      'Ready when you are',
      'Explore the examples from the start screen, then make this '
          'onboarding your own.',
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == _pages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    // Persist first, then leave. Failures are deliberately not blocking:
    // the flag's worst case is onboarding showing once more.
    await ref.read(onboardingControllerProvider.notifier).complete();
    if (mounted) context.go('/');
  }

  void _next() {
    _pageController.nextPage(
      duration: AppConstants.durationNormal,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useSafeArea: true,
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: _finish, child: const Text('Skip')),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) => setState(() => _currentPage = page),
              children: [
                for (final _OnboardingPage page in _pages)
                  OnboardingPageWidget(
                    icon: page.icon,
                    title: page.title,
                    description: page.description,
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < _pages.length; i++)
                AnimatedContainer(
                  duration: AppConstants.durationFast,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spaceXxs,
                  ),
                  width: i == _currentPage
                      ? AppConstants.spaceLg
                      : AppConstants.spaceSm,
                  height: AppConstants.spaceSm,
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? AppColors.accent
                        : AppColors.accentMuted,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusFull,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.spaceXl),
            child: AppButton(
              label: _isLastPage ? 'Get started' : 'Next',
              onPressed: _isLastPage ? _finish : _next,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}
