import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';

/// Tiny spaced-caps label — the design's quietest voice.
///
/// When [rebalance] is true (centered contexts), leading padding equal to
/// the tracking is added so the tracked caps sit optically centered.
class MicroLabelWidget extends StatelessWidget {
  /// Creates a micro label; [text] is upper-cased automatically.
  const MicroLabelWidget(
    this.text, {
    super.key,
    this.size = 10,
    this.trackingEm = 0.42,
    this.color = AppColors.muted,
    this.rebalance = false,
  });

  /// Label text (any case).
  final String text;

  /// Font size in logical pixels.
  final double size;

  /// Letter-spacing in em.
  final double trackingEm;

  /// Text color.
  final Color color;

  /// Adds leading padding equal to the tracking (for centered labels).
  final bool rebalance;

  @override
  Widget build(BuildContext context) {
    final Widget label = Text(
      text.toUpperCase(),
      textAlign: rebalance ? TextAlign.center : TextAlign.start,
      style: AppTypography.disp(
        size: size,
        weight: 500,
        trackingEm: trackingEm,
        color: color,
      ),
    );
    if (!rebalance) return label;
    return Padding(
      padding: EdgeInsets.only(left: size * trackingEm),
      child: label,
    );
  }
}
