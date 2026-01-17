import 'package:antigrav_flutter_template/app/config/app_config_controller.dart';
import 'package:antigrav_flutter_template/core/services/connectivity/connectivity_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/crash_service/crash_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/permissions/permission_service_impl.dart';
import 'package:antigrav_flutter_template/core/services/update_service/update_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Test Panel')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Configuration'),
          _buildConfigSection(ref),
          const Divider(),
          _buildSectionHeader('Logging'),
          _buildLoggingSection(ref),
          const Divider(),
          _buildSectionHeader('Crash Reporting'),
          _buildCrashSection(ref),
          const Divider(),
          _buildSectionHeader('Connectivity'),
          _buildConnectivitySection(ref),
          const Divider(),
          _buildSectionHeader('Permissions'),
          _buildPermissionSection(ref),
          const Divider(),
          _buildSectionHeader('Updates'),
          _buildUpdateSection(ref),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildConfigSection(WidgetRef ref) {
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

  Widget _buildLoggingSection(WidgetRef ref) {
    final logger = ref.read(logServiceProvider);
    return Wrap(
      spacing: 8,
      children: [
        FilledButton(
          onPressed: () => logger.info('Test Info Log'),
          child: const Text('Info'),
        ),
        FilledButton.tonal(
          onPressed: () => logger.warning('Test Warning Log'),
          child: const Text('Warning'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => logger.error(
            'Test Error Log',
            Exception('Test Exception'),
            StackTrace.current,
          ),
          child: const Text('Error'),
        ),
      ],
    );
  }

  Widget _buildCrashSection(WidgetRef ref) {
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

  Widget _buildConnectivitySection(WidgetRef ref) {
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
            color: isConnected ? Colors.green : Colors.grey,
          ),
          title: Text(isConnected ? 'Connected' : 'Disconnected'),
        );
      },
    );
  }

  Widget _buildPermissionSection(WidgetRef ref) {
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

  Widget _buildUpdateSection(WidgetRef ref) {
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
