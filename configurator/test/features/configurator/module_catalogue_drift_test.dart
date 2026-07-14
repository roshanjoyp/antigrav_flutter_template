import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:craft_configurator/features/configurator/domain/module_catalogue.dart';

/// Drift guard: the configurator's catalogue must mirror the generator's
/// registry — ids, requires-relations, and pubspec deps — because the
/// configurator's output is the generator's input. Parses the registry
/// source directly so no cross-package dependency is needed.
void main() {
  final File registry = File('../generator/lib/src/module_registry.dart');

  test('generator registry file is reachable from configurator/', () {
    expect(
      registry.existsSync(),
      isTrue,
      reason:
          'expected the monorepo layout: configurator/ next to '
          'generator/',
    );
  });

  test('catalogue mirrors the generator module registry', () {
    final String source = registry.readAsStringSync();
    final Map<String, ({Set<String> requires, List<String> deps})> parsed = {};

    for (final Match block in RegExp(
      r'ModuleDefinition\(([\s\S]*?)\n  \),',
    ).allMatches(source)) {
      final String body = block.group(1)!;
      final String id = RegExp("id: '(\\w+)'").firstMatch(body)!.group(1)!;
      final Match? requiresMatch = RegExp(
        r'requires: \{([^}]*)\}',
      ).firstMatch(body);
      final Match? depsMatch = RegExp(
        r'pubspecDeps: \[([^\]]*)\]',
      ).firstMatch(body);
      parsed[id] = (
        requires: _quoted(requiresMatch?.group(1)).toSet(),
        deps: _quoted(depsMatch?.group(1)),
      );
    }

    expect(
      parsed,
      isNotEmpty,
      reason:
          'registry parse produced no modules — '
          'has module_registry.dart changed shape?',
    );

    expect(
      {for (final m in kModuleCatalogue) m.id},
      parsed.keys.toSet(),
      reason: 'module ids drifted between catalogue and registry',
    );
    for (final module in kModuleCatalogue) {
      expect(
        module.requires,
        parsed[module.id]!.requires,
        reason: 'requires drifted for "${module.id}"',
      );
      expect(
        module.pubspecDeps,
        parsed[module.id]!.deps,
        reason: 'pubspec deps drifted for "${module.id}"',
      );
    }
  });
}

List<String> _quoted(String? source) {
  if (source == null) return const [];
  return [for (final m in RegExp("'([^']+)'").allMatches(source)) m.group(1)!];
}
