/// antigrav_flutter_template setup script
///
/// Renames the app name and package name
/// throughout the entire project.
///
/// Usage:
///   dart setup/setup.dart
///
/// See README.md for full setup instructions
/// before running this script.

// ignore_for_file: avoid_print

import 'dart:io';

// =============================================================================
// Result tracking
// =============================================================================

/// All file operation outcomes, printed in the final summary.
final List<_FileResult> _results = [];

enum _Status { modified, noChangeNeeded, notFound }

class _FileResult {
  const _FileResult(this.path, this.status, [this.detail]);
  final String path;
  final _Status status;
  final String? detail;
}

// =============================================================================
// Prompt helpers
// =============================================================================

/// Writes [question] to stdout and returns the trimmed response from stdin.
String _prompt(String question) {
  stdout.write(question);
  return (stdin.readLineSync() ?? '').trim();
}

// =============================================================================
// Validation
// =============================================================================

/// Fully-qualified Android/iOS package name:
/// at least 3 dot-separated lowercase segments, each starting with a letter.
final _packageNameRegex = RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*){2,}$');

/// Repeatedly prompts until a valid package name is entered.
String _promptPackageName() {
  while (true) {
    final input = _prompt('Package name (e.g. com.example.myapp): ');
    if (_packageNameRegex.hasMatch(input)) return input;
    stderr.writeln(
      '  ✗ Invalid. Must match ^[a-z][a-z0-9_]*([.][a-z][a-z0-9_]*){2,}\$\n'
      '    Example: com.example.myapp',
    );
  }
}

/// Repeatedly prompts until a display name of 2–50 characters is entered.
String _promptDisplayName() {
  while (true) {
    final input = _prompt('App display name (e.g. Just Tap): ');
    if (input.length >= 2 && input.length <= 50) return input;
    stderr.writeln(
      '  ✗ Display name must be 2–50 characters. '
      'Got ${input.length}.',
    );
  }
}

// =============================================================================
// Detection helpers — read current values from existing project files
// =============================================================================

/// Reads the current Dart package name from pubspec.yaml `name:` field.
String? _detectOldDartPackage() {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) return null;
  final match = RegExp(
    r'^name:\s*(\S+)',
    multiLine: true,
  ).firstMatch(file.readAsStringSync());
  return match?.group(1);
}

/// Reads the current Android applicationId from build.gradle.kts or
/// build.gradle (supports both Kotlin DSL and Groovy DSL).
String? _detectOldAndroidPackage() {
  for (final path in [
    'android/app/build.gradle.kts',
    'android/app/build.gradle',
  ]) {
    final file = File(path);
    if (!file.existsSync()) continue;
    final match = RegExp(
      r'applicationId\s*=?\s*"([^"]+)"',
    ).firstMatch(file.readAsStringSync());
    if (match != null) return match.group(1);
  }
  return null;
}

/// Reads the current iOS PRODUCT_BUNDLE_IDENTIFIER from project.pbxproj.
/// Returns the base app identifier (first match), which is the runner target.
String? _detectOldBundleId() {
  final file = File('ios/Runner.xcodeproj/project.pbxproj');
  if (!file.existsSync()) return null;
  final match = RegExp(
    r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([^;]+);',
  ).firstMatch(file.readAsStringSync());
  return match?.group(1)?.trim();
}

// =============================================================================
// Core file-update helper
// =============================================================================

/// Reads the file at [path], applies [transform] to its contents, and writes
/// the result back only if the content changed. Records the outcome in
/// [_results] for the final summary. Never throws — a missing file or
/// read/write error is logged as a warning and skipped.
void _updateFile(
  String path,
  String Function(String content) transform, {
  String? label,
}) {
  final displayPath = label ?? path;
  final file = File(path);

  if (!file.existsSync()) {
    _results.add(_FileResult(displayPath, _Status.notFound, 'file not found — skipped'));
    return;
  }

  try {
    final original = file.readAsStringSync();
    final updated = transform(original);
    if (updated == original) {
      _results.add(_FileResult(displayPath, _Status.noChangeNeeded));
    } else {
      file.writeAsStringSync(updated);
      _results.add(_FileResult(displayPath, _Status.modified));
    }
  } catch (e) {
    _results.add(_FileResult(displayPath, _Status.notFound, 'error: $e — skipped'));
  }
}

