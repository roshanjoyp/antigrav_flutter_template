/// Command-line options for non-interactive setup runs.
///
/// The generator (and scripted buyers) call the rename with flags; any
/// value not supplied by a flag falls back to the interactive prompt,
/// so `dart setup/setup.dart` with no arguments behaves as before.
library;

// ignore_for_file: avoid_print

import 'dart:io';

import 'prompts.dart';

/// Parsed setup flags; `null` fields fall back to interactive prompts.
class SetupOptions {
  /// Creates parsed options.
  const SetupOptions({
    this.displayName,
    this.package,
    this.description,
    this.yes = false,
    this.noBranding = false,
  });

  /// `--display-name` — app display name (2–50 chars).
  final String? displayName;

  /// `--package` — fully-qualified package/bundle id.
  final String? package;

  /// `--description` — one-line pubspec description (10–180 chars).
  final String? description;

  /// `--yes` — skip the proceed confirmation.
  final bool yes;

  /// `--no-branding` — skip the icon/splash regeneration offer.
  final bool noBranding;

  /// Parses [args], exiting with code 64 and usage on any invalid input.
  static SetupOptions parse(List<String> args) {
    String? displayName;
    String? package;
    String? description;
    bool yes = false;
    bool noBranding = false;

    String value(int i, String flag) {
      if (i + 1 >= args.length) _usageExit('$flag needs a value');
      return args[i + 1];
    }

    for (int i = 0; i < args.length; i++) {
      final String arg = args[i];
      final int eq = arg.indexOf('=');
      final String flag = eq == -1 ? arg : arg.substring(0, eq);
      String inline() => eq == -1 ? value(i++, flag) : arg.substring(eq + 1);
      switch (flag) {
        case '--display-name':
          displayName = inline();
        case '--package':
          package = inline();
        case '--description':
          description = inline();
        case '--yes':
          yes = true;
        case '--no-branding':
          noBranding = true;
        case '--help' || '-h':
          _usageExit(null, code: 0);
        default:
          _usageExit('unknown flag: $flag');
      }
    }

    if (displayName != null && !isValidDisplayName(displayName)) {
      _usageExit('--display-name must be 2–50 characters');
    }
    if (package != null && !isValidPackageName(package)) {
      _usageExit('--package must match e.g. com.example.myapp');
    }
    if (description != null && !isValidDescription(description)) {
      _usageExit('--description must be 10–180 characters');
    }

    return SetupOptions(
      displayName: displayName,
      package: package,
      description: description,
      yes: yes,
      noBranding: noBranding,
    );
  }

  static Never _usageExit(String? error, {int code = 64}) {
    if (error != null) stderr.writeln('✗ $error\n');
    print(
      'Usage: dart setup/setup.dart '
      '[--display-name NAME] [--package COM.EXAMPLE.APP]\n'
      '       [--description TEXT] [--yes] [--no-branding]\n\n'
      'Flags replace their interactive prompts; omitted values are\n'
      'prompted for. --yes skips the confirmation, --no-branding skips\n'
      'the icon/splash regeneration offer.',
    );
    exit(code);
  }
}
