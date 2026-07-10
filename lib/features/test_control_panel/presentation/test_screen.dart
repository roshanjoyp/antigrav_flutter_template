import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/features/test_control_panel/presentation/widgets/analytics_test_widget.dart';
import 'package:craft_flutter_template/features/test_control_panel/presentation/widgets/connectivity_test_widget.dart';
import 'package:craft_flutter_template/features/test_control_panel/presentation/widgets/crash_test_widget.dart';
import 'package:craft_flutter_template/features/test_control_panel/presentation/widgets/log_test_widget.dart';
import 'package:craft_flutter_template/features/test_control_panel/presentation/widgets/permissions_test_widget.dart';
import 'package:craft_flutter_template/features/test_control_panel/presentation/widgets/update_test_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The service test panel screen.
///
/// A developer-only screen that composes individual service test widgets,
/// allowing each core service to be exercised in isolation. This screen
/// should not be accessible in production builds.
class TestScreen extends ConsumerWidget {
  /// Creates a [TestScreen].
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Service Test Panel')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spaceMd),
        children: [
          const _SectionHeader('Setup'),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Setup Status'),
            subtitle: const Text('Runtime setup checks per module'),
            onTap: () => context.push('/setup-status'),
          ),
          const AppDivider(),
          const _SectionHeader('Configuration'),
          const AnalyticsTestWidget(),
          const AppDivider(),
          const _SectionHeader('Logging'),
          const LogTestWidget(),
          const AppDivider(),
          const _SectionHeader('Crash Reporting'),
          const CrashTestWidget(),
          const AppDivider(),
          const _SectionHeader('Connectivity'),
          const ConnectivityTestWidget(),
          const AppDivider(),
          const _SectionHeader('Permissions'),
          const PermissionsTestWidget(),
          const AppDivider(),
          const _SectionHeader('Updates'),
          const UpdateTestWidget(),
        ],
      ),
    );
  }
}

/// A bold section heading used to label each service group in the test panel.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  /// The label text displayed as the section heading.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceXs),
      child: AppText.headingSmall(title),
    );
  }
}