// =============================================================================
// Android updates
// =============================================================================

/// Updates applicationId and namespace in build.gradle.kts / build.gradle.
void _updateAndroidBuildGradle(String oldPkg, String newPkg) {
  // Supports both Kotlin DSL (build.gradle.kts) and Groovy DSL (build.gradle).
  // Both formats quote the value with double-quotes, so a simple string
  // replacement is safe.
  final ktsPath = 'android/app/build.gradle.kts';
  final groovyPath = 'android/app/build.gradle';
  final path = File(ktsPath).existsSync() ? ktsPath : groovyPath;

  _updateFile(path, (content) => content.replaceAll('"$oldPkg"', '"$newPkg"'));
}

/// Updates android:label in AndroidManifest.xml.
/// Note: modern Flutter projects use `namespace` in build.gradle instead of
/// a `package` attribute here, so only the label is changed.
void _updateAndroidManifest(String newDisplayName) {
  _updateFile('android/app/src/main/AndroidManifest.xml', (content) {
    // Replace any quoted value for android:label
    return content.replaceAllMapped(
      RegExp(r'android:label="[^"]*"'),
      (_) => 'android:label="$newDisplayName"',
    );
  });
}

/// Updates the package declaration in MainActivity.kt and moves the file to
/// a directory structure that matches the new package name.
void _updateMainActivityKt(String oldPkg, String newPkg) {
  const kotlinBase = 'android/app/src/main/kotlin';
  final kotlinDir = Directory(kotlinBase);

  if (!kotlinDir.existsSync()) {
    _results.add(
      const _FileResult(
        '$kotlinBase/**/MainActivity.kt',
        _Status.notFound,
        'kotlin directory not found — skipped',
      ),
    );
    return;
  }

  // Find MainActivity.kt anywhere under the kotlin directory
  File? oldFile;
  for (final entity in kotlinDir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('MainActivity.kt')) {
      oldFile = entity;
      break;
    }
  }

  if (oldFile == null) {
    _results.add(
      const _FileResult(
        '$kotlinBase/**/MainActivity.kt',
        _Status.notFound,
        'MainActivity.kt not found — skipped',
      ),
    );
    return;
  }

  // Build the new file path from the new package segments
  final newRelativePath = newPkg.replaceAll('.', '/');
  final newFilePath = '$kotlinBase/$newRelativePath/MainActivity.kt';
  final newFile = File(newFilePath);

  // Update the package declaration in the file content
  final original = oldFile.readAsStringSync();
  final updated = original.replaceAll(
    'package $oldPkg',
    'package $newPkg',
  );

  // Create the new directory structure and write the updated file
  newFile.parent.createSync(recursive: true);
  newFile.writeAsStringSync(updated);

  // Remove the old file if it moved to a new location
  if (oldFile.path != newFile.path) {
    oldFile.deleteSync();
    // Clean up any now-empty ancestor directories up to the kotlin root
    _deleteEmptyAncestors(oldFile.parent, kotlinDir);
    _results.add(_FileResult(
      oldFile.path,
      _Status.modified,
      'moved to $newFilePath',
    ));
  } else {
    _results.add(_FileResult(oldFile.path, _Status.modified));
  }
}

/// Deletes [dir] if empty, then walks up and does the same until [stopAt].
void _deleteEmptyAncestors(Directory dir, Directory stopAt) {
  try {
    if (dir.path == stopAt.path) return;
    if (dir.listSync().isEmpty) {
      dir.deleteSync();
      _deleteEmptyAncestors(dir.parent, stopAt);
    }
  } catch (_) {
    // Ignore any cleanup errors — they are non-critical
  }
}

// =============================================================================
// iOS updates
// =============================================================================

