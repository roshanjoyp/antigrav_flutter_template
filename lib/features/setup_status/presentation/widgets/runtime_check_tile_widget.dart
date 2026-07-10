import 'package:craft_flutter_template/core/constants/app_colors.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:craft_flutter_template/core/widgets/app_icon_badge.dart';
import 'package:craft_flutter_template/features/setup_status/domain/runtime_check_entity.dart';
import 'package:flutter/material.dart';

/// One runtime check row on the Setup Status screen: status badge, step
/// title, outcome detail, and a run action.
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
    return ListTile(
      leading: _badge(),
      title: Text(step.title),
      subtitle: check.detail == null ? null : Text(check.detail!),
      trailing: switch (check.status) {
        RuntimeCheckStatus.skipped => null,
        RuntimeCheckStatus.running => null,
        _ => TextButton(onPressed: onRun, child: const Text('Run')),
      },
    );
  }

  AppIconBadge _badge() {
    if (check.status == RuntimeCheckStatus.running) {
      return const AppIconBadge(
        icon: Icons.sync,
        color: AppColors.info,
        background: AppColors.infoLight,
        child: SizedBox(
          width: AppConstants.iconXs,
          height: AppConstants.iconXs,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    final (
      IconData icon,
      Color color,
      Color background,
    ) = switch (check.status) {
      RuntimeCheckStatus.notRun => (
        Icons.play_arrow_rounded,
        AppColors.textSecondary,
        AppColors.backgroundTertiary,
      ),
      RuntimeCheckStatus.passed => (
        Icons.check_rounded,
        AppColors.success,
        AppColors.successLight,
      ),
      RuntimeCheckStatus.failed => (
        Icons.priority_high_rounded,
        AppColors.error,
        AppColors.errorLight,
      ),
      _ => (
        Icons.remove_rounded,
        AppColors.textDisabled,
        AppColors.backgroundSecondary,
      ),
    };
    return AppIconBadge(icon: icon, color: color, background: background);
  }
}
