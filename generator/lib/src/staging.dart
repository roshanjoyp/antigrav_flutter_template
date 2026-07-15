/// Template → staging tree copy with the generation denylist, plus the
/// denylist-aware zip writer.
library;

import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;

/// Directory names never copied into (or zipped out of) a generated
/// project, wherever they appear.
const Set<String> kDenyDirNames = {
  '.git',
  'build',
  '.dart_tool',
  'coverage',
  '.idea',
  '.claude',
  'generator',
  'configurator',
  'landing',
  'Pods',
  '.gradle',
  'ephemeral',
};

/// Root-relative paths never copied (product-internal material).
const Set<String> kDenyRootPaths = {'docs/planning'};

/// File names never copied.
const Set<String> kDenyFileNames = {'custom_lint.log', '.DS_Store'};

/// Whether the root-relative [relative] path is denied.
bool isDenied(String relative) {
  final parts = p.split(relative);
  if (parts.any(kDenyDirNames.contains)) return true;
  if (kDenyFileNames.contains(parts.last)) return true;
  for (final deny in kDenyRootPaths) {
    if (relative == deny || relative.startsWith('$deny/')) return true;
  }
  return false;
}

/// Recursively copies the template at [root] into [staging], skipping
/// denied paths. [staging] must not already exist.
void copyTemplate(Directory root, Directory staging) {
  staging.createSync(recursive: true);
  for (final entity in root.listSync(recursive: true, followLinks: false)) {
    if (entity is! File) continue;
    final relative = p.relative(entity.path, from: root.path);
    if (isDenied(relative)) continue;
    final target = File(p.join(staging.path, relative));
    target.parent.createSync(recursive: true);
    entity.copySync(target.path);
  }
}

/// Zips every non-denied file under [staging] into [outPath].
///
/// In-memory and fully synchronous on purpose: `ZipFileEncoder.addFile`
/// became async in archive 4.x, and unawaited adds close as an empty
/// archive — the pipeline is a sync call chain.
void writeProjectZip(Directory staging, String outPath) {
  final archive = Archive();
  for (final entity in staging.listSync(recursive: true)) {
    if (entity is! File) continue;
    final rel = p.relative(entity.path, from: staging.path);
    if (isDenied(rel)) continue;
    archive.addFile(ArchiveFile.typedData(rel, entity.readAsBytesSync()));
  }
  File(outPath).writeAsBytesSync(ZipEncoder().encodeBytes(archive));
}
