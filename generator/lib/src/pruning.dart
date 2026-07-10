/// pubspec.yaml dependency and checklist.yaml item pruning.
library;

/// Removes single-line dependency entries named in [deps] from
/// [pubspecSource]. Every name must be found — a miss means the
/// registry and pubspec drifted, which is a generation error.
String prunePubspecDeps(String pubspecSource, Iterable<String> deps) {
  var out = pubspecSource;
  for (final dep in deps) {
    final regex = RegExp('^  $dep:.*\\n', multiLine: true);
    if (!regex.hasMatch(out)) {
      throw StateError('pubspec.yaml has no dependency line for "$dep"');
    }
    out = out.replaceFirst(regex, '');
  }
  return out;
}

/// Removes checklist item blocks whose id starts with any of
/// [prefixes]. A block is the 2-space-indented `  <id>:` line plus its
/// deeper-indented continuation lines.
String pruneChecklistItems(String checklistSource, Iterable<String> prefixes) {
  final lines = checklistSource.split('\n');
  final out = <String>[];
  var skipping = false;
  for (final line in lines) {
    final idMatch = RegExp(r'^  ([A-Za-z0-9_.-]+):\s*$').firstMatch(line);
    if (idMatch != null) {
      final id = idMatch.group(1)!;
      skipping = prefixes.any(id.startsWith);
      if (skipping) continue;
    } else if (skipping) {
      // Continuation lines are indented deeper than the item line.
      if (line.startsWith('    ')) continue;
      skipping = false;
    }
    out.add(line);
  }
  return out.join('\n');
}
