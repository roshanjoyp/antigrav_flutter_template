import 'package:antigrav_flutter_template/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// A standardized scaffold wrapper that enforces the app background color
/// and safe area handling across all screens.
///
/// Use [AppScaffold] instead of [Scaffold] directly to ensure every screen
/// respects [AppColors.background] and applies consistent safe area padding.
///
/// Example:
/// ```dart
/// AppScaffold(
///   appBar: AppBar(title: const Text('Home')),
///   body: const Center(child: Text('Hello')),
/// )
/// ```
class AppScaffold extends StatelessWidget {
  /// Creates an [AppScaffold].
  ///
  /// [body] is the primary content of the screen.
  /// [appBar] is an optional app bar rendered at the top.
  /// [bottomNavigationBar] is an optional widget anchored to the bottom.
  /// [floatingActionButton] is an optional FAB overlaid on the body.
  /// [useSafeArea] wraps [body] in a [SafeArea] when `true` (default).
  /// [resizeToAvoidBottomInset] controls whether the body resizes for the
  /// keyboard; defaults to `true`.
  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.useSafeArea = true,
    this.resizeToAvoidBottomInset = true,
  });

  /// The primary content of the screen.
  final Widget body;

  /// An optional app bar displayed at the top of the screen.
  final PreferredSizeWidget? appBar;

  /// An optional widget anchored to the bottom of the screen,
  /// typically a [BottomNavigationBar] or [NavigationBar].
  final Widget? bottomNavigationBar;

  /// An optional floating action button overlaid on the body.
  final Widget? floatingActionButton;

  /// Whether to wrap [body] in a [SafeArea] to avoid system UI intrusions.
  ///
  /// Defaults to `true`. Set to `false` for full-bleed screens such as
  /// splash screens or media viewers.
  final bool useSafeArea;

  /// Whether the scaffold body should resize when the keyboard appears.
  ///
  /// Defaults to `true`.
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: useSafeArea ? SafeArea(child: body) : body,
    );
  }
}
