import 'package:antigrav_flutter_template/core/constants/app_colors.dart';
import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// Semantic color role used to resolve a theme-appropriate fallback when no
/// explicit [AppText.color] is provided.
enum _ColorRole {
  /// Maps to [ColorScheme.onSurface] — headings and body copy.
  primary,

  /// Maps to [ColorScheme.onSurfaceVariant] — secondary and label copy.
  secondary,

  /// Maps to [ColorScheme.onSurfaceVariant] with reduced opacity — captions.
  tertiary,
}

/// A typography widget that enforces app-wide font sizes and text colors
/// via [AppConstants] and [AppColors].
///
/// Use the named constructors to select the appropriate text variant.
/// Avoid using [Text] with hardcoded styles anywhere in the app — all
/// text should go through [AppText] or a custom style built from
/// [AppConstants] and [AppColors].
///
/// When [color] is omitted the widget resolves a sensible default from the
/// ambient [ThemeData.colorScheme], so it renders correctly in both dark and
/// light themes without needing an explicit override.
///
/// Example:
/// ```dart
/// AppText.headingLarge('Welcome back')
/// AppText.bodyMedium('Sign in to continue', color: AppColors.textSecondary)
/// ```
class AppText extends StatelessWidget {
  /// Internal constructor. Use named constructors for specific variants.
  const AppText(
    this.text, {
    super.key,
    required this.fontSize,
    required this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    _ColorRole colorRole = _ColorRole.primary,
  }) : _colorRole = colorRole;

  // ---------------------------------------------------------------------------
  // Named constructors — one per typography variant
  // ---------------------------------------------------------------------------

  /// Large heading. 32sp bold. For hero titles and screen headers.
  factory AppText.headingLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: AppConstants.font3xl,
        color: color,
        fontWeight: FontWeight.w700,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  /// Medium heading. 24sp semibold. For section titles and dialog headings.
  factory AppText.headingMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: AppConstants.fontXxl,
        color: color,
        fontWeight: FontWeight.w600,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  /// Small heading. 20sp semibold. For card titles and sub-section headings.
  factory AppText.headingSmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: AppConstants.fontXl,
        color: color,
        fontWeight: FontWeight.w600,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  /// Large body text. 18sp regular. For emphasized body copy.
  factory AppText.bodyLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: AppConstants.fontLg,
        color: color,
        fontWeight: FontWeight.w400,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  /// Base body text. 16sp regular. Default for paragraph and list content.
  factory AppText.bodyMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: AppConstants.fontMd,
        color: color,
        fontWeight: FontWeight.w400,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  /// Small body text. 14sp regular. For secondary copy and form labels.
  factory AppText.bodySmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: AppConstants.fontSm,
        color: color,
        fontWeight: FontWeight.w400,
        colorRole: _ColorRole.secondary,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  /// Caption text. 12sp regular. For metadata, timestamps, and helper text.
  factory AppText.caption(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: AppConstants.fontXs,
        color: color,
        fontWeight: FontWeight.w400,
        colorRole: _ColorRole.tertiary,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  /// Label text. 12sp medium weight. For tags, badges, and input labels.
  factory AppText.label(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: AppConstants.fontXs,
        color: color,
        fontWeight: FontWeight.w500,
        colorRole: _ColorRole.secondary,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  // ---------------------------------------------------------------------------
  // Properties
  // ---------------------------------------------------------------------------

  /// The string content to display.
  final String text;

  /// The font size in logical pixels.
  final double fontSize;

  /// The text color.
  ///
  /// When `null` the color is resolved from [ThemeData.colorScheme] based on
  /// the variant's semantic role, so the widget adapts to dark and light themes
  /// automatically. Pass an explicit [AppColors] value to override this.
  final Color? color;

  /// The font weight.
  final FontWeight fontWeight;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The maximum number of lines before truncation.
  final int? maxLines;

  /// How overflowing text should be handled when [maxLines] is set.
  final TextOverflow? overflow;

  /// The semantic color role used when [color] is null.
  final _ColorRole _colorRole;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Resolves the effective text color from the ambient [ColorScheme] when no
  /// explicit [color] is provided.
  Color _resolveColor(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return switch (_colorRole) {
      _ColorRole.primary => cs.onSurface,
      _ColorRole.secondary => cs.onSurfaceVariant,
      _ColorRole.tertiary =>
        cs.onSurfaceVariant.withValues(alpha: AppConstants.opacityDim),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? _resolveColor(context),
        fontWeight: fontWeight,
      ),
    );
  }
}