/// Updates CFBundleDisplayName and CFBundleName in Info.plist.
void _updateInfoPlist(String newDisplayName) {
  _updateFile('ios/Runner/Info.plist', (content) {
    var updated = content;
    // Replace CFBundleDisplayName value (handles literal strings or variables)
    updated = updated.replaceAllMapped(
      RegExp(r'(<key>CFBundleDisplayName</key>\s*<string>)[^<]*(</string>)'),
      (m) => '${m.group(1)}$newDisplayName${m.group(2)}',
    );
    // Replace CFBundleName value
    updated = updated.replaceAllMapped(
      RegExp(r'(<key>CFBundleName</key>\s*<string>)[^<]*(</string>)'),
      (m) => '${m.group(1)}$newDisplayName${m.group(2)}',
    );
    return updated;
  });
}

/// Updates PRODUCT_BUNDLE_IDENTIFIER in project.pbxproj.
/// Replaces all occurrences (Debug, Release, test targets) so sub-targets
/// like `com.old.app.RunnerTests` become `com.new.app.RunnerTests` correctly.
void _updatePbxproj(String oldBundleId, String newBundleId) {
  _updateFile('ios/Runner.xcodeproj/project.pbxproj', (content) {
    // Simple string replacement covers all configurations and targets
    return content.replaceAll(oldBundleId, newBundleId);
  });
}

// =============================================================================
// Flutter / Dart updates
// =============================================================================

/// Updates the `name:` field in pubspec.yaml.
void _updatePubspec(String oldDartPkg, String newDartPkg) {
  _updateFile('pubspec.yaml', (content) {
    return content.replaceAllMapped(
      RegExp(r'^(name:\s*)' + RegExp.escape(oldDartPkg), multiLine: true),
      (m) => '${m.group(1)}$newDartPkg',
    );
  });
}

