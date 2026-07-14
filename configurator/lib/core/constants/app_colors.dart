import 'package:flutter/material.dart';

/// The configurator's committed monochrome palette, dark-first.
///
/// Mirrors the token table in `docs/design/README.md` (design study v0.4).
/// There is deliberately no accent color: state is expressed through
/// contrast and opacity only.
abstract final class AppColors {
  /// Page / scaffold background — the charcoal stage.
  static const Color bg = Color(0xFF17181C);

  /// Floating card surface (the preview panel).
  static const Color panel = Color(0xFF1D1F25);

  /// Inset pane inside the preview card.
  static const Color panelDeep = Color(0xFF14151A);

  /// Primary text; also fills (buttons, checked states).
  static const Color fg = Color(0xFFF2F2EF);

  /// Secondary text on dark surfaces.
  static const Color muted = Color(0xFF8D8F96);

  /// Hairline borders — 1px everywhere.
  static const Color line = Color(0xFF2B2D34);

  /// Background of the single light band section.
  static const Color bandBg = Color(0xFFF4F4F1);

  /// Primary text on the light band.
  static const Color bandFg = Color(0xFF17181C);

  /// Secondary text on the light band.
  static const Color bandMuted = Color(0xFF6D6F6A);

  /// Hairlines on the light band.
  static const Color bandLine = Color(0xFFDDDCD5);

  /// Soft depth under the floating preview card (50% black).
  static const Color cardShadow = Color(0x80000000);
}
