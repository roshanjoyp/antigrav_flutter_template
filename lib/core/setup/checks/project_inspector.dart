/// File-parsing helpers the doctor's static checks share.
///
/// Everything here reads project files under a given root and returns
/// plain values; no printing, no exit codes. Uses `dart:io`, so it is
/// CLI-only tooling code — never import it from app code.
library;

import 'dart:io';

/// The Dart package name the template ships with, before `setup/setup.dart`
/// renames the project.
const String templateDartPackage = 'craft_flutter_template';

/// The Android/iOS application id the template ships with.
const String templateApplicationId = 'com.craft.craft_flutter_template';

/// Reads a file under [root], returning `null` when it does not exist.
String? readProjectFile(Directory root, String relativePath) {
  final File file = File('${root.path}/$relativePath');
  return file.existsSync() ? file.readAsStringSync() : null;
}

/// Whether the file at [relativePath] exists and contains [marker].
///
/// Returns `null` when the file is missing (distinct from "marker absent"
/// so callers can report a missing file precisely).
bool? fileContainsMarker(Directory root, String relativePath, String marker) {
  return readProjectFile(root, relativePath)?.contains(marker);
}

/// The `name:` field of pubspec.yaml, or `null` if unreadable.
String? pubspecName(Directory root) {
  final String? pubspec = readProjectFile(root, 'pubspec.yaml');
  if (pubspec == null) return null;
  return RegExp(
    r'^name:\s*(\S+)',
    multiLine: true,
  ).firstMatch(pubspec)?.group(1);
}

/// The `applicationId` from android/app/build.gradle.kts, or `null`.
String? androidApplicationId(Directory root) {
  final String? gradle =
      readProjectFile(root, 'android/app/build.gradle.kts') ??
      readProjectFile(root, 'android/app/build.gradle');
  if (gradle == null) return null;
  return RegExp(r'applicationId\s*=?\s*"([^"]+)"').firstMatch(gradle)?.group(1);
}

/// All distinct `PRODUCT_BUNDLE_IDENTIFIER` values in the iOS project,
/// excluding the test target's (which is derived from the app's).
Set<String> iosBundleIds(Directory root) {
  final String? pbxproj = readProjectFile(
    root,
    'ios/Runner.xcodeproj/project.pbxproj',
  );
  if (pbxproj == null) return <String>{};
  return RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([^;\s]+);')
      .allMatches(pbxproj)
      .map((RegExpMatch match) => match.group(1)!)
      .where((String id) => !id.endsWith('.RunnerTests'))
      .toSet();
}

/// Parses a `static const bool enabled = …;` flag out of a config file.
///
/// Returns `null` when the file is missing or the flag can't be found —
/// callers should treat that as a check failure, not as disabled.
bool? configEnabledFlag(Directory root, String relativePath) {
  final String? content = readProjectFile(root, relativePath);
  if (content == null) return null;
  final String? value = RegExp(
    r'static\s+const\s+bool\s+enabled\s*=\s*(true|false)\s*;',
  ).firstMatch(content)?.group(1);
  return value == null ? null : value == 'true';
}

/// Every Dart file under [root]/lib that declares a `part '….g.dart';`
/// or `part '….freezed.dart';`, mapped to its declared part paths
/// (relative to the declaring file's directory).
Map<File, List<String>> generatedPartDeclarations(Directory root) {
  final RegExp partRegex = RegExp(
    '''part\\s+['"]([^'"]+\\.(?:g|freezed)\\.dart)['"];''',
  );
  final Map<File, List<String>> declarations = <File, List<String>>{};
  final Directory lib = Directory('${root.path}/lib');
  if (!lib.existsSync()) return declarations;
  for (final FileSystemEntity entity in lib.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (entity.path.endsWith('.g.dart') ||
        entity.path.endsWith('.freezed.dart')) {
      continue;
    }
    final List<String> parts = partRegex
        .allMatches(entity.readAsStringSync())
        .map((RegExpMatch match) => match.group(1)!)
        .toList();
    if (parts.isNotEmpty) declarations[entity] = parts;
  }
  return declarations;
}
