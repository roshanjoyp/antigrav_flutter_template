import 'package:antigrav_flutter_template/core/services/permissions/permission_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// Tests the [PermissionService] by requesting the camera permission.
///
/// Prints the result to the debug console so developers can verify the
/// permission request flow without needing a dedicated UI.
class PermissionsTestWidget extends ConsumerWidget {
  /// Creates a [PermissionsTestWidget].
  const PermissionsTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Camera Permission'),
      trailing: ElevatedButton(
        onPressed: () async {
          final granted = await ref
              .read(permissionServiceProvider)
              .requestPermission(Permission.camera);
          debugPrint('Camera permission granted: $granted');
        },
        child: const Text('Request'),
      ),
    );
  }
}
