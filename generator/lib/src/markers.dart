/// The `MODULE(<id>)` marker engine: scanning and stripping.
///
/// Marker forms (comment leader `//` for Dart, `#` for YAML-likes):
/// - region: standalone `// MODULE(<id>): begin` … `// MODULE(<id>): end`
/// - single line: a code line suffixed with `// MODULE(<id>)`
///
/// Semantics are pure removal: excluded modules lose their regions and
/// marked lines entirely; included modules keep the code with all
/// marker text stripped, so generated output never contains markers.
library;

final _beginRegex = RegExp(r'^\s*(?://|#)\s*MODULE\(([a-z_]+)\): begin\s*$');
final _endRegex = RegExp(r'^\s*(?://|#)\s*MODULE\(([a-z_]+)\): end\s*$');
final _suffixRegex = RegExp(r'\s*(?://|#)\s*MODULE\(([a-z_]+)\)\s*$');

/// One marker occurrence found by [scanMarkers].
class MarkerSite {
  /// Creates a marker site record.
  const MarkerSite(this.line, this.id, this.kind);

  /// 1-based line number.
  final int line;

  /// The module id inside the marker.
  final String id;

  /// `begin`, `end`, or `line`.
  final String kind;
}

/// A structural problem with a file's markers.
class MarkerError {
  /// Creates a marker error.
  const MarkerError(this.line, this.message);

  /// 1-based line number (0 for file-level problems).
  final int line;

  /// What is wrong.
  final String message;

  @override
  String toString() => 'line $line: $message';
}

/// Scans [source] and returns every marker site plus structural errors
/// (unknown ids per [knownIds], unbalanced or same-module-nested
/// regions, `end` without `begin`).
(List<MarkerSite>, List<MarkerError>) scanMarkers(
  String source, {
  required Set<String> knownIds,
}) {
  final sites = <MarkerSite>[];
  final errors = <MarkerError>[];
  final open = <String>[];
  final lines = source.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final n = i + 1;
    final begin = _beginRegex.firstMatch(line);
    final end = _endRegex.firstMatch(line);
    final suffix = begin == null && end == null
        ? _suffixRegex.firstMatch(line)
        : null;
    final String? id = (begin ?? end ?? suffix)?.group(1);
    if (id == null) continue;
    if (!knownIds.contains(id)) {
      errors.add(MarkerError(n, 'unknown module id "$id"'));
      continue;
    }
    if (begin != null) {
      if (open.contains(id)) {
        errors.add(MarkerError(n, 'MODULE($id) region nested in itself'));
      }
      open.add(id);
      sites.add(MarkerSite(n, id, 'begin'));
    } else if (end != null) {
      if (open.isEmpty || open.last != id) {
        errors.add(MarkerError(n, 'MODULE($id): end without matching begin'));
      } else {
        open.removeLast();
      }
      sites.add(MarkerSite(n, id, 'end'));
    } else {
      sites.add(MarkerSite(n, id, 'line'));
    }
  }
  for (final id in open) {
    errors.add(MarkerError(0, 'MODULE($id): begin without end'));
  }
  return (sites, errors);
}

/// Applies marker semantics to [source]: removes regions and marked
/// lines of [excluded] modules, strips remaining marker text.
///
/// [source] must be structurally valid per [scanMarkers]; behavior on
/// invalid input is unspecified (the pipeline validates first).
String stripMarkers(String source, {required Set<String> excluded}) {
  final out = <String>[];
  final lines = source.split('\n');
  var skipDepth = 0;
  final open = <String>[];
  for (final line in lines) {
    final begin = _beginRegex.firstMatch(line);
    final end = _endRegex.firstMatch(line);
    if (begin != null) {
      open.add(begin.group(1)!);
      if (skipDepth > 0 || excluded.contains(begin.group(1))) skipDepth++;
      continue; // marker lines never reach the output
    }
    if (end != null) {
      if (open.isNotEmpty) open.removeLast();
      if (skipDepth > 0) skipDepth--;
      continue;
    }
    if (skipDepth > 0) continue;
    final suffix = _suffixRegex.firstMatch(line);
    if (suffix != null) {
      if (excluded.contains(suffix.group(1))) continue;
      out.add(line.substring(0, suffix.start));
      continue;
    }
    out.add(line);
  }
  return out.join('\n');
}
