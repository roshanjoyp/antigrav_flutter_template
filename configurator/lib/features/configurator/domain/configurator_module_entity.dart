import 'package:craft_configurator/features/configurator/domain/setup_step_entity.dart';

/// One optional template module as presented to the buyer.
///
/// [id], [requires], and [pubspecDeps] must stay identical to the
/// generator's `module_registry.dart` — the configurator's output is the
/// generator's exact input. A drift-guard test enforces this.
class ConfiguratorModuleEntity {
  /// Creates a module card definition.
  const ConfiguratorModuleEntity({
    required this.id,
    required this.group,
    required this.name,
    required this.description,
    this.requires = const {},
    this.pubspecDeps = const [],
    required this.addedFiles,
    required this.steps,
  });

  /// Stable module id — the generator's `MODULE(<id>)` marker name.
  final String id;

  /// Display group heading in the module list (e.g. "Backend").
  final String group;

  /// Buyer-facing module name.
  final String name;

  /// One-paragraph description under the name.
  final String description;

  /// Module ids this module cannot ship without.
  final Set<String> requires;

  /// pubspec dependencies this module adds (mirrors the registry).
  final List<String> pubspecDeps;

  /// Representative file-tree lines added when the module is included.
  final List<String> addedFiles;

  /// Post-download setup steps contributed by this module.
  final List<SetupStepEntity> steps;
}
