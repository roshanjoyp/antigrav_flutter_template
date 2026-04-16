import 'package:flutter/material.dart';

/// Defines all colors used throughout the application.
///
/// This is an abstract class and cannot be instantiated.
/// All colors are static constants. No color should be hardcoded
/// anywhere else in the codebase — always reference this class.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // 1. Core / Background Colors
  // ---------------------------------------------------------------------------

  /// The primary application background. Deep black base.
  static const Color background = Color(0xFF0A0A0A);

  /// A slightly elevated background, used for nested content areas.
  static const Color backgroundElevated = Color(0xFF111111);

  /// Secondary background layer, for drawers, bottom sheets, modals.
  static const Color backgroundSecondary = Color(0xFF1A1A1A);

  /// Tertiary background layer, for further nested surfaces.
  static const Color backgroundTertiary = Color(0xFF222222);

  // ---------------------------------------------------------------------------
  // 2. Accent Colors (single swappable accent system)
  // ---------------------------------------------------------------------------

  // 🎨 TO REBRAND: Change `accent` and update `accentLight`, `accentDark`,
  // `accentMuted` to match. All other files reference these four constants —
  // nothing else needs changing.

  /// Primary accent color. Swap this to rebrand the entire app.
  static const Color accent = Color(0xFF6C63FF);

  /// Lighter tint of the accent, for hover states and subtle highlights.
  static const Color accentLight = Color(0xFF9D97FF);

  /// Darker shade of the accent, for pressed states and depth.
  static const Color accentDark = Color(0xFF4B43CC);

  /// Muted/faded accent for disabled or inactive accent elements.
  static const Color accentMuted = Color(0xFF3D3A66);

  // ---------------------------------------------------------------------------
  // 3. Text Colors
  // ---------------------------------------------------------------------------

  /// Primary text color. Used for headings and body copy on dark backgrounds.
  static const Color textPrimary = Color(0xFFF5F5F5);

  /// Secondary text color. Used for subtitles, captions, and helper text.
  static const Color textSecondary = Color(0xFFAAAAAA);

  /// Tertiary text color. Used for placeholders and deeply de-emphasised text.
  static const Color textTertiary = Color(0xFF666666);

  /// Disabled text color. Used when text belongs to an inactive element.
  static const Color textDisabled = Color(0xFF444444);

  /// Text color used on top of the accent color (e.g. inside accent buttons).
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------------
  // 4. Surface / Card Colors
  // ---------------------------------------------------------------------------

  /// Default surface color for cards, list tiles, and contained elements.
  static const Color surface = Color(0xFF1C1C1C);

  /// Elevated surface, one level above [surface], for stacked cards or dialogs.
  static const Color surfaceElevated = Color(0xFF252525);

  /// Highlighted surface, used for selected or active list items.
  static const Color surfaceHighlight = Color(0xFF2E2E2E);

  /// Inverse surface for elements that need to stand out against dark backgrounds.
  static const Color surfaceInverse = Color(0xFFF0F0F0);

  // ---------------------------------------------------------------------------
  // 5. Status Colors (error, success, warning, info)
  // ---------------------------------------------------------------------------

  /// Error color. Used for destructive actions, validation failures, and alerts.
  static const Color error = Color(0xFFFF4D4F);

  /// Light tint of [error], for error backgrounds and banners.
  static const Color errorLight = Color(0xFF4A1212);

  /// Success color. Used for confirmations, completed states, and positive feedback.
  static const Color success = Color(0xFF52C41A);

  /// Light tint of [success], for success backgrounds and banners.
  static const Color successLight = Color(0xFF162A0A);

  /// Warning color. Used for cautionary actions and degraded states.
  static const Color warning = Color(0xFFFAAD14);

  /// Light tint of [warning], for warning backgrounds and banners.
  static const Color warningLight = Color(0xFF3D2A00);

  /// Info color. Used for informational messages and neutral notices.
  static const Color info = Color(0xFF1890FF);

  /// Light tint of [info], for info backgrounds and banners.
  static const Color infoLight = Color(0xFF00213D);

  // ---------------------------------------------------------------------------
  // 6. Border Colors
  // ---------------------------------------------------------------------------

  /// Default border color for containers, inputs, and dividers.
  static const Color border = Color(0xFF2C2C2C);

  /// Subtle border, for very light visual separation without strong contrast.
  static const Color borderSubtle = Color(0xFF1F1F1F);

  /// Strong border, for focused inputs or prominent outlines.
  static const Color borderStrong = Color(0xFF444444);

  /// Accent-colored border, used for focused or active input fields.
  static const Color borderAccent = Color(0xFF6C63FF);

  // ---------------------------------------------------------------------------
  // 7. Overlay Colors
  // ---------------------------------------------------------------------------

  /// Light scrim overlay, used behind bottom sheets and side drawers.
  static const Color overlayLight = Color(0x66000000);

  /// Medium scrim overlay, used behind dialogs and modals.
  static const Color overlayMedium = Color(0x99000000);

  /// Heavy scrim overlay, used for full-screen blocking overlays.
  static const Color overlayHeavy = Color(0xCC000000);

  /// White overlay tint, used for shimmer or frosted-glass effects on dark surfaces.
  static const Color overlayWhite = Color(0x0FFFFFFF);
}
