import 'package:craft_flutter_template/app/theme/app_theme.dart';
import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/setup_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Golden tests for the theme (light + dark) and the core widget set.
///
/// Regenerate after intentional visual changes with:
/// ```
/// flutter test --update-goldens test/goldens
/// ```
/// Rendering uses the deterministic FlutterTest font, so the goldens
/// are stable across platforms (including CI).
void main() {
  Future<void> pumpGallery(WidgetTester tester, ThemeData theme) async {
    tester.view.physicalSize = const Size(800, 1300);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const _ThemeGallery(),
      ),
    );
  }

  group('theme goldens', () {
    testWidgets('dark theme gallery', (WidgetTester tester) async {
      await pumpGallery(tester, AppTheme.darkTheme);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/theme_gallery_dark.png'),
      );
    });

    testWidgets('light theme gallery', (WidgetTester tester) async {
      await pumpGallery(tester, AppTheme.lightTheme);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/theme_gallery_light.png'),
      );
    });

    testWidgets('setup status screen (dark)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: const SetupStatusScreen(),
          ),
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/setup_status_screen_dark.png'),
      );
    });
  });
}

/// A single-screen sampler of the core widget set and typography, used
/// to pin the theme's look in goldens.
class _ThemeGallery extends StatelessWidget {
  const _ThemeGallery();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Theme Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spaceMd),
        children: [
          AppText.headingLarge('Heading Large'),
          AppText.headingMedium('Heading Medium'),
          AppText.headingSmall('Heading Small'),
          AppText.bodyLarge('Body large — the quick brown fox.'),
          AppText.bodyMedium('Body medium — the quick brown fox.'),
          AppText.bodySmall('Body small — the quick brown fox.'),
          AppText.caption('Caption — the quick brown fox.'),
          const AppDivider(),
          AppButton(label: 'Primary action', onPressed: () {}),
          const SizedBox(height: AppConstants.spaceXs),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text('Text')),
              const SizedBox(width: AppConstants.spaceXs),
              OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            ],
          ),
          const AppDivider(),
          const Row(
            children: [
              AppIconBadge(
                icon: Icons.check_rounded,
                color: AppColors.success,
                background: AppColors.successLight,
              ),
              SizedBox(width: AppConstants.spaceXs),
              AppIconBadge(
                icon: Icons.priority_high_rounded,
                color: AppColors.error,
                background: AppColors.errorLight,
              ),
              SizedBox(width: AppConstants.spaceXs),
              AppIconBadge(
                icon: Icons.front_hand_outlined,
                color: AppColors.warning,
                background: AppColors.warningLight,
              ),
              SizedBox(width: AppConstants.spaceXs),
              AppIconBadge(
                icon: Icons.play_arrow_rounded,
                color: AppColors.textSecondary,
                background: AppColors.backgroundTertiary,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceMd),
          const AppInfoBanner(
            message: 'An inline hint banner with an icon and message.',
          ),
          const SizedBox(height: AppConstants.spaceMd),
          const AppError(message: 'Something went wrong.'),
        ],
      ),
    );
  }
}
