/// CLI entry point:
///   dart run craft_generator:generate --config c.json --out app.zip
///       [--template-root DIR] [--gate none|analyze|test] [--keep-staging]
library;

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:craft_generator/craft_generator.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) {
  String? configPath;
  String? outPath;
  String? templateRoot;
  var gate = GateLevel.analyze;
  var keepStaging = false;

  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--config':
        configPath = args[++i];
      case '--out':
        outPath = args[++i];
      case '--template-root':
        templateRoot = args[++i];
      case '--gate':
        gate = GateLevel.values.byName(args[++i]);
      case '--keep-staging':
        keepStaging = true;
      default:
        stderr.writeln('unknown flag: ${args[i]}');
        exit(64);
    }
  }
  if (configPath == null || outPath == null) {
    stderr.writeln(
      'Usage: dart run craft_generator:generate --config c.json '
      '--out app.zip [--template-root DIR] [--gate none|analyze|test] '
      '[--keep-staging]',
    );
    exit(64);
  }

  // Default template root: the current directory if it is the template
  // repo, else its parent (covers running from inside generator/).
  final root = Directory(templateRoot ?? _guessTemplateRoot());
  if (!File(p.join(root.path, 'setup', 'setup.dart')).existsSync()) {
    stderr.writeln(
      '✗ ${root.path} is not the template root (no setup/setup.dart); '
      'pass --template-root',
    );
    exit(2);
  }

  final GeneratorConfig config;
  try {
    config = GeneratorConfig.fromJsonString(
      File(configPath).readAsStringSync(),
    );
  } on ConfigException catch (e) {
    stderr.writeln('✗ ${e.message}');
    exit(64);
  }

  final result = generate(
    config,
    templateRoot: root,
    outPath: outPath,
    gate: gate,
    keepStaging: keepStaging,
  );
  result.log.forEach(print);
  if (!result.ok && result.stagingPath != null) {
    print('  staging kept for inspection: ${result.stagingPath}');
  }
  exit(result.ok ? 0 : 1);
}

/// The template root: cwd when it holds setup/setup.dart, else parent.
String _guessTemplateRoot() {
  final cwd = Directory.current.path;
  if (File(p.join(cwd, 'setup', 'setup.dart')).existsSync()) return cwd;
  return p.dirname(cwd);
}
