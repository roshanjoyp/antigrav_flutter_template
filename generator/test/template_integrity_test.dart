/// Drift guards binding the module registry and the template together.
///
/// These run against the LIVE template tree (the parent repo), so any
/// new wiring added without markers, or registry entries that no longer
/// match files, fail here the day they are written.
library;

import 'dart:io';

import 'package:craft_generator/craft_generator.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

final Directory _root = () {
  final cwd = Directory.current.path;
  return Directory(
    File(p.join(cwd, 'setup', 'setup.dart')).existsSync()
        ? cwd
        : p.dirname(cwd),
  );
}();

/// Template-root-relative paths of all tracked text files worth
/// scanning (lib, test, tool — where Dart wiring can live).
List<String> _dartFiles() => ['lib', 'test', 'tool']
    .expand(
      (dir) => Directory(p.join(_root.path, dir))
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart')),
    )
    .map((f) => p.relative(f.path, from: _root.path))
    .toList();

String _read(String relative) =>
    File(p.join(_root.path, relative)).readAsStringSync();

/// relative path → owning module id, from the registry globs.
Map<String, String> _ownership(List<String> files) {
  final owned = <String, String>{};
  for (final module in kModules.values) {
    for (final pattern in module.ownedPaths) {
      final glob = Glob(pattern);
      for (final file in files) {
        if (!glob.matches(file)) continue;
        expect(
          owned[file] ?? module.id,
          module.id,
          reason: '$file claimed by both ${owned[file]} and ${module.id}',
        );
        owned[file] = module.id;
      }
    }
  }
  return owned;
}

void main() {
  final knownIds = kModules.keys.toSet();
  final dartFiles = _dartFiles();

  test('every registry glob matches at least one file', () {
    final all = Directory(_root.path)
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()
        .map((f) => p.relative(f.path, from: _root.path))
        .toList();
    for (final module in kModules.values) {
      for (final pattern in module.ownedPaths) {
        final glob = Glob(pattern);
        expect(
          all.any(glob.matches),
          isTrue,
          reason: 'module ${module.id}: "$pattern" matches nothing',
        );
      }
    }
  });

  test('markers are balanced with known ids everywhere', () {
    for (final file in dartFiles) {
      final source = _read(file);
      if (!source.contains('MODULE(')) continue;
      final (_, errors) = scanMarkers(source, knownIds: knownIds);
      expect(errors, isEmpty, reason: '$file: ${errors.join('; ')}');
    }
  });

  test('shared-file imports of module-owned paths sit inside that '
      'module\'s markers (the anti-rot core)', () {
    final owned = _ownership(dartFiles);
    final violations = <String>[];
    for (final file in dartFiles) {
      if (owned.containsKey(file)) continue; // module files may self-import
      final source = _read(file);
      final lines = source.split('\n');
      // Line -> excluded-module coverage, derived by re-stripping.
      for (final module in kModules.keys) {
        final without = stripMarkers(source, excluded: {module});
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          final match = RegExp(
            '''(?:import|export)\\s+'package:[a-z_]+/([^']+)';?''',
          ).firstMatch(line);
          if (match == null) continue;
          final target = 'lib/${match.group(1)}';
          if (owned[target] != module) continue;
          if (without.contains(line.replaceFirst(RegExp(r'\s*//.*$'), ''))) {
            violations.add(
              '$file:${i + 1} imports $target (owned by $module) '
              'outside a MODULE($module) marker',
            );
          }
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('vendor package imports only appear in owning module files', () {
    const vendorByModule = {
      'firebase_auth': 'firebase',
      'cloud_firestore': 'firebase',
      'firebase_crashlytics': 'firebase',
      'firebase_analytics': 'firebase',
      'google_sign_in': 'firebase',
      'purchases_flutter': 'revenuecat',
      'firebase_messaging': 'push',
    };
    final owned = _ownership(dartFiles);
    final violations = <String>[];
    for (final file in dartFiles) {
      final source = _read(file);
      for (final entry in vendorByModule.entries) {
        if (!source.contains('package:${entry.key}/')) continue;
        if (owned[file] == entry.value) continue;
        if (owned[file] == 'push' && entry.value == 'firebase') continue;
        // Shared files may use vendor imports only inside markers.
        final without = stripMarkers(source, excluded: {entry.value});
        if (without.contains('package:${entry.key}/')) {
          violations.add(
            '$file uses package:${entry.key} outside MODULE(${entry.value})',
          );
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('commercial license exists with both tiers (the pipeline ships '
      'it as the buyer\'s LICENSE)', () {
    final text = _read('LICENSE_COMMERCIAL.md');
    expect(text, contains('### Personal'));
    expect(text, contains('### Team'));
  });

  test('pubspec has every registry dep; checklist ids all covered', () {
    final pubspec = _read('pubspec.yaml');
    for (final module in kModules.values) {
      for (final dep in module.pubspecDeps) {
        expect(
          RegExp('^  $dep:', multiLine: true).hasMatch(pubspec),
          isTrue,
          reason: 'pubspec.yaml missing "$dep" (module ${module.id})',
        );
      }
    }
    final prefixes = [
      'core.',
      for (final m in kModules.values) ...m.checklistPrefixes,
    ];
    final checklist = _read('checklist.yaml');
    for (final match in RegExp(
      r'^  ([a-z_.]+):\s*$',
      multiLine: true,
    ).allMatches(checklist)) {
      final id = match.group(1)!;
      expect(
        prefixes.any(id.startsWith),
        isTrue,
        reason: 'checklist.yaml id "$id" not covered by any module prefix',
      );
    }
  });
}
