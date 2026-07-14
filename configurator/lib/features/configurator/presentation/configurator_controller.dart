import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:craft_configurator/core/services/download_service/download_service.dart';
import 'package:craft_configurator/features/configurator/domain/configuration_entity.dart';

part 'configurator_controller.g.dart';

/// Provides the platform [DownloadService].
@riverpod
DownloadService downloadService(Ref ref) => createDownloadService();

/// Holds the buyer's configuration and applies every mutation the form
/// can make; widgets stay logic-free and only call these methods.
@riverpod
class ConfiguratorController extends _$ConfiguratorController {
  @override
  ConfigurationEntity build() => ConfigurationEntity.initial();

  /// Updates the app display name.
  void setAppName(String value) => state = state.copyWith(appName: value);

  /// Updates the reverse-domain organization.
  void setOrganization(String value) =>
      state = state.copyWith(organization: value);

  /// Updates the one-line pubspec description.
  void setDescription(String value) =>
      state = state.copyWith(description: value);

  /// Toggles a module, keeping requires-relations satisfied.
  void toggleModule(String id, {required bool enabled}) =>
      state = state.withModule(id, enabled: enabled);

  /// Downloads the current configuration as `config.json`; returns false
  /// when the configuration is invalid and nothing was downloaded.
  bool downloadConfig() {
    if (!state.isValid) return false;
    ref
        .read(downloadServiceProvider)
        .downloadTextFile(
          fileName: 'config.json',
          text: state.toConfigJsonString(),
        );
    return true;
  }
}
