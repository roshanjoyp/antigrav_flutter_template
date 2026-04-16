import 'package:antigrav_flutter_template/core/constants/app_colors.dart';
import 'package:antigrav_flutter_template/core/services/connectivity/connectivity_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tests the [ConnectivityService] by streaming live connectivity status.
///
/// Displays a live indicator that reflects whether the device currently
/// has an internet connection.
class ConnectivityTestWidget extends ConsumerWidget {
  /// Creates a [ConnectivityTestWidget].
  const ConnectivityTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStream = ref
        .watch(connectivityServiceProvider)
        .onConnectivityChanged;

    return StreamBuilder<bool>(
      stream: connectivityStream,
      initialData: true, // Optimistic
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;
        return ListTile(
          leading: Icon(
            isConnected ? Icons.wifi : Icons.wifi_off,
            color: isConnected ? AppColors.success : AppColors.textTertiary,
          ),
          title: Text(isConnected ? 'Connected' : 'Disconnected'),
        );
      },
    );
  }
}
