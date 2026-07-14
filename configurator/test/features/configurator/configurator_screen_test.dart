import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:craft_configurator/app/configurator_app.dart';
import 'package:craft_configurator/features/configurator/domain/configuration_entity.dart';
import 'package:craft_configurator/features/configurator/domain/preview_derivations.dart';
import 'package:craft_configurator/features/configurator/presentation/configurator_controller.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const ProviderScope(child: ConfiguratorApp()));
  }

  testWidgets('renders hero, metrics, and the live preview summary', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.text('CRAFT'), findsOneWidget);
    expect(find.text('my_app.zip'), findsOneWidget);
    expect(
      find.text(PreviewDerivations.summary(ConfigurationEntity.initial())),
      findsOneWidget,
    );
  });

  testWidgets('toggling a module re-renders the preview summary', (
    tester,
  ) async {
    await pumpApp(tester);
    final ProviderContainer container = ProviderScope.containerOf(
      tester.element(find.byType(ConfiguratorApp)),
    );
    container
        .read(configuratorControllerProvider.notifier)
        .toggleModule('firebase', enabled: false);
    await tester.pumpAndSettle();

    final ConfigurationEntity config = container.read(
      configuratorControllerProvider,
    );
    expect(
      config.isEnabled('push'),
      isFalse,
      reason: 'push requires firebase and must drop with it',
    );
    expect(find.text(PreviewDerivations.summary(config)), findsOneWidget);
  });

  testWidgets('typing an app name updates zip name and package id', (
    tester,
  ) async {
    await pumpApp(tester);
    final Finder appNameField = find.byType(TextFormField).first;
    await tester.ensureVisible(appNameField);
    await tester.enterText(appNameField, 'Star Tracker');
    await tester.pumpAndSettle();
    expect(find.text('star_tracker.zip'), findsOneWidget);
    expect(
      find.textContaining('com.example.star_tracker', findRichText: true),
      findsOneWidget,
    );
  });
}
