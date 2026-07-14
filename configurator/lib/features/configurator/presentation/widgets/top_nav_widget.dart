import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/core/widgets/content_wrap_widget.dart';
import 'package:craft_configurator/core/widgets/craft_button_widget.dart';

/// Sticky top navigation: bordered CRAFT wordmark, section links, and the
/// ghost Start button. Links hide below [AppConstants.navLinksBreakpoint].
class TopNavWidget extends StatelessWidget {
  /// Creates the nav; each callback scrolls to its section.
  const TopNavWidget({
    super.key,
    required this.onConfigure,
    required this.onProcess,
    required this.onInside,
  });

  /// Scrolls to the configure section.
  final VoidCallback onConfigure;

  /// Scrolls to the process band.
  final VoidCallback onProcess;

  /// Scrolls to the what's-inside grid.
  final VoidCallback onInside;

  @override
  Widget build(BuildContext context) {
    final bool showLinks =
        MediaQuery.sizeOf(context).width > AppConstants.navLinksBreakpoint;
    return Container(
      height: AppConstants.navHeight,
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: ContentWrapWidget(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(9, 6, 8, 5),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.fg),
              ),
              child: Text(
                'CRA\nFT',
                textAlign: TextAlign.center,
                style: AppTypography.disp(
                  size: 11,
                  weight: 700,
                  trackingEm: 0.18,
                  height: 1.25,
                ),
              ),
            ),
            const Spacer(),
            if (showLinks) ...[
              _NavLink('Configure', onTap: onConfigure),
              const SizedBox(width: 44),
              _NavLink('Process', onTap: onProcess),
              const SizedBox(width: 44),
              _NavLink('Inside', onTap: onInside),
              const Spacer(),
            ],
            CraftButtonWidget(
              label: 'Start',
              ghost: true,
              compact: true,
              onPressed: onConfigure,
            ),
          ],
        ),
      ),
    );
  }
}

/// One nav link: muted spaced caps that brighten on hover.
class _NavLink extends StatefulWidget {
  const _NavLink(this.label, {required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label.toUpperCase(),
          style: AppTypography.disp(
            size: 10,
            weight: 500,
            trackingEm: 0.32,
            color: _hovered ? AppColors.fg : AppColors.muted,
          ),
        ),
      ),
    );
  }
}
