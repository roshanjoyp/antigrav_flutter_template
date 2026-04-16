import 'package:antigrav_flutter_template/core/services/update_service/update_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tests the [UpdateService] by triggering an update check.
///
/// Prints the result to the debug console. The update service is currently
/// a stub and will return null — this widget verifies the call completes
/// without error.
class UpdateTestWidget extends ConsumerWidget {
  /// Creates an [UpdateTestWidget].
  const UpdateTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Check for Updates'),
      trailing: ElevatedButton(
        onPressed: () async {
          final info = await ref.read(updateServiceProvider).checkForUpdate();
          debugPrint('Update check result: $info');
        },
        child: const Text('Check'),
      ),
    );
  }
}
