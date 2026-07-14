import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/constants/app_constants.dart';

/// Sharp square checkbox: 1px fg border; checked fills fg with a 3px bg
/// inset ring. Purely visual — tap handling belongs to the enclosing row.
class SharpCheckboxWidget extends StatelessWidget {
  /// Creates the checkbox visual for [checked].
  const SharpCheckboxWidget({super.key, required this.checked});

  /// Whether the box renders filled.
  final bool checked;

  @override
  Widget build(BuildContext context) {
    // Inner fill = box − 2×(1px border) − 2×(3px inset ring).
    const double inner =
        AppConstants.checkboxSize - 2 - 2 * AppConstants.checkboxInset;
    return Container(
      width: AppConstants.checkboxSize,
      height: AppConstants.checkboxSize,
      decoration: BoxDecoration(border: Border.all(color: AppColors.fg)),
      alignment: Alignment.center,
      child: checked
          ? Container(width: inner, height: inner, color: AppColors.fg)
          : null,
    );
  }
}
