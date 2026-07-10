/// The generation pipeline: staging copy → subtract modules → rename →
/// gate → zip.
library;

import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

import 'config.dart';
import 'gates.dart';
import 'markers.dart';
import 'module_registry.dart';
import 'pruning.dart';
import 'staging.dart';

/// Outcome of a [generate] run.
class GenerateResult {
  /// Creates a result record.
  const GenerateResult({
    required this.ok,
    required this.log,
    this.zipPath,
    this.stagingPath,
  });

  /// Whether the pipeline completed and the zip was written.
  final bool ok;

  /// Step-by-step progress/failure log.
  final List<String> log;

  /// The produced zip, when [ok].
  final String? zipPath;

  /// The staging dir, when kept (failures or `keepStaging`).
  final String? stagingPath;
}

/// Runs the full pipeline for [config] against the template at
/// [templateRoot], writing the zip to [outPath].
GenerateResult generate(
  GeneratorConfig config, {
  required Directory templateRoot,
  required String outPath,
  GateLevel gate = GateLevel.analyze,
  bool keepStaging = false,
}) {
  final log = <String>[];
  final excluded = config.excluded;
  final staging = Directory(
    p.join(
      Directory.systemTemp.path,
      'craft_gen_${DateTime.now().millisecondsSinceEpoch}',
    ),
  );

  GenerateResult fail(String message) {
    log.add('✗ $message');
    return GenerateResult(
      ok: false,
      log: log,
      stagingPath: staging.existsSync() ? staging.path : null,
    );
  }

  try {
    // 1. Copy.
    copyTemplate(templateRoot, staging);
    log.add('✓ copied template → ${staging.path}');

    // 2. Delete excluded modules' owned files.
    for (final id in excluded) {
      final module = kModules[id]!;
      var deleted = 0;
      for (final pattern in module.ownedPaths) {
        final glob = Glob(pattern);
        var matched = 0;
        for (final entity in staging.listSync(
          recursive: true,
          followLinks: false,
        )) {
          if (entity is! File) continue;
          final rel = p.relative(entity.path, from: staging.path);
          if (glob.matches(rel)) {
            entity.deleteSync();
            matched++;
          }
        }
        if (matched == 0) {
          return fail(
            'module "$id": glob "$pattern" matched no files — '
            'registry out of date?',
          );
        }
        deleted += matched;
      }
      log.add('✓ removed $id ($deleted files)');
    }

    // 3. Marker pass over remaining text files.
    var stripped = 0;
    for (final entity in staging.listSync(recursive: true)) {
      if (entity is! File) continue;
      final ext = p.extension(entity.path);
      if (ext != '.dart' && ext != '.yaml' && ext != '.yml') continue;
      final source = entity.readAsStringSync();
      if (!source.contains('MODULE(')) continue;
      final (_, errors) = scanMarkers(source, knownIds: kModules.keys.toSet());
      if (errors.isNotEmpty) {
        return fail(
          'invalid markers in ${p.relative(entity.path, from: staging.path)}: '
          '${errors.join('; ')}',
        );
      }
      entity.writeAsStringSync(stripMarkers(source, excluded: excluded));
      stripped++;
    }
    log.add('✓ marker pass ($stripped files)');

    // 4. Prune pubspec deps and checklist items.
    final pubspec = File(p.join(staging.path, 'pubspec.yaml'));
    var pubspecSource = pubspec.readAsStringSync();
    final checklist = File(p.join(staging.path, 'checklist.yaml'));
    var checklistSource = checklist.readAsStringSync();
    for (final id in excluded) {
      pubspecSource = prunePubspecDeps(
        pubspecSource,
        kModules[id]!.pubspecDeps,
      );
      checklistSource = pruneChecklistItems(
        checklistSource,
        kModules[id]!.checklistPrefixes,
      );
    }
    pubspec.writeAsStringSync(pubspecSource);
    checklist.writeAsStringSync(checklistSource);
    log.add('✓ pruned pubspec + checklist');

    // 5. Rename to the buyer identity.
    final rename = Process.runSync('dart', [
      'setup/setup.dart',
      '--display-name',
      config.appName,
      '--package',
      config.packageId,
      '--description',
      config.description,
      '--yes',
      '--no-branding',
    ], workingDirectory: staging.path);
    if (rename.exitCode != 0) {
      return fail('rename failed:\n${rename.stdout}\n${rename.stderr}');
    }
    log.add('✓ renamed to ${config.packageId}');

    // 6. Gates.
    for (final step in runGates(staging, gate)) {
      if (!step.ok) return fail('${step.label} failed:\n${step.output}');
      log.add('✓ ${step.label}');
    }

    // 7. Zip (denylist re-applied: gates create .dart_tool etc.).
    final encoder = ZipFileEncoder()..create(outPath);
    for (final entity in staging.listSync(recursive: true)) {
      if (entity is! File) continue;
      final rel = p.relative(entity.path, from: staging.path);
      if (isDenied(rel)) continue;
      encoder.addFile(entity, rel);
    }
    encoder.closeSync();
    log.add('✓ wrote $outPath');

    return GenerateResult(
      ok: true,
      log: log,
      zipPath: outPath,
      stagingPath: keepStaging ? staging.path : null,
    );
  } finally {
    if (!keepStaging && log.isNotEmpty && log.last.startsWith('✓ wrote')) {
      staging.deleteSync(recursive: true);
    }
  }
}
