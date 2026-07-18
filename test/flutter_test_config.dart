import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Global test bootstrap — Flutter discovers this file by name and runs
/// [testExecutable] around every test in the package.
///
/// Loads the real Roboto and MaterialIcons fonts from the Flutter SDK's
/// font cache, so widget and golden tests render actual glyphs instead
/// of the deterministic FlutterTest block font.
///
/// Trade-off (chosen deliberately): real-font goldens are only
/// guaranteed pixel-stable on the platform that generated them, because
/// text rasterization can differ subtly between OSes. Goldens in this
/// repo are generated on macOS — after intentional visual changes,
/// regenerate with `flutter test --update-goldens test/goldens`.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadSdkFonts();
  await testMain();
}

/// Fonts bundled with the Flutter SDK, family name → font files.
///
/// Roboto is the Material default text family in tests; MaterialIcons
/// backs every `Icons.*` glyph. The weights cover the Material text
/// theme (w400/w500/w700) plus italics.
const Map<String, List<String>> _sdkFonts = {
  'Roboto': [
    'Roboto-Regular.ttf',
    'Roboto-Italic.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Bold.ttf',
  ],
  // Known limitation: component-theme TextStyles with a null
  // fontFamily (e.g. the dark AppBarTheme/DialogThemeData titles)
  // bypass the inheriting text theme and still render the block font.
  // The engine's built-in default wins for null families — loading
  // Roboto under the 'FlutterTest' family does not override it.
  'MaterialIcons': ['MaterialIcons-Regular.otf'],
};

/// Loads [_sdkFonts] from the SDK's `material_fonts` artifact cache.
///
/// Throws a [StateError] when the cache cannot be located rather than
/// silently falling back to the block font — a quiet fallback would
/// make every golden comparison fail with a confusing full-page diff.
Future<void> _loadSdkFonts() async {
  final String? root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) {
    throw StateError(
      'FLUTTER_ROOT is not set; cannot load SDK fonts for tests. '
      'Run tests via `flutter test`.',
    );
  }
  final Directory cache = Directory(
    '$root/bin/cache/artifacts/material_fonts',
  );
  if (!cache.existsSync()) {
    throw StateError(
      '${cache.path} is missing; run `flutter precache` to download the '
      'material fonts, or regenerate goldens without real fonts.',
    );
  }
  for (final MapEntry<String, List<String>> family in _sdkFonts.entries) {
    final FontLoader loader = FontLoader(family.key);
    for (final String file in family.value) {
      final Uint8List bytes = File(
        '${cache.path}/$file',
      ).readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }
}
