import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/constants/app_constants.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';

/// Sharp rectangular button with a tiny spaced-caps label.
///
/// Primary renders as a fg fill that inverts to an outline on hover;
/// [ghost] renders as an outline that fills on hover. Hover state is
/// purely visual, so it lives in this widget's local state.
class CraftButtonWidget extends StatefulWidget {
  /// Creates a button; a null [onPressed] renders it dimmed and inert.
  const CraftButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.ghost = false,
    this.compact = false,
  });

  /// Button caption (upper-cased automatically).
  final String label;

  /// Tap handler; null disables the button.
  final VoidCallback? onPressed;

  /// Outline-first variant (fills on hover).
  final bool ghost;

  /// Smaller padding, used in the nav bar.
  final bool compact;

  @override
  State<CraftButtonWidget> createState() => _CraftButtonWidgetState();
}

class _CraftButtonWidgetState extends State<CraftButtonWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onPressed != null;
    // Primary is filled unless hovered; ghost is the exact inverse.
    final bool filled = widget.ghost ? _hovered : !_hovered;
    final EdgeInsets padding = widget.compact
        ? const EdgeInsets.fromLTRB(24, 10, 20, 9)
        : const EdgeInsets.fromLTRB(36, 15, 34, 14);

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedOpacity(
          duration: AppConstants.hoverFast,
          opacity: enabled ? 1 : 0.38,
          child: AnimatedContainer(
            duration: AppConstants.hoverFast,
            padding: padding,
            decoration: BoxDecoration(
              color: filled && enabled ? AppColors.fg : Colors.transparent,
              border: Border.all(color: AppColors.fg),
            ),
            child: Text(
              widget.label.toUpperCase(),
              style: AppTypography.disp(
                size: 11,
                weight: 600,
                trackingEm: 0.3,
                color: filled && enabled ? AppColors.bg : AppColors.fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