/// Updates the appName string constant in app_constants.dart.
void _updateAppConstants(String newDisplayName) {
  _updateFile('lib/core/constants/app_constants.dart', (content) {
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
void _updateDartImports(String dirPath, String oldDartPkg, String newDartPkg) {
  final dir = Directory(dirPath);
  if (!dir.existsSync()) {
    _results.add(_FileResult(dirPath, _Status.notFound, 'directory not found — skipped'));
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

  _results.add(_FileResult(
    '$dirPath/**/*.dart',
    modifiedCount > 0 ? _Status.modified : _Status.noChangeNeeded,
    'scanned ${dartFiles.length} files, updated $modifiedCount',
  ));
}

// =============================================================================
// Docs updates
// =============================================================================

/// Replaces the old Dart package name in CLAUDE.md (e.g. import examples).
void _updateClaudeMd(String oldDartPkg, String newDartPkg) {
  _updateFile('CLAUDE.md', (content) => content.replaceAll(oldDartPkg, newDartPkg));
}

/// Replaces old package names in README.md if the file exists.
void _updateReadme(
  String oldDartPkg,
  String newDartPkg,
  String oldAndroidPkg,
  String newAndroidPkg,
) {
  if (!File('README.md').existsSync()) {
    _results.add(const _FileResult('README.md', _Status.notFound, 'not present — skipped'));
    return;
  }
  _updateFile('README.md', (content) {
    var updated = content.replaceAll(oldDartPkg, newDartPkg);
    updated = updated.replaceAll(oldAndroidPkg, newAndroidPkg);
    return updated;
  });
}

// =============================================================================
// Summary printing
// =============================================================================

void _printSummary() {
  final sep = '─' * 70;
  print('\n$sep');
  print('Setup complete — file summary');
  print(sep);

  final modified = _results.where((r) => r.status == _Status.modified).toList();
  final noChange = _results.where((r) => r.status == _Status.noChangeNeeded).toList();
  final notFound = _results.where((r) => r.status == _Status.notFound).toList();

  if (modified.isNotEmpty) {
    print('\n✅  Modified (${modified.length}):');
    for (final r in modified) {
      final detail = r.detail != null ? ' — ${r.detail}' : '';
      print('    ${r.path}$detail');
    }
  }

  if (noChange.isNotEmpty) {
    print('\n⏭   No change needed (${noChange.length}):');
    for (final r in noChange) {
      print('    ${r.path}');
    }
  }

  if (notFound.isNotEmpty) {
    print('\n⚠️   Not found / skipped (${notFound.length}):');
    for (final r in notFound) {
      final detail = r.detail != null ? ' — ${r.detail}' : '';
      print('    ${r.path}$detail');
    }
  }

  print('\n$sep');
  print('Next steps:');
  print('  flutter pub get');
  print('  Android: flutter clean && flutter pub get');
  print(sep);
}

// =============================================================================
// Entry point
// =============================================================================

void main() {
  // Verify we are running from the project root
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln('✗ pubspec.yaml not found.');
    stderr.writeln('  Run this script from the project root:');
    stderr.writeln('    dart setup/setup.dart');
    exit(1);
  }

  print('\n╔══════════════════════════════════════════╗');
  print('║   Flutter Template — App Rename Setup   ║');
  print('╚══════════════════════════════════════════╝\n');

  // ── Detect current values ────────────────────────────────────────────────

  final oldDartPkg = _detectOldDartPackage();
  if (oldDartPkg == null) {
    stderr.writeln('✗ Could not read package name from pubspec.yaml. Aborting.');
    exit(1);
  }

  final oldAndroidPkg = _detectOldAndroidPackage();
  if (oldAndroidPkg == null) {
    stderr.writeln('✗ Could not read applicationId from build.gradle. Aborting.');
    exit(1);
  }

  final oldBundleId = _detectOldBundleId();
  if (oldBundleId == null) {
    stderr.writeln('✗ Could not read PRODUCT_BUNDLE_IDENTIFIER from project.pbxproj. Aborting.');
    exit(1);
  }

  print('Detected values:');
  print('  Dart package   : $oldDartPkg');
  print('  Android pkg    : $oldAndroidPkg');
  print('  iOS bundle ID  : $oldBundleId');
  print('');

  // ── Collect new values ───────────────────────────────────────────────────

  final newDisplayName = _promptDisplayName();
  final newAndroidPkg = _promptPackageName();

  // Dart package name is derived from the last segment of the Android package.
  // e.g. com.example.justtap → justtap
  final newDartPkg = newAndroidPkg.split('.').last;

  // For iOS, use the same value as the new Android package name.
  final newBundleId = newAndroidPkg;

  // ── Confirm before making any changes ───────────────────────────────────

  final sep = '─' * 70;
  print('\n$sep');
  print('Changes to be applied:');
  print(sep);
  print('  App display name : $newDisplayName');
  print('  Android package  : $oldAndroidPkg  →  $newAndroidPkg');
  print('  iOS bundle ID    : $oldBundleId  →  $newBundleId');
  print('  Dart package     : $oldDartPkg  →  $newDartPkg');
  print('');
  print('  Files:');
  print('    android/app/build.gradle.kts          applicationId, namespace');
  print('    android/app/src/main/AndroidManifest.xml   android:label');
  print('    android/app/src/main/kotlin/**/MainActivity.kt  package + move');
  print('    ios/Runner/Info.plist                  CFBundleDisplayName, CFBundleName');
  print('    ios/Runner.xcodeproj/project.pbxproj  PRODUCT_BUNDLE_IDENTIFIER');
  print('    pubspec.yaml                           name:');
  print('    lib/core/constants/app_constants.dart  appName');
  print('    lib/**/*.dart                          package imports');
  print('    CLAUDE.md                              import examples');
  print('    README.md                              (if present)');
  print(sep);

  final confirm = _prompt('\nProceed? (y/n): ').toLowerCase();
  if (confirm != 'y') {
    print('\nAborted. No changes were made.');
    exit(0);
  }

  print('\nApplying changes…\n');

  // ── Apply all changes ────────────────────────────────────────────────────

  // Android
  _updateAndroidBuildGradle(oldAndroidPkg, newAndroidPkg);
  _updateAndroidManifest(newDisplayName);
  _updateMainActivityKt(oldAndroidPkg, newAndroidPkg);

  // iOS
  _updateInfoPlist(newDisplayName);
  _updatePbxproj(oldBundleId, newBundleId);

  // Flutter / Dart
  _updatePubspec(oldDartPkg, newDartPkg);
  _updateAppConstants(newDisplayName);
  _updateDartImports('lib', oldDartPkg, newDartPkg);

  // Docs
  _updateClaudeMd(oldDartPkg, newDartPkg);
  _updateReadme(oldDartPkg, newDartPkg, oldAndroidPkg, newAndroidPkg);

  // ── Print summary ────────────────────────────────────────────────────────
  _printSummary();
}
