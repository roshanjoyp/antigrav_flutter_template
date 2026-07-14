import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/core/utils/responsive.dart';

/// Centered section head: mono number, spaced-caps title, muted lede.
class SectionHeadWidget extends StatelessWidget {
  /// Creates a section head; [onBand] switches to light-band colors.
  const SectionHeadWidget({
    super.key,
    required this.number,
    required this.title,
    this.lede,
    this.onBand = false,
  });

  /// Mono section number, e.g. `.01`.
  final String number;

  /// Section title (upper-cased automatically).
  final String title;

  /// Optional one-sentence subtitle.
  final String? lede;

  /// Whether the head sits on the light band.
  final bool onBand;

  @override
  Widget build(BuildContext context) {
    final Color mutedColor = onBand ? AppColors.bandMuted : AppColors.muted;
    final Color fgColor = onBand ? AppColors.bandFg : AppColors.fg;
    final double width = MediaQuery.sizeOf(context).width;
    final double titleSize = clampVw(
      viewportWidth: width,
      min: 22.4,
      vwFactor: 0.03,
      max: 32,
    );

    return Column(
      children: [
        Text(
          number,
          style: AppTypography.code(
            size: 11,
            trackingEm: 0.2,
            color: mutedColor,
          ),
        ),
        const SizedBox(height: 22),
        Padding(
          // Re-center the tracked caps (mockup: padding-left = tracking).
          padding: EdgeInsets.only(left: titleSize * 0.3),
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTypography.disp(
              size: titleSize,
              weight: 500,
              trackingEm: 0.3,
              color: fgColor,
              height: 1.2,
            ),
          ),
        ),
        if (lede != null) ...[
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              lede!,
              textAlign: TextAlign.center,
              style: AppTypography.text(
                size: 15,
                color: mutedColor,
                height: 1.8,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
