/// Generation request: buyer identity + module selection.
library;

import 'dart:convert';

import 'module_registry.dart';

/// Thrown for any invalid generation request.
class ConfigException implements Exception {
  /// Creates a config error with a human-readable [message].
  ConfigException(this.message);

  /// What is wrong with the request.
  final String message;

  @override
  String toString() => 'ConfigException: $message';
}

final _packageIdRegex = RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*){2,}$');

/// A validated generation request.
class GeneratorConfig {
  GeneratorConfig._({
    required this.appName,
    required this.packageId,
    required this.description,
    required this.modules,
  });

  /// App display name (2–50 chars).
  final String appName;

  /// Fully-qualified package/bundle id.
  final String packageId;

  /// One-line pubspec description (10–180 chars).
  final String description;

  /// Selection per module id; every id in [kModules] has an entry.
  final Map<String, bool> modules;

  /// Module ids the buyer excluded.
  Set<String> get excluded => {
    for (final entry in modules.entries)
      if (!entry.value) entry.key,
  };

  /// Parses and validates a request from JSON text.
  static GeneratorConfig fromJsonString(String source) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (e) {
      throw ConfigException('config is not valid JSON: ${e.message}');
    }
    if (decoded is! Map<String, Object?>) {
      throw ConfigException('config must be a JSON object');
    }
    return fromJson(decoded);
  }

  /// Parses and validates a request from a decoded JSON map.
  static GeneratorConfig fromJson(Map<String, Object?> json) {
    final String appName = _string(json, 'appName');
    final String packageId = _string(json, 'packageId');
    final String description = _string(json, 'description');

    if (appName.length < 2 || appName.length > 50) {
      throw ConfigException('appName must be 2–50 characters');
    }
    if (!_packageIdRegex.hasMatch(packageId)) {
      throw ConfigException(
        'packageId must look like com.example.myapp '
        '(3+ lowercase dot-separated segments)',
      );
    }
    if (description.length < 10 || description.length > 180) {
      throw ConfigException('description must be 10–180 characters');
    }

    final Object rawModules = json['modules'] ?? const <String, Object?>{};
    if (rawModules is! Map<String, Object?>) {
      throw ConfigException('"modules" must be an object of booleans');
    }
    final Map<String, bool> modules = {
      for (final id in kModules.keys) id: false,
    };
    for (final entry in rawModules.entries) {
      if (!kModules.containsKey(entry.key)) {
        throw ConfigException('unknown module "${entry.key}"');
      }
      final Object? value = entry.value;
      if (value is! bool) {
        throw ConfigException('module "${entry.key}" must be true or false');
      }
      modules[entry.key] = value;
    }

    for (final module in kModules.values) {
      if (!modules[module.id]!) continue;
      for (final dep in module.requires) {
        if (!modules[dep]!) {
          throw ConfigException('module "${module.id}" requires "$dep"');
        }
      }
    }

    return GeneratorConfig._(
      appName: appName,
      packageId: packageId,
      description: description,
      modules: modules,
    );
  }

  static String _string(Map<String, Object?> json, String key) {
    final Object? value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw ConfigException('"$key" is required and must be a string');
    }
    return value.trim();
  }
}
