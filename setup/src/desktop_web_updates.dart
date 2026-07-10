/// Web, Linux, Windows, and macOS rename updates.
///
/// Convention: binary/product names follow the Dart package name;
/// user-facing strings (window titles, product descriptions, PWA names)
/// follow the display name.
library;

import 'setup_io.dart';

/// Updates the web target: page title, PWA titles/names, descriptions.
void updateWeb(String newDisplayName, String newDescription) {
  updateFile('web/index.html', (content) {
    var updated = content.replaceAllMapped(
      RegExp(r'<title>[^<]*</title>'),
      (_) => '<title>$newDisplayName</title>',
    );
    updated = updated.replaceAllMapped(
      RegExp(r'(<meta name="apple-mobile-web-app-title" content=")[^"]*(">)'),
      (m) => '${m.group(1)}$newDisplayName${m.group(2)}',
    );
    return updated.replaceAllMapped(
      RegExp(r'(<meta name="description" content=")[^"]*(">)'),
      (m) => '${m.group(1)}$newDescription${m.group(2)}',
    );
  });

  updateFile('web/manifest.json', (content) {
    var updated = content.replaceAllMapped(
      RegExp(r'("name":\s*")[^"]*(")'),
      (m) => '${m.group(1)}$newDisplayName${m.group(2)}',
    );
    updated = updated.replaceAllMapped(
      RegExp(r'("short_name":\s*")[^"]*(")'),
      (m) => '${m.group(1)}$newDisplayName${m.group(2)}',
    );
    return updated.replaceAllMapped(
      RegExp(r'("description":\s*")[^"]*(")'),
      (m) => '${m.group(1)}$newDescription${m.group(2)}',
    );
  });
}

/// Updates the Linux target: binary name, application id, window titles.
void updateLinux(String newDartPkg, String newBundleId, String newDisplayName) {
  updateFile('linux/CMakeLists.txt', (content) {
    final updated = content.replaceAllMapped(
      RegExp(r'set\(BINARY_NAME "[^"]*"\)'),
      (_) => 'set(BINARY_NAME "$newDartPkg")',
    );
    return updated.replaceAllMapped(
      RegExp(r'set\(APPLICATION_ID "[^"]*"\)'),
      (_) => 'set(APPLICATION_ID "$newBundleId")',
    );
  });

  updateFile('linux/runner/my_application.cc', (content) {
    return content.replaceAllMapped(
      RegExp(
        r'(gtk_(?:header_bar_set_title|window_set_title)\([^,]+,\s*")'
        r'[^"]*(")',
      ),
      (m) => '${m.group(1)}$newDisplayName${m.group(2)}',
    );
  });
}

/// Updates the Windows target: project/binary names, the window title
/// in main.cpp, and version-info strings in Runner.rc.
void updateWindows(
  String oldDartPkg,
  String newDartPkg,
  String newBundleId,
  String displayName,
) {
  // Publisher/org string: the bundle id minus its app segment
  // (com.example.justtap → com.example).
  final org = newBundleId.split('.').length > 2
      ? newBundleId.substring(0, newBundleId.lastIndexOf('.'))
      : newBundleId;

  updateFile('windows/CMakeLists.txt', (content) {
    final updated = content.replaceFirst(
      RegExp(r'project\([^\s)]+'),
      'project($newDartPkg',
    );
    return updated.replaceAllMapped(
      RegExp(r'set\(BINARY_NAME "[^"]*"\)'),
      (_) => 'set(BINARY_NAME "$newDartPkg")',
    );
  });

  updateFile('windows/runner/main.cpp', (content) {
    return content.replaceAllMapped(
      RegExp(r'(window\.Create\(L")[^"]*(")'),
      (m) => '${m.group(1)}$displayName${m.group(2)}',
    );
  });

  String rcValue(String content, String key, String value) {
    return content.replaceAllMapped(
      RegExp('(VALUE "$key", ")[^"]*(" "\\\\0")'),
      (m) => '${m.group(1)}$value${m.group(2)}',
    );
  }

  updateFile('windows/runner/Runner.rc', (content) {
    var updated = rcValue(content, 'FileDescription', displayName);
    updated = rcValue(updated, 'ProductName', displayName);
    updated = rcValue(updated, 'InternalName', newDartPkg);
    updated = rcValue(updated, 'OriginalFilename', '$newDartPkg.exe');
    updated = rcValue(updated, 'CompanyName', org);
    return rcValue(
      updated,
      'LegalCopyright',
      'Copyright (C) ${DateTime.now().year} $org. '
          'All rights reserved.',
    );
  });
}

/// Updates the macOS target: product name, bundle id, copyright, and
/// the pbxproj's literal product references (incl. TEST_HOST paths).
void updateMacos(
  String oldDartPkg,
  String newDartPkg,
  String? oldMacosBundleId,
  String newBundleId,
  String newDisplayName,
) {
  updateFile('macos/Runner/Configs/AppInfo.xcconfig', (content) {
    var updated = content.replaceAllMapped(
      RegExp(r'^(PRODUCT_NAME\s*=\s*).*$', multiLine: true),
      (m) => '${m.group(1)}$newDartPkg',
    );
    updated = updated.replaceAllMapped(
      RegExp(r'^(PRODUCT_BUNDLE_IDENTIFIER\s*=\s*).*$', multiLine: true),
      (m) => '${m.group(1)}$newBundleId',
    );
    return updated.replaceAllMapped(
      RegExp(r'^(PRODUCT_COPYRIGHT\s*=\s*).*$', multiLine: true),
      (m) =>
          '${m.group(1)}Copyright © ${DateTime.now().year} '
          '$newDisplayName. All rights reserved.',
    );
  });

  updateFile('macos/Runner.xcodeproj/project.pbxproj', (content) {
    var updated = content.replaceAll(oldDartPkg, newDartPkg);
    if (oldMacosBundleId != null) {
      updated = updated.replaceAll(oldMacosBundleId, newBundleId);
    }
    return updated;
  });

  // The shared scheme references the .app by literal name.
  updateFile(
    'macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme',
    (content) => content.replaceAll('$oldDartPkg.app', '$newDartPkg.app'),
  );
}
