import 'package:antigrav_flutter_template/core/services/crash_service/crash_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tests the [CrashService] by manually recording a fatal error.
///
/// Provides a button that simulates a crash report, allowing developers
/// to verify that crash reporting is wired up correctly without crashing
/// the app process.
class CrashTestWidget extends ConsumerWidget {
  /// Creates a [CrashTestWidget].
  const CrashTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Simulate Crash'),
      subtitle: const Text('Records a fatal error to CrashService'),
      trailing: IconButton(
        icon: const Icon(Icons.bug_report, color: Colors.red),
        onPressed: () {
          ref
              .read(crashServiceProvider)
              .recordError(
                Exception('Manual Test Crash'),
                StackTrace.current,
                reason: 'User triggered test crash',
                fatal: true,
              );
        },
      ),
    );
  }
}
