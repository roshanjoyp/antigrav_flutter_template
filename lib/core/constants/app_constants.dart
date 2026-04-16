/// Defines all spacing, sizing, duration, and string constants for the app.
///
/// This is an abstract class and cannot be instantiated.
/// No magic numbers should appear anywhere in the codebase —
/// always reference a constant from this class.
abstract final class AppConstants {
  // ---------------------------------------------------------------------------
  // 1. Spacing
  // ---------------------------------------------------------------------------

  /// 4dp — micro spacing. Tight gaps between closely related elements.
  static const double spaceXxs = 4;

  /// 8dp — extra small spacing. Icon-to-label gaps, compact padding.
  static const double spaceXs = 8;

  /// 12dp — small spacing. Inner padding for chips, tags, and small containers.
  static const double spaceSm = 12;

  /// 16dp — base spacing unit. Default padding for cards, list tiles, and screens.
  static const double spaceMd = 16;

  /// 20dp — medium-large spacing. Gaps between form fields.
  static const double spaceLg = 20;

  /// 24dp — large spacing. Section gaps within a screen.
  static const double spaceXl = 24;

  /// 32dp — extra large spacing. Spacing between major layout blocks.
  static const double spaceXxl = 32;

  /// 40dp — 2x extra large spacing. Hero section padding and large gaps.
  static const double space3xl = 40;

  /// 48dp — 3x extra large spacing. Top/bottom screen padding on large layouts.
  static const double space4xl = 48;

  /// 64dp — jumbo spacing. Full-bleed section separators and large illustrations.
  static const double space5xl = 64;

  // ---------------------------------------------------------------------------
  // 2. Border Radius
  // ---------------------------------------------------------------------------

  /// 4dp radius — subtle rounding. Used on chips, tags, and small badges.
  static const double radiusXs = 4;

  /// 8dp radius — small rounding. Used on input fields and small cards.
  static const double radiusSm = 8;

  /// 12dp radius — medium rounding. Used on standard cards and containers.
  static const double radiusMd = 12;

  /// 16dp radius — large rounding. Used on bottom sheets and prominent cards.
  static const double radiusLg = 16;

  /// 24dp radius — extra large rounding. Used on modals and floating panels.
  static const double radiusXl = 24;

  /// 32dp radius — pill-adjacent rounding. Used on large action buttons.
  static const double radiusXxl = 32;

  /// 999dp radius — fully rounded. Use for pill-shaped buttons and avatar chips.
  static const double radiusFull = 999;

  // ---------------------------------------------------------------------------
  // 3. Animation Durations
  // ---------------------------------------------------------------------------

  /// 100ms — instant feedback. Ripple effects, icon state swaps.
  static const Duration durationInstant = Duration(milliseconds: 100);

  /// 150ms — fast micro-interaction. Button press states, focus rings.
  static const Duration durationFast = Duration(milliseconds: 150);

  /// 250ms — standard transition. Most UI state changes and fades.
  static const Duration durationNormal = Duration(milliseconds: 250);

  /// 350ms — medium transition. Page route transitions and drawer slides.
  static const Duration durationMedium = Duration(milliseconds: 350);

  /// 500ms — slow transition. Complex animated layouts and hero transitions.
  static const Duration durationSlow = Duration(milliseconds: 500);

  /// 800ms — extra slow transition. Onboarding animations and splash sequences.
  static const Duration durationXSlow = Duration(milliseconds: 800);

  /// 1200ms — deliberate animation. Lottie intros and loading screen sequences.
  static const Duration durationXxSlow = Duration(milliseconds: 1200);

  /// 1500ms — minimum splash screen visibility. Ensures the splash is seen
  /// even when startup logic completes quickly.
  static const Duration durationSplash = Duration(milliseconds: 1500);

  // ---------------------------------------------------------------------------
  // 4. Font Sizes
  // ---------------------------------------------------------------------------

  /// 10sp — micro label. Used for badges, timestamps, and fine print.
  static const double fontXxs = 10;

  /// 12sp — caption. Used for helper text, metadata, and secondary labels.
  static const double fontXs = 12;

  /// 14sp — small body. Used for secondary body copy and form labels.
  static const double fontSm = 14;

  /// 16sp — base body. Default text size for paragraph and list content.
  static const double fontMd = 16;

  /// 18sp — large body. Used for emphasized body copy and card titles.
  static const double fontLg = 18;

  /// 20sp — small heading. Section titles and dialog headings.
  static const double fontXl = 20;

  /// 24sp — medium heading. Screen titles and feature headings.
  static const double fontXxl = 24;

  /// 32sp — large heading. Hero titles and onboarding headlines.
  static const double font3xl = 32;

  /// 40sp — display. Used sparingly for marketing-style splash text.
  static const double font4xl = 40;

  /// 48sp — jumbo display. Full-screen hero numbers and bold statements.
  static const double font5xl = 48;

  // ---------------------------------------------------------------------------
  // 5. Icon Sizes
  // ---------------------------------------------------------------------------

  /// 16dp — micro icon. Inline icons alongside small body text.
  static const double iconXs = 16;

  /// 20dp — small icon. Compact navigation and action icons.
  static const double iconSm = 20;

