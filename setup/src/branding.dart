/// Optional post-rename icon/splash regeneration.
library;

// ignore_for_file: avoid_print

import 'dart:io';

import 'setup_io.dart';

/// Offers to regenerate launcher icons and the native splash from
/// `assets/branding/` (icon.png, splash.png).
///
/// Skipped unless the developer confirms — regenerating before the
/// placeholder images are replaced would just re-stamp the CRAFT mark.
/// Runs `flutter pub get` first so the generator packages resolve.
void offerBrandingRegeneration() {
  print('');
  print('Branding: replace assets/branding/icon.png (1024×1024) and');
  print('splash.png (transparent logo), then icons + splash regenerate');
  print('for every platform in one step.');
  final answer = prompt(
    'Regenerate launcher icons + splash now? (y/N): ',
  ).toLowerCase();
  if (answer != 'y') {
    print('  Skipped. Run later with:');
    print('    dart run flutter_launcher_icons');
    print(
      '    dart run flutter_native_splash:create '
      '--path=flutter_native_splash.yaml',
    );
    return;
  }

  _runStep('flutter', ['pub', 'get']);
  _runStep('dart', ['run', 'flutter_launcher_icons']);
  _runStep('dart', [
    'run',
    'flutter_native_splash:create',
    '--path=flutter_native_splash.yaml',
  ]);
}

/// Runs one tool synchronously, echoing a ✓/✗ line with its outcome.
void _runStep(String executable, List<String> args) {
  final String label = '$executable ${args.join(' ')}';
  print('  → $label');
  final ProcessResult result = Process.runSync(executable, args);
  if (result.exitCode == 0) {
    print('    ✓ done');
  } else {
    print('    ✗ failed (exit ${result.exitCode})');
    final String stderrText = result.stderr.toString().trim();
    if (stderrText.isNotEmpty) {
      print('      ${stderrText.split('\n').first}');
    }
  }
}
