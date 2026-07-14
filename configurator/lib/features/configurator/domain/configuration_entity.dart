import 'dart:convert';

import 'package:craft_configurator/core/utils/text_derivations.dart';
import 'package:craft_configurator/features/configurator/domain/module_catalogue.dart';
import 'package:craft_configurator/features/configurator/domain/configurator_module_entity.dart';

/// The buyer's current configuration: identity + module selection.
///
/// Immutable; derived values (package id, zip name, config JSON) are
/// computed here so widgets stay logic-free. The JSON shape and the
/// validation limits mirror `generator/lib/src/config.dart`.
class ConfigurationEntity {
  /// Creates a configuration.
  const ConfigurationEntity({
    required this.appName,
    required this.organization,
    required this.description,
    required this.enabledModuleIds,
  });

  /// The default configuration shown on first load: everything on.
  factory ConfigurationEntity.initial() {
    return ConfigurationEntity(
      appName: 'My App',
      organization: 'com.example',
      description: 'A production-grade Flutter app built on CRAFT.',
      enabledModuleIds: {for (final m in kModuleCatalogue) m.id},
    );
  }

  /// App display name (generator limit: 2–50 chars).
  final String appName;

  /// Reverse-domain organization, e.g. `com.example`.
  final String organization;

  /// One-line pubspec description (generator limit: 10–180 chars).
  final String description;

  /// Ids of the modules currently selected.
  final Set<String> enabledModuleIds;

  /// Snake_case project name derived from [appName].
  String get projectName => snakeCase(appName);

  /// Fully-qualified package/bundle id.
  String get packageId => '${organization.trim()}.$projectName';

  /// Name of the zip the generator will produce.
  String get zipName => '$projectName.zip';

  /// Whether [id] is currently enabled.
  bool isEnabled(String id) => enabledModuleIds.contains(id);

  /// The enabled catalogue entries, in catalogue order.
  List<ConfiguratorModuleEntity> get enabledModules => [
    for (final m in kModuleCatalogue)
      if (isEnabled(m.id)) m,
  ];

  /// Returns a copy with [id] toggled to [enabled], keeping the
  /// requires-relations of the catalogue satisfied: enabling a module
  /// pulls its requirements in, disabling one drops its dependents.
  ConfigurationEntity withModule(String id, {required bool enabled}) {
    final Set<String> next = {...enabledModuleIds};
    if (enabled) {
      next.add(id);
      for (final m in kModuleCatalogue) {
        if (m.id == id) next.addAll(m.requires);
      }
    } else {
      next.remove(id);
      for (final m in kModuleCatalogue) {
        if (m.requires.contains(id)) next.remove(m.id);
      }
    }
    return copyWith(enabledModuleIds: next);
  }

  /// Returns a copy with the given fields replaced.
  ConfigurationEntity copyWith({
    String? appName,
    String? organization,
    String? description,
    Set<String>? enabledModuleIds,
  }) {
    return ConfigurationEntity(
      appName: appName ?? this.appName,
      organization: organization ?? this.organization,
      description: description ?? this.description,
      enabledModuleIds: enabledModuleIds ?? this.enabledModuleIds,
    );
  }

  static final RegExp _packageIdRegex = RegExp(
    r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*){2,}$',
  );

  /// Problems the generator would reject this configuration for;
  /// empty when the config is valid.
  List<String> get validationErrors {
    final List<String> errors = [];
    final String name = appName.trim();
    if (name.length < 2 || name.length > 50) {
      errors.add('App name must be 2–50 characters.');
    }
    if (!_packageIdRegex.hasMatch(packageId)) {
      errors.add('Package must look like com.example.my_app.');
    }
    final String desc = description.trim();
    if (desc.length < 10 || desc.length > 180) {
      errors.add('Description must be 10–180 characters.');
    }
    return errors;
  }

  /// Whether the generator would accept this configuration.
  bool get isValid => validationErrors.isEmpty;

  /// The generator's exact input, as a decoded JSON map.
  Map<String, Object?> toConfigJson() {
    return {
      'appName': appName.trim(),
      'packageId': packageId,
      'description': description.trim(),
      'modules': {for (final m in kModuleCatalogue) m.id: isEnabled(m.id)},
    };
  }

  /// Pretty-printed `config.json` text for download.
  String toConfigJsonString() {
    return '${const JsonEncoder.withIndent('  ').convert(toConfigJson())}\n';
  }
}
