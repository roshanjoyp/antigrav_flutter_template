/// Shared plumbing for the setup script: result tracking, the core
/// file-update helper, prompt helpers, and the final summary.
///
/// Note: files under `setup/` are a standalone CLI outside `lib/`, so
/// they import each other relatively — the package-absolute import rule
/// applies to app code only.
library;

// ignore_for_file: avoid_print

import 'dart:io';

/// All file operation outcomes, printed in the final summary.
final List<FileResult> results = [];

/// Outcome category of one file operation.
enum FileStatus { modified, noChangeNeeded, notFound }

/// One file operation outcome for the final summary.
class FileResult {
  /// Creates a result for [path] with [status] and optional [detail].
  const FileResult(this.path, this.status, [this.detail]);

  /// Repo-relative path (or glob label) the operation targeted.
  final String path;

  /// What happened.
  final FileStatus status;

  /// Extra context shown in the summary, if any.
  final String? detail;
}

/// Writes [question] to stdout and returns the trimmed response from stdin.
String prompt(String question) {
  stdout.write(question);
  return (stdin.readLineSync() ?? '').trim();
}

/// Reads the file at [path], applies [transform] to its contents, and
/// writes the result back only if the content changed. Records the
/// outcome in [results] for the final summary. Never throws — a missing
/// file or read/write error is logged as a warning and skipped.
void updateFile(
  String path,
  String Function(String content) transform, {
  String? label,
}) {
  final displayPath = label ?? path;
  final file = File(path);

  if (!file.existsSync()) {
    results.add(
      FileResult(displayPath, FileStatus.notFound, 'file not found — skipped'),
    );
    return;
  }

  try {
    final original = file.readAsStringSync();
    final updated = transform(original);
    if (updated == original) {
      results.add(FileResult(displayPath, FileStatus.noChangeNeeded));
    } else {
      file.writeAsStringSync(updated);
      results.add(FileResult(displayPath, FileStatus.modified));
    }
  } catch (e) {
    results.add(
      FileResult(displayPath, FileStatus.notFound, 'error: $e — skipped'),
    );
  }
}

/// Deletes [dir] if empty, then walks up and does the same until [stopAt].
void deleteEmptyAncestors(Directory dir, Directory stopAt) {
  try {
    if (dir.path == stopAt.path) return;
    if (dir.listSync().isEmpty) {
      dir.deleteSync();
      deleteEmptyAncestors(dir.parent, stopAt);
    }
  } catch (_) {
    // Ignore any cleanup errors — they are non-critical
  }
}

/// Prints the grouped modified / no-change / skipped summary.
void printSummary() {
  final sep = '─' * 70;
  print('\n$sep');
  print('Setup complete — file summary');
  print(sep);

  final modified = results
      .where((r) => r.status == FileStatus.modified)
      .toList();
  final noChange = results
      .where((r) => r.status == FileStatus.noChangeNeeded)
      .toList();
  final notFound = results
      .where((r) => r.status == FileStatus.notFound)
      .toList();

  if (modified.isNotEmpty) {
    print('\n✅  Modified (${modified.length}):');
    for (final r in modified) {
      final detail = r.detail != null ? ' — ${r.detail}' : '';
      print('    ${r.path}$detail');
    }
  }

  if (noChange.isNotEmpty) {
    print('\n⏭   No change needed (${noChange.length}):');
    for (final r in noChange) {
      print('    ${r.path}');
    }
  }

  if (notFound.isNotEmpty) {
    print('\n⚠️   Not found / skipped (${notFound.length}):');
    for (final r in notFound) {
      final detail = r.detail != null ? ' — ${r.detail}' : '';
      print('    ${r.path}$detail');
    }
  }

  print('\n$sep');
  print('Next steps:');
  print('  flutter pub get');
  print('  Android: flutter clean && flutter pub get');
  print(sep);
}
