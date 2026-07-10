/// Pubspec, Dart source, and docs rename updates.
library;

import 'dart:io';

import 'setup_io.dart';

/// Updates the `name:` field in pubspec.yaml.
void updatePubspec(String oldDartPkg, String newDartPkg) {
  updateFile('pubspec.yaml', (content) {
    return content.replaceAllMapped(
      RegExp(r'^(name:\s*)' + RegExp.escape(oldDartPkg), multiLine: true),
      (m) => '${m.group(1)}$newDartPkg',
    );
  });
}

/// Replaces the pubspec `description` (the template ships a folded
/// multi-line one) with the buyer's single-line [newDescription].
void updatePubspecDescription(String newDescription) {
  updateFile('pubspec.yaml', (content) {
    return content.replaceFirst(
      RegExp(r'^description:[\s\S]*?(?=^\S)', multiLine: true),
      'description: $newDescription\n',
    );
  });
}

/// Updates the appName string constant in app_constants.dart.
void updateAppConstants(String newDisplayName) {
  updateFile('lib/core/constants/app_constants.dart', (content) {
    // Matches: static const String appName = 'OldName';
    return content.replaceAllMapped(
      RegExp(
        r"(static\s+const\s+String\s+appName\s*=\s*')[^']*(';?)",
        multiLine: true,
      ),
      (m) => '${m.group(1)}$newDisplayName${m.group(2)}',
    );
  });
}

/// Replaces all `package:oldDartPkg/` import prefixes in every .dart file
/// under [dirPath]. Reports a single aggregate result for the directory.
void updateDartImports(String dirPath, String oldDartPkg, String newDartPkg) {
  final dir = Directory(dirPath);
  if (!dir.existsSync()) {
    results.add(
      FileResult(dirPath, FileStatus.notFound, 'directory not found — skipped'),
    );
    return;
  }

  final dartFiles = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  int modifiedCount = 0;
  for (final file in dartFiles) {
    try {
      final original = file.readAsStringSync();
      final updated = original.replaceAll(
        'package:$oldDartPkg/',
        'package:$newDartPkg/',
      );
      if (updated != original) {
        file.writeAsStringSync(updated);
        modifiedCount++;
      }
    } catch (e) {
      stderr.writeln('  ⚠ Could not process ${file.path}: $e');
    }
  }

  results.add(
    FileResult(
      '$dirPath/**/*.dart',
      modifiedCount > 0 ? FileStatus.modified : FileStatus.noChangeNeeded,
      'scanned ${dartFiles.length} files, updated $modifiedCount',
    ),
  );
}

/// Replaces the old Dart package name in CLAUDE.md (e.g. import examples).
void updateClaudeMd(String oldDartPkg, String newDartPkg) {
  updateFile(
    'CLAUDE.md',
    (content) => content.replaceAll(oldDartPkg, newDartPkg),
  );
}

/// Replaces old package names in README.md if the file exists.
void updateReadme(
  String oldDartPkg,
  String newDartPkg,
  String oldAndroidPkg,
  String newAndroidPkg,
) {
  if (!File('README.md').existsSync()) {
    results.add(
      const FileResult(
        'README.md',
        FileStatus.notFound,
        'not present — skipped',
      ),
    );
    return;
  }
  updateFile('README.md', (content) {
    var updated = content.replaceAll(oldDartPkg, newDartPkg);
    updated = updated.replaceAll(oldAndroidPkg, newAndroidPkg);
    return updated;
  });
}
