import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/core/utils/responsive.dart';
import 'package:craft_configurator/core/widgets/content_wrap_widget.dart';
import 'package:craft_configurator/core/widgets/craft_button_widget.dart';
import 'package:craft_configurator/core/widgets/micro_label_widget.dart';

/// Full-viewport hero: kicker, tracked CRAFT wordmark, acronym line,
/// lede, and the primary call to action.
class HeroSectionWidget extends StatelessWidget {
  /// Creates the hero; [onConfigure] scrolls to the configure section.
  const HeroSectionWidget({super.key, required this.onConfigure});

  /// Scrolls to the configure section.
  final VoidCallback onConfigure;

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.sizeOf(context);
    final double titleSize = clampVw(
      viewportWidth: viewport.width,
      min: 51.2,
      vwFactor: 0.12,
      max: 136,
    );

    // The Stack sizes itself from the non-positioned first child (the
    // scroll column is unbounded); the scroll tag then anchors to it.
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewport.height - AppConstants.navHeight,
          ),
          child: Center(
            child: ContentWrapWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MicroLabelWidget(
                      'Flutter starter — configured, not cloned',
                      rebalance: true,
                    ),
                    const SizedBox(height: 42),
                    Padding(
                      padding: EdgeInsets.only(left: titleSize * 0.28),
                      child: Text(
                        'CRAFT',
                        style:
                            AppTypography.disp(
                              size: titleSize,
                              weight: 700,
                              trackingEm: 0.28,
                              height: 1,
                            ).copyWith(
                              shadows: const [
                                Shadow(
                                  offset: Offset(0, 24),
                                  blurRadius: 60,
                                  color: Color(0x8C000000),
                                ),
                              ],
                            ),
                      ),
                    ),
                    const SizedBox(height: 42),
                    _acronymLine(),
                    const SizedBox(height: 32),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Text(
                        'Pick your modules. Download a codebase containing '
                        'only what you chose — architecture, tests, docs, and '
                        'a doctor that verifies your setup.',
                        textAlign: TextAlign.center,
                        style: AppTypography.text(
                          size: 15,
                          color: AppColors.muted,
                          height: 1.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 56),
                    CraftButtonWidget(
                      label: 'Configure your app',
                      onPressed: onConfigure,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (viewport.width > 900)
          Positioned(
            right: 34,
            bottom: 48,
            child: Column(
              children: [
                const RotatedBox(
                  quarterTurns: 1,
                  child: MicroLabelWidget('Scroll'),
                ),
                const SizedBox(height: 14),
                Container(width: 1, height: 56, color: AppColors.muted),
              ],
            ),
          ),
      ],
    );
  }

  /// `C·LEAN · R·IVERPOD …` — first letters emphasized, rest muted.
  Widget _acronymLine() {
    const List<String> words = [
      'CLEAN',
      'RIVERPOD',
      'ARCHITECTURE',
      'FLUTTER',
      'TEMPLATE',
    ];
    final TextStyle dim = AppTypography.code(
      size: 11,
      trackingEm: 0.18,
      color: AppColors.muted,
    );
    final TextStyle bright = AppTypography.code(
      size: 11,
      weight: 700,
      trackingEm: 0.18,
      color: AppColors.fg,
    );
    return Text.rich(
      TextSpan(
        children: [
          for (int i = 0; i < words.length; i++) ...[
            TextSpan(text: words[i][0], style: bright),
            TextSpan(text: words[i].substring(1), style: dim),
            if (i < words.length - 1) TextSpan(text: '  ·  ', style: dim),
          ],
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
