/// Detection helpers — read current values from existing project files.
library;

import 'dart:io';

/// Reads the current Dart package name from pubspec.yaml `name:` field.
String? detectOldDartPackage() {
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
String? detectOldAndroidPackage() {
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
String? detectOldBundleId() {
  final file = File('ios/Runner.xcodeproj/project.pbxproj');
  if (!file.existsSync()) return null;
  final match = RegExp(
    r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([^;]+);',
  ).firstMatch(file.readAsStringSync());
  return match?.group(1)?.trim();
}

/// Reads the current macOS PRODUCT_BUNDLE_IDENTIFIER from
/// AppInfo.xcconfig (macOS keeps its own, often camelCased, id).
String? detectOldMacosBundleId() {
  final file = File('macos/Runner/Configs/AppInfo.xcconfig');
  if (!file.existsSync()) return null;
  final match = RegExp(
    r'^PRODUCT_BUNDLE_IDENTIFIER\s*=\s*(\S+)',
    multiLine: true,
  ).firstMatch(file.readAsStringSync());
  return match?.group(1);
}
