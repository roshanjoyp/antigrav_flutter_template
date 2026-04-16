import 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/analytics_test_widget.dart';
import 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/connectivity_test_widget.dart';
import 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/crash_test_widget.dart';
import 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/log_test_widget.dart';
import 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/permissions_test_widget.dart';
import 'package:antigrav_flutter_template/features/test_control_panel/presentation/widgets/update_test_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Service Test Panel')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionHeader('Configuration'),
          AnalyticsTestWidget(),
          Divider(),
          _SectionHeader('Logging'),
          LogTestWidget(),
          Divider(),
          _SectionHeader('Crash Reporting'),
          CrashTestWidget(),
          Divider(),
          _SectionHeader('Connectivity'),
          ConnectivityTestWidget(),
          Divider(),
          _SectionHeader('Permissions'),
          PermissionsTestWidget(),
          Divider(),
          _SectionHeader('Updates'),
          UpdateTestWidget(),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
