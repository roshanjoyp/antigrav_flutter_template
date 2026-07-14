import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';
import 'package:craft_configurator/core/theme/app_typography.dart';
import 'package:craft_configurator/core/widgets/micro_label_widget.dart';

/// Underline-only text field with a micro-caps label above it, matching
/// the mockup's contact-form-style identity inputs.
class UnderlineFieldWidget extends StatelessWidget {
  /// Creates a labeled underline field.
  const UnderlineFieldWidget({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  /// Micro-caps label above the input.
  final String label;

  /// Value shown when the field is first built.
  final String initialValue;

  /// Called on every edit.
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MicroLabelWidget(label, size: 9, trackingEm: 0.32),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          style: AppTypography.text(size: 15, height: 1.4),
          cursorWidth: 1,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(top: 10, bottom: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.line),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.fg),
            ),
          ),
        ),
      ],
    );
  }
}
