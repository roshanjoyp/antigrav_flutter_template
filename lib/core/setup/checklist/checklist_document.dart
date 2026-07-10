/// Model + parser for the git-tracked `checklist.yaml` readiness state.
///
/// The file is the single source of truth for readiness *state* (item
/// definitions live in the module manifests): diffable, PR-reviewable,
/// shared via `git pull` — never per-device storage. The schema is
/// deliberately tiny, so it is parsed here by hand instead of pulling in
/// a YAML dependency; anything outside the schema below is ignored.
///
/// ```yaml
/// version: 1
/// items:
///   core.icon_replaced:
///     status: pending | done | skipped
///     reason: optional free text (why it was skipped)
///     owner: optional free text (who is on it)
/// custom:
///   - title: Anything project-specific
///     status: pending
///     owner: optional
/// ```
library;

/// Completion state of one checklist entry.
enum ChecklistStatus {
  /// Not done yet — counts against the completion total.
  pending,

  /// Done — counts toward the completion total.
  done,

  /// Deliberately opted out (with an optional reason). Auditable, and
  /// excluded from the completion total entirely.
  skipped,
}

/// State recorded in `checklist.yaml` for one manifest readiness item.
class ChecklistEntry {
  /// Creates an entry state.
  const ChecklistEntry({required this.status, this.reason, this.owner});

  /// The recorded completion status.
  final ChecklistStatus status;

  /// Why the item was skipped, if given.
  final String? reason;

  /// Who is responsible for the item, if assigned.
  final String? owner;
}

/// A free-form project-specific task appended by the developer.
class CustomChecklistTask {
  /// Creates a custom task.
  const CustomChecklistTask({
    required this.title,
    required this.status,
    this.owner,
  });

  /// The task text.
  final String title;

  /// The recorded completion status.
  final ChecklistStatus status;

  /// Who is responsible, if assigned.
  final String? owner;
}

/// Parsed contents of `checklist.yaml`.
class ChecklistDocument {
  /// Creates a parsed document.
  const ChecklistDocument({required this.entries, required this.custom});

  /// An empty document (missing or unreadable file).
  static const ChecklistDocument empty = ChecklistDocument(
    entries: <String, ChecklistEntry>{},
    custom: <CustomChecklistTask>[],
  );

  /// Manifest item states keyed by item id.
  final Map<String, ChecklistEntry> entries;

  /// Developer-added free-form tasks.
  final List<CustomChecklistTask> custom;

  /// The recorded entry for [itemId], defaulting to pending when the
  /// file has no entry for it yet.
  ChecklistEntry entryFor(String itemId) =>
      entries[itemId] ?? const ChecklistEntry(status: ChecklistStatus.pending);

  /// Parses [source] (the text of `checklist.yaml`).
  ///
  /// Line-based and forgiving: unknown keys and malformed lines are
  /// ignored, an unknown status string means pending.
  static ChecklistDocument parse(String source) {
    final Map<String, ChecklistEntry> entries = <String, ChecklistEntry>{};
    final List<CustomChecklistTask> custom = <CustomChecklistTask>[];
    String? section;
    String? currentId;
    Map<String, String> fields = <String, String>{};

    void flush() {
      if (section == 'items' && currentId != null) {
        entries[currentId!] = ChecklistEntry(
          status: _status(fields['status']),
          reason: fields['reason'],
          owner: fields['owner'],
        );
      } else if (section == 'custom' && fields.containsKey('title')) {
        custom.add(
          CustomChecklistTask(
            title: fields['title']!,
            status: _status(fields['status']),
            owner: fields['owner'],
          ),
        );
      }
      currentId = null;
      fields = <String, String>{};
    }

    for (final String raw in source.split('\n')) {
      final String line = raw.replaceFirst(RegExp(r'#.*$'), '');
      if (line.trim().isEmpty) continue;
      final int indent = line.length - line.trimLeft().length;
      final String trimmed = line.trim();
      if (indent == 0) {
        flush();
        section = trimmed.endsWith(':')
            ? trimmed.substring(0, trimmed.length - 1)
            : null;
      } else if (section == 'items' && indent == 2 && trimmed.endsWith(':')) {
        flush();
        section = 'items';
        currentId = trimmed.substring(0, trimmed.length - 1);
      } else if (section == 'custom' && trimmed.startsWith('- ')) {
        flush();
        section = 'custom';
        _readField(trimmed.substring(2), fields);
      } else {
        _readField(trimmed, fields);
      }
    }
    flush();
    return ChecklistDocument(entries: entries, custom: custom);
  }

  static void _readField(String line, Map<String, String> fields) {
    final int colon = line.indexOf(':');
    if (colon <= 0) return;
    final String value = line
        .substring(colon + 1)
        .trim()
        .replaceAll(RegExp('''^["']|["']\$'''), '');
    if (value.isNotEmpty) fields[line.substring(0, colon).trim()] = value;
  }

  static ChecklistStatus _status(String? raw) => switch (raw) {
    'done' => ChecklistStatus.done,
    'skipped' => ChecklistStatus.skipped,
    _ => ChecklistStatus.pending,
  };
}
