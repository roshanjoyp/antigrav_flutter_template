import 'package:antigrav_flutter_template/app/config/app_config_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tests app-level configuration including theme and locale toggling.
///
/// Temporarily housed in the analytics test widget slot as the analytics
/// service does not yet have testable surface area. This should be replaced
/// with real analytics tests once the analytics service is implemented.
class AnalyticsTestWidget extends ConsumerWidget {
  /// Creates an [AnalyticsTestWidget].
  const AnalyticsTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigControllerProvider);
    final notifier = ref.read(appConfigControllerProvider.notifier);

    return Column(
      children: [
        ListTile(
          title: const Text('Theme'),
          subtitle: Text(config.themeMode.toString()),
          trailing: ElevatedButton(
            onPressed: notifier.toggleTheme,
            child: const Text('Toggle'),
          ),
        ),
        ListTile(
          title: const Text('Locale'),
          subtitle: Text(config.locale.toString()),
          trailing: ElevatedButton(
            onPressed: notifier.toggleLocale,
            child: const Text('Toggle (en/es)'),
          ),
        ),
      ],
    );
  }
}
