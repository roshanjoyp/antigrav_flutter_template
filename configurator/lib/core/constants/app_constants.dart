/// Spacing, dimensions, and durations for the configurator UI.
///
/// Values come from the v0.4 "breathable pass" of the design mockup
/// (`docs/design/configurator_mockup.html`); whitespace is part of the
/// visual identity, so nothing here is arbitrary.
abstract final class AppConstants {
  // ---- Layout ----

  /// Maximum content width of every section.
  static const double maxContentWidth = 1120;

  /// Horizontal page padding inside the content wrap.
  static const double pagePaddingH = 32;

  /// Height of the sticky top navigation bar.
  static const double navHeight = 80;

  /// Minimum vertical padding above a section (clamp lower bound).
  static const double sectionPadMin = 110;

  /// Maximum vertical padding above a section (clamp upper bound).
  static const double sectionPadMax = 190;

  /// Viewport-width factor for section padding (mockup: 14vw).
  static const double sectionPadVw = 0.14;

  /// Minimum gap between a section head and its content.
  static const double secHeadGapMin = 64;

  /// Maximum gap between a section head and its content.
  static const double secHeadGapMax = 104;

  /// Viewport-width factor for the section-head gap (mockup: 8vw).
  static const double secHeadGapVw = 0.08;

  /// Minimum gap between the form column and the preview column.
  static const double configGridGapMin = 48;

  /// Maximum gap between the form column and the preview column.
  static const double configGridGapMax = 88;

  /// Viewport-width factor for the config grid gap (mockup: 6vw).
  static const double configGridGapVw = 0.06;

  /// Width of the preview column on desktop layouts.
  static const double previewWidth = 440;

  /// Breakpoint below which the config grid stacks into one column.
  static const double configStackBreakpoint = 960;

  /// Breakpoint below which nav links and desktop-only chrome hide.
  static const double navLinksBreakpoint = 760;

  // ---- Component spacing (breathable pass) ----

  /// Vertical padding of one module row.
  static const double moduleRowPadV = 28;

  /// Gap between a module checkbox and its text block.
  static const double moduleRowGap = 20;

  /// Inner padding of the preview card head/panes/foot.
  static const double previewPad = 30;

  /// Gap between identity form fields.
  static const double identityGap = 36;

  /// Space between the identity block and the module list.
  static const double identityBottomGap = 32;

  /// Space above a module group label.
  static const double groupLabelTopGap = 60;

  /// Space below a module group label.
  static const double groupLabelBottomGap = 16;

  /// Vertical padding of one setup-step row in the preview.
  static const double stepRowPadV = 14;

  /// Side of the sharp square checkbox.
  static const double checkboxSize = 15;

  /// Inset ring width inside a checked checkbox.
  static const double checkboxInset = 3;

  /// Minimum height of a preview pane.
  static const double paneMinHeight = 360;

  /// Maximum height of a preview pane before it scrolls.
  static const double paneMaxHeight = 420;

  // ---- Durations ----

  /// Button hover fill/invert transition.
  static const Duration hoverFast = Duration(milliseconds: 150);

  /// Module row / grid cell opacity transition.
  static const Duration hoverMedium = Duration(milliseconds: 180);

  /// How long the download confirmation note stays visible.
  static const Duration toastVisible = Duration(milliseconds: 2600);
}
