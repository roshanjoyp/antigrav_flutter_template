import 'package:flutter/material.dart';

import 'package:craft_configurator/core/constants/app_colors.dart';

/// The three typographic voices of the configurator.
///
/// 1. **Display** — Jost, ALL-CAPS with wide tracking (hero, titles, labels).
/// 2. **Body** — Inter, neutral sans for running copy.
/// 3. **Mono** — JetBrains Mono for code, file trees, and section numbers.
///
/// All faces ship as variable fonts, so weight is set through the `wght`
/// axis ([FontVariation]) with [FontWeight] kept in sync for semantics.
abstract final class AppTypography {
  /// Display family name as declared in pubspec.
  static const String display = 'Jost';

  /// Body family name as declared in pubspec.
  static const String body = 'Inter';

  /// Mono family name as declared in pubspec.
  static const String mono = 'JetBrains Mono';

  /// Builds a display (Jost) style; [trackingEm] is letter-spacing in em.
  static TextStyle disp({
    required double size,
    double weight = 500,
    double trackingEm = 0.3,
    Color color = AppColors.fg,
    double? height,
  }) {
    return TextStyle(
      fontFamily: display,
      fontSize: size,
      fontWeight: _nearest(weight),
      fontVariations: [FontVariation('wght', weight)],
      letterSpacing: size * trackingEm,
      color: color,
      height: height,
    );
  }

  /// Builds a body (Inter) style.
  static TextStyle text({
    double size = 16,
    double weight = 400,
    Color color = AppColors.fg,
    double height = 1.7,
  }) {
    return TextStyle(
      fontFamily: body,
      fontSize: size,
      fontWeight: _nearest(weight),
      fontVariations: [FontVariation('wght', weight)],
      color: color,
      height: height,
    );
  }

  /// Builds a mono (JetBrains Mono) style.
  static TextStyle code({
    double size = 11.5,
    double weight = 400,
    double trackingEm = 0.02,
    Color color = AppColors.fg,
    double height = 1.6,
  }) {
    return TextStyle(
      fontFamily: mono,
      fontSize: size,
      fontWeight: _nearest(weight),
      fontVariations: [FontVariation('wght', weight)],
      letterSpacing: size * trackingEm,
      color: color,
      height: height,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  /// Micro-label — the quietest voice: 10px spaced caps, muted.
  static TextStyle micro({
    Color color = AppColors.muted,
    double trackingEm = 0.42,
  }) {
    return disp(size: 10, weight: 500, trackingEm: trackingEm, color: color);
  }

  static FontWeight _nearest(double weight) {
    final int index = (weight / 100).round().clamp(1, 9) - 1;
    return FontWeight.values[index];
  }
}
