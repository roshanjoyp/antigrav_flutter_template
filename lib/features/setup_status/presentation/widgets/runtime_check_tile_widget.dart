import 'package:craft_flutter_template/core/constants/app_colors.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:craft_flutter_template/features/setup_status/domain/runtime_check_entity.dart';
import 'package:flutter/material.dart';

/// One runtime check row on the Setup Status screen: status icon, step
/// title, outcome detail, and a run button.
class RuntimeCheckTileWidget extends StatelessWidget {
  /// Creates a tile for [step] in state [check].
  const RuntimeCheckTileWidget({
    super.key,
    required this.step,
    required this.check,
    required this.onRun,
  });

  /// The manifest step this tile represents.
  final SetupStep step;

  /// The check's current state.
  final RuntimeCheckEntity check;

  /// Called when the developer taps run.
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    final bool runnable =
        check.status != RuntimeCheckStatus.skipped &&
        check.status != RuntimeCheckStatus.running;
    return ListTile(
      leading: _StatusIcon(status: check.status),
      title: Text(step.title),
      subtitle: check.detail == null ? null : Text(check.detail!),
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow),
        tooltip: 'Run check',
        onPressed: runnable ? onRun : null,
      ),
    );
  }
}

/// Maps a [RuntimeCheckStatus] to its icon and color.
class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  /// The status to render.
  final RuntimeCheckStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == RuntimeCheckStatus.running) {
      return const SizedBox(
        width: AppConstants.iconSm,
        height: AppConstants.iconSm,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    final (IconData icon, Color color) = switch (status) {
      RuntimeCheckStatus.notRun => (
        Icons.radio_button_unchecked,
        AppColors.textTertiary,
      ),
      RuntimeCheckStatus.passed => (Icons.check_circle, AppColors.success),
      RuntimeCheckStatus.failed => (Icons.error, AppColors.error),
      RuntimeCheckStatus.skipped => (
        Icons.remove_circle_outline,
        AppColors.textDisabled,
      ),
      RuntimeCheckStatus.running => (Icons.sync, AppColors.info),
    };
    return Icon(icon, color: color, size: AppConstants.iconSm);
  }
}
