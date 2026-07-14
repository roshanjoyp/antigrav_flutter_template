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
///
/// When the label is the `${appLabel}` flavor placeholder (the template's
/// default), it is left alone — the real value lives in build.gradle.kts
/// and is updated by [updateAndroidLabelBase].
void updateAndroidManifest(String newDisplayName) {
  updateFile('android/app/src/main/AndroidManifest.xml', (content) {
    return content.replaceAllMapped(RegExp(r'android:label="([^"]*)"'), (m) {
      if (m.group(1)!.startsWith(r'${')) return m.group(0)!;
      return 'android:label="$newDisplayName"';
    });
  });
}

/// Updates the `appLabelBase` value in build.gradle.kts — the base
/// launcher label that the dev/staging flavors suffix.
void updateAndroidLabelBase(String newDisplayName) {
  final ktsPath = 'android/app/build.gradle.kts';
  final groovyPath = 'android/app/build.gradle';
  final path = File(ktsPath).existsSync() ? ktsPath : groovyPath;

  updateFile(path, (content) {
    return content.replaceAllMapped(
      RegExp(r'val appLabelBase = "[^"]*"'),
      (_) => 'val appLabelBase = "$newDisplayName"',
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
///
/// A CFBundleDisplayName of `$(APP_DISPLAY_NAME)` (the template's flavor
/// setup) is left alone — the per-flavor values live in project.pbxproj
/// and are updated by [updatePbxprojDisplayName].
void updateInfoPlist(String newDisplayName) {
  updateFile('ios/Runner/Info.plist', (content) {
    var updated = content;
    // Replace CFBundleDisplayName value unless it is a build-setting
    // variable reference.
    updated = updated.replaceAllMapped(
      RegExp(r'(<key>CFBundleDisplayName</key>\s*<string>)([^<]*)(</string>)'),
      (m) => m.group(2)!.startsWith(r'$(')
          ? m.group(0)!
          : '${m.group(1)}$newDisplayName${m.group(3)}',
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
/// Flavor-suffixed ids (`com.old.app.dev`) rename the same way.
void updatePbxproj(String oldBundleId, String newBundleId) {
  updateFile('ios/Runner.xcodeproj/project.pbxproj', (content) {
    // Simple string replacement covers all configurations and targets
    return content.replaceAll(oldBundleId, newBundleId);
  });
}

/// Updates every `APP_DISPLAY_NAME` build setting in project.pbxproj,
/// preserving the flavor suffix (` Dev` / ` Staging`) each configuration
/// appends to the base name.
void updatePbxprojDisplayName(String newDisplayName) {
  const flavorSuffixes = [' Dev', ' Staging'];
  updateFile('ios/Runner.xcodeproj/project.pbxproj', (content) {
    return content.replaceAllMapped(RegExp(r'APP_DISPLAY_NAME = "([^"]*)";'), (
      m,
    ) {
      var suffix = '';
      for (final candidate in flavorSuffixes) {
        if (m.group(1)!.endsWith(candidate)) {
          suffix = candidate;
          break;
        }
      }
      return 'APP_DISPLAY_NAME = "$newDisplayName$suffix";';
    });
  });
}
