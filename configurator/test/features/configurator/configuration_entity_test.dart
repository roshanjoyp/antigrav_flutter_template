import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:craft_configurator/features/configurator/domain/configuration_entity.dart';
import 'package:craft_configurator/features/configurator/domain/module_catalogue.dart';
import 'package:craft_configurator/features/configurator/domain/preview_derivations.dart';

void main() {
  group('ConfigurationEntity derivations', () {
    test('derives snake_case project name, package id, and zip name', () {
      final ConfigurationEntity config = ConfigurationEntity.initial().copyWith(
        appName: 'My Cool App!',
        organization: 'dev.craft',
      );
      expect(config.projectName, 'my_cool_app');
      expect(config.packageId, 'dev.craft.my_cool_app');
      expect(config.zipName, 'my_cool_app.zip');
    });

    test('initial configuration is valid with all modules on', () {
      final ConfigurationEntity config = ConfigurationEntity.initial();
      expect(config.isValid, isTrue);
      expect(config.enabledModules.length, kModuleCatalogue.length);
    });

    test('flags generator-invalid identity values', () {
      final ConfigurationEntity config = ConfigurationEntity.initial().copyWith(
        appName: 'X',
        organization: 'nodots',
        description: 'shrt',
      );
      expect(config.validationErrors, hasLength(3));
      expect(config.isValid, isFalse);
    });
  });

  group('requires-relations', () {
    test('disabling firebase also drops push', () {
      final ConfigurationEntity config = ConfigurationEntity.initial()
          .withModule('firebase', enabled: false);
      expect(config.isEnabled('firebase'), isFalse);
      expect(config.isEnabled('push'), isFalse);
      expect(config.isEnabled('revenuecat'), isTrue);
    });

    test('enabling push pulls firebase back in', () {
      final ConfigurationEntity config = ConfigurationEntity.initial()
          .withModule('firebase', enabled: false)
          .withModule('push', enabled: true);
      expect(config.isEnabled('firebase'), isTrue);
      expect(config.isEnabled('push'), isTrue);
    });
  });

  group('config.json output', () {
    test('matches the generator schema exactly', () {
      final ConfigurationEntity config = ConfigurationEntity.initial()
          .withModule('firebase', enabled: false);
      final Object? decoded = jsonDecode(config.toConfigJsonString());
      expect(decoded, isA<Map<String, Object?>>());
      final Map<String, Object?> json = decoded! as Map<String, Object?>;
      expect(json.keys.toSet(), {
        'appName',
        'packageId',
        'description',
        'modules',
      });
      final Map<String, Object?> modules =
          json['modules']! as Map<String, Object?>;
      expect(modules.keys.toSet(), {for (final m in kModuleCatalogue) m.id});
      expect(modules['firebase'], isFalse);
      expect(modules['push'], isFalse);
      expect(modules['revenuecat'], isTrue);
      expect(modules['onboarding'], isTrue);
    });
  });

  group('PreviewDerivations', () {
    test('deps are deduped, sorted, and summary counts add up', () {
      final ConfigurationEntity config = ConfigurationEntity.initial();
      final List<String> deps = PreviewDerivations.addedDeps(config);
      expect(deps, deps.toSet().toList()..sort());
      final int stepCount = PreviewDerivations.steps(config).length;
      expect(
        PreviewDerivations.summary(config),
        '${config.enabledModules.length} modules · '
        '${kBaseDeps.length + deps.length} dependencies · '
        '$stepCount setup steps',
      );
    });

    test('file tree marks module paths as added', () {
      final ConfigurationEntity config = ConfigurationEntity.initial();
      final List<PreviewLine> lines = PreviewDerivations.fileTree(config);
      expect(lines.first.text, '${config.projectName}/');
      expect(lines.first.added, isFalse);
      expect(lines.where((l) => l.added), isNotEmpty);
    });
  });
}
