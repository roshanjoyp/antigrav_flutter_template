import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;

/// Test helpers for pumping widgets inside the app's shell.
extension PumpApp on WidgetTester {
  /// Pumps [widget] wrapped in a [ProviderScope] and [MaterialApp],
  /// mirroring the app's real ancestry so core widgets resolve theme,
  /// localization, and providers exactly as in production.
  ///
  /// Pass [overrides] to swap providers with fakes — the same pattern
  /// used at app level in `lib/app/config/firebase_overrides.dart`.
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const <Override>[],
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(home: Scaffold(body: widget)),
      ),
    );
  }
}
