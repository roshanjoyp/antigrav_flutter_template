/// Interactive prompts with validation for the setup script.
library;

// ignore_for_file: avoid_print

import 'dart:io';

import 'setup_io.dart';

/// Fully-qualified Android/iOS package name:
/// at least 3 dot-separated lowercase segments, each starting with a letter.
final packageNameRegex = RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*){2,}$');

/// Whether [input] is a valid package name (see [packageNameRegex]).
bool isValidPackageName(String input) => packageNameRegex.hasMatch(input);

/// Whether [input] is a valid display name (2–50 characters).
bool isValidDisplayName(String input) =>
    input.length >= 2 && input.length <= 50;

/// Whether [input] is a valid pubspec description (10–180 characters).
bool isValidDescription(String input) =>
    input.length >= 10 && input.length <= 180;

/// Repeatedly prompts until a valid package name is entered.
String promptPackageName() {
  while (true) {
    final input = prompt('Package name (e.g. com.example.myapp): ');
    if (packageNameRegex.hasMatch(input)) return input;
    stderr.writeln(
      '  ✗ Invalid. Must match ^[a-z][a-z0-9_]*([.][a-z][a-z0-9_]*){2,}\$\n'
      '    Example: com.example.myapp',
    );
  }
}

/// Repeatedly prompts until a display name of 2–50 characters is entered.
String promptDisplayName() {
  while (true) {
    final input = prompt('App display name (e.g. Just Tap): ');
    if (input.length >= 2 && input.length <= 50) return input;
    stderr.writeln(
      '  ✗ Display name must be 2–50 characters. '
      'Got ${input.length}.',
    );
  }
}

/// Repeatedly prompts until a pubspec description of 10–180 characters
/// is entered. Replaces the template's own description so stores,
/// tooling, and the readiness checklist see the buyer's app, not CRAFT.
String promptDescription() {
  while (true) {
    final input = prompt('One-line app description (for pubspec.yaml): ');
    if (input.length >= 10 && input.length <= 180) return input;
    stderr.writeln(
      '  ✗ Description must be 10–180 characters. Got ${input.length}.',
    );
  }
}
