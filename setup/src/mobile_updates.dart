/// Android and iOS rename updates.
library;

import 'dart:io';

import 'setup_io.dart';

/// Updates applicationId and namespace in build.gradle.kts / build.gradle.
void updateAndroidBuildGradle(String oldPkg, String newPkg) {
  // Supports both Kotlin DSL (build.gradle.kts) and Groovy DSL (build.gradle).
  // Both formats quote the value with double-quotes, so a simple string
  // replacement is safe.
  final ktsPath = 'android/app/build.gradle.kts';
  final groovyPath = 'android/app/build.gradle';
  final path = File(ktsPath).existsSync() ? ktsPath : groovyPath;

  updateFile(path, (content) => content.replaceAll('"$oldPkg"', '"$newPkg"'));
}

/// Updates android:label in AndroidManifest.xml.
/// Note: modern Flutter projects use `namespace` in build.gradle instead of
/// a `package` attribute here, so only the label is changed.
void updateAndroidManifest(String newDisplayName) {
  updateFile('android/app/src/main/AndroidManifest.xml', (content) {
    // Replace any quoted value for android:label
    return content.replaceAllMapped(
      RegExp(r'android:label="[^"]*"'),
      (_) => 'android:label="$newDisplayName"',
    );
  });
}

/// Updates the package declaration in MainActivity.kt and moves the file to
/// a directory structure that matches the new package name.
void updateMainActivityKt(String oldPkg, String newPkg) {
  const kotlinBase = 'android/app/src/main/kotlin';
  final kotlinDir = Directory(kotlinBase);

  if (!kotlinDir.existsSync()) {
    results.add(
      const FileResult(
        '$kotlinBase/**/MainActivity.kt',
        FileStatus.notFound,
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
    results.add(
      const FileResult(
        '$kotlinBase/**/MainActivity.kt',
        FileStatus.notFound,
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
  final updated = original.replaceAll('package $oldPkg', 'package $newPkg');

  // Create the new directory structure and write the updated file
  newFile.parent.createSync(recursive: true);
  newFile.writeAsStringSync(updated);

  // Remove the old file if it moved to a new location
  if (oldFile.path != newFile.path) {
    oldFile.deleteSync();
    // Clean up any now-empty ancestor directories up to the kotlin root
    deleteEmptyAncestors(oldFile.parent, kotlinDir);
    results.add(
      FileResult(oldFile.path, FileStatus.modified, 'moved to $newFilePath'),
    );
  } else {
    results.add(FileResult(oldFile.path, FileStatus.modified));
  }
}

/// Updates CFBundleDisplayName and CFBundleName in Info.plist.
void updateInfoPlist(String newDisplayName) {
  updateFile('ios/Runner/Info.plist', (content) {
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
void updatePbxproj(String oldBundleId, String newBundleId) {
  updateFile('ios/Runner.xcodeproj/project.pbxproj', (content) {
    // Simple string replacement covers all configurations and targets
    return content.replaceAll(oldBundleId, newBundleId);
  });
}
