/// Flutter template setup script
///
/// Renames the app name and package name throughout the entire project:
/// Android, iOS, web, Linux, Windows, macOS, Dart sources, and docs.
///
/// Usage:
///   dart setup/setup.dart
///
/// See README.md for full setup instructions
/// before running this script.
library;

// ignore_for_file: avoid_print

import 'dart:io';

import 'src/branding.dart';
import 'src/cli_options.dart';
import 'src/dart_updates.dart';
import 'src/desktop_web_updates.dart';
import 'src/detect.dart';
import 'src/mobile_updates.dart';
import 'src/prompts.dart';
import 'src/setup_io.dart';

void main(List<String> args) {
  final SetupOptions options = SetupOptions.parse(args);
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

  final oldDartPkg = detectOldDartPackage();
  if (oldDartPkg == null) {
    stderr.writeln(
      '✗ Could not read package name from pubspec.yaml. Aborting.',
    );
    exit(1);
  }
  final oldAndroidPkg = detectOldAndroidPackage();
  if (oldAndroidPkg == null) {
    stderr.writeln('✗ Could not read Android applicationId. Aborting.');
    exit(1);
  }
  final oldBundleId = detectOldBundleId();
  if (oldBundleId == null) {
    stderr.writeln('✗ Could not read iOS bundle identifier. Aborting.');
    exit(1);
  }
  final oldMacosBundleId = detectOldMacosBundleId();

  print('Detected values:');
  print('  Dart package   : $oldDartPkg');
  print('  Android pkg    : $oldAndroidPkg');
  print('  iOS bundle ID  : $oldBundleId');
  print('  macOS bundle ID: ${oldMacosBundleId ?? '(not found)'}');
  print('');

  // ── Collect new values ───────────────────────────────────────────────────

  final newDisplayName = options.displayName ?? promptDisplayName();
  final newDescription = options.description ?? promptDescription();
  final newAndroidPkg = options.package ?? promptPackageName();

  // Dart package name is derived from the last segment of the Android package.
  // e.g. com.example.justtap → justtap
  final newDartPkg = newAndroidPkg.split('.').last;

  // iOS, macOS, and Linux application ids all use the new Android package.
  final newBundleId = newAndroidPkg;

  // ── Confirm before making any changes ───────────────────────────────────

  final sep = '─' * 70;
  print('\n$sep');
  print('Changes to be applied:');
  print(sep);
  print('  App display name : $newDisplayName');
  print('  App description  : $newDescription');
  print('  Android package  : $oldAndroidPkg  →  $newAndroidPkg');
  print('  iOS bundle ID    : $oldBundleId  →  $newBundleId');
  print('  Dart package     : $oldDartPkg  →  $newDartPkg');
  print('');
  print('  Files:');
  print('    android/app/build.gradle.kts          applicationId, namespace');
  print('    android/app/src/main/AndroidManifest.xml   android:label');
  print('    android/app/src/main/kotlin/**/MainActivity.kt  package + move');
  print(
    '    ios/Runner/Info.plist                  CFBundleDisplayName, CFBundleName',
  );
  print('    ios/Runner.xcodeproj/project.pbxproj  PRODUCT_BUNDLE_IDENTIFIER');
  print('    web/index.html, web/manifest.json      titles, descriptions');
  print('    linux/** windows/** macos/**           binary names, ids, titles');
  print('    pubspec.yaml                           name:, description:');
  print('    lib/core/constants/app_constants.dart  appName');
  print('    lib/ test/ tool/ **/*.dart             package imports');
  print('    CLAUDE.md                              import examples');
  print('    README.md                              (if present)');
  print(sep);

  if (!options.yes) {
    final confirm = prompt('\nProceed? (y/n): ').toLowerCase();
    if (confirm != 'y') {
      print('\nAborted. No changes were made.');
      exit(0);
    }
  }

  print('\nApplying changes…\n');

  // ── Apply all changes ────────────────────────────────────────────────────

  // Android
  updateAndroidBuildGradle(oldAndroidPkg, newAndroidPkg);
  updateAndroidManifest(newDisplayName);
  updateAndroidLabelBase(newDisplayName);
  updateMainActivityKt(oldAndroidPkg, newAndroidPkg);

  // iOS
  updateInfoPlist(newDisplayName);
  updatePbxproj(oldBundleId, newBundleId);
  updatePbxprojDisplayName(newDisplayName);

  // Web + desktop
  updateWeb(newDisplayName, newDescription);
  updateLinux(newDartPkg, newBundleId, newDisplayName);
  updateWindows(oldDartPkg, newDartPkg, newBundleId, newDisplayName);
  updateMacos(
    oldDartPkg,
    newDartPkg,
    oldMacosBundleId,
    newBundleId,
    newDisplayName,
  );

  // Flutter / Dart
  updatePubspec(oldDartPkg, newDartPkg);
  updatePubspecDescription(newDescription);
  updateAppConstants(newDisplayName);
  updateDartImports('lib', oldDartPkg, newDartPkg);
  updateDartImports('test', oldDartPkg, newDartPkg);
  updateDartImports('tool', oldDartPkg, newDartPkg);

  // Docs
  updateClaudeMd(oldDartPkg, newDartPkg);
  updateReadme(oldDartPkg, newDartPkg, oldAndroidPkg, newAndroidPkg);

  // ── Print summary ────────────────────────────────────────────────────────
  printSummary();

  // ── Optional: regenerate icons + splash from assets/branding ────────────
  if (!options.noBranding) offerBrandingRegeneration();
}