  /// 24dp — standard icon. Default size for all toolbar and list icons.
  static const double iconMd = 24;

  /// 32dp — large icon. Feature icons in empty states and banners.
  static const double iconLg = 32;

  /// 48dp — extra large icon. Onboarding and dialog focal icons.
  static const double iconXl = 48;

  /// 64dp — jumbo icon. Full-screen illustration anchor icons.
  static const double iconXxl = 64;

  // ---------------------------------------------------------------------------
  // 6. Elevation Values
  // ---------------------------------------------------------------------------

  /// 0dp — flat. No shadow, used on backgrounds and inline surfaces.
  static const double elevationNone = 0;

  /// 1dp — whisper shadow. Subtle card lift from background.
  static const double elevationXs = 1;

  /// 2dp — low elevation. Default card shadow.
  static const double elevationSm = 2;

  /// 4dp — medium elevation. Dropdowns, tooltips, and raised buttons.
  static const double elevationMd = 4;

  /// 8dp — high elevation. Bottom sheets and persistent banners.
  static const double elevationLg = 8;

  /// 16dp — very high elevation. Modals and full-screen dialogs.
  static const double elevationXl = 16;

  /// 24dp — maximum elevation. Navigation drawers and side panels.
  static const double elevationXxl = 24;

  // ---------------------------------------------------------------------------
  // 7. Opacity Values
  // ---------------------------------------------------------------------------

  /// 0.0 — fully transparent.
  static const double opacityNone = 0.0;

  /// 0.08 — barely visible. Ghost hover states and watermarks.
  static const double opacityGhost = 0.08;

  /// 0.16 — very faint. Subtle pressed states and disabled overlays.
  static const double opacityFaint = 0.16;

  /// 0.32 — dim. Disabled elements and inactive indicators.
  static const double opacityDim = 0.32;

  /// 0.48 — muted. Secondary icon opacity and hint text.
  static const double opacityMuted = 0.48;

  /// 0.64 — medium. Scrim behind drawers and context menus.
  static const double opacityMedium = 0.64;

  /// 0.80 — strong. Modal backdrops and focused overlays.
  static const double opacityStrong = 0.80;

  /// 1.0 — fully opaque.
  static const double opacityFull = 1.0;

  // ---------------------------------------------------------------------------
  // 8. Z-index / Overlay Ordering
  // ---------------------------------------------------------------------------

  /// Base layer. Normal in-flow content.
  static const int zBase = 0;

  /// Raised layer. Sticky headers, pinned list items.
  static const int zRaised = 10;

  /// Dropdown layer. Context menus and autocomplete overlays.
  static const int zDropdown = 100;

  /// Sticky layer. Persistent bottom bars and floating action buttons.
  static const int zSticky = 200;

  /// Drawer layer. Side navigation drawers.
  static const int zDrawer = 300;

  /// Modal layer. Dialogs, alert sheets, and bottom sheets.
  static const int zModal = 400;

  /// Toast layer. Snackbars and transient notification banners.
  static const int zToast = 500;

  /// Tooltip layer. Floating hints that must appear above all other content.
  static const int zTooltip = 600;

  /// Maximum layer. Full-screen overlays, loading gates.
  static const int zOverlay = 900;

  // ---------------------------------------------------------------------------
  // 9. App-Wide String Constants
  // ---------------------------------------------------------------------------

  /// The display name of the application.
  /// ⚠️ SETUP_MANAGED — updated automatically by setup.sh
  static const String appName = 'AntiGrav';

  /// Version placeholder. Replace with dynamic version retrieval in production.
  static const String appVersion = '1.0.0';

  /// Build number placeholder. Replace with dynamic build retrieval in production.
  static const String appBuild = '1';

  /// Default locale language code used on first launch.
  static const String defaultLocale = 'en';

  /// Key used to persist the user's selected theme in secure storage.
  static const String storageKeyTheme = 'app_theme';

  /// Key used to persist the user's selected locale in secure storage.
  static const String storageKeyLocale = 'app_locale';

  /// Key used to persist the auth token in secure storage.
  static const String storageKeyAuthToken = 'auth_token';

  /// Key used to persist the refresh token in secure storage.
  static const String storageKeyRefreshToken = 'refresh_token';

  // ---------------------------------------------------------------------------
  // 10. Breakpoints (responsive layout)
  // ---------------------------------------------------------------------------

  /// 360dp — minimum supported phone width.
  static const double breakpointMobileXs = 360;

  /// 480dp — large phone / small phablet.
  static const double breakpointMobileLg = 480;

  /// 600dp — small tablet / large phablet landscape.
  static const double breakpointTabletSm = 600;

  /// 840dp — standard tablet portrait.
  static const double breakpointTabletMd = 840;

  /// 1024dp — tablet landscape / small desktop.
  static const double breakpointTabletLg = 1024;

  /// 1280dp — standard desktop / large tablet landscape.
  static const double breakpointDesktopSm = 1280;

  /// 1440dp — wide desktop.
  static const double breakpointDesktopMd = 1440;

  /// 1920dp — full HD and above. Ultra-wide layouts.
  static const double breakpointDesktopLg = 1920;
}
