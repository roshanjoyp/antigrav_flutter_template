import 'package:craft_flutter_template/core/setup/setup_step.dart';

/// Setup steps for the REST/HTTP network layer.
///
/// The network layer ships with core (it is not an optional generator
/// module) but sits behind `NetworkConfig.enabled` like the module
/// switches, so these steps only apply once the real backend is turned
/// on — the doctor and Setup Status screen skip them while the stub
/// network service is bound.
const List<SetupStep> networkSetupSteps = [
  SetupStep(
    id: 'network.base_url',
    module: SetupModule.network,
    kind: SetupCheckKind.staticCheck,
    title: 'API base URLs configured (placeholders replaced)',
    remediation:
        'Set your dev/staging/prod endpoints in '
        'lib/core/config/network/network_config.dart and remove the '
        'NETWORK_BASE_URL_PLACEHOLDER marker.',
    docPath: 'lib/core/services/network_service/README.md',
  ),
];
