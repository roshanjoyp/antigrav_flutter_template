import 'package:antigrav_flutter_template/core/constants/app_colors.dart';
import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:antigrav_flutter_template/core/services/log_service/log_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tests the [LogService] by firing log entries at each severity level.
///
/// Provides buttons for info, warning, and error log levels so developers
/// can verify that log output appears correctly in the console.
class LogTestWidget extends ConsumerWidget {
  /// Creates a [LogTestWidget].
  const LogTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = ref.read(logServiceProvider);

    return Wrap(
      spacing: AppConstants.spaceXs,
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
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
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
}
