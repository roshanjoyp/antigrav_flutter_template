import 'package:craft_flutter_template/core/setup/setup_step.dart';

/// Setup steps for the RevenueCat paywall module
/// (`RevenueCatConfig.enabled`).
///
/// Skipped entirely while the module is disabled — the template runs on
/// the stub subscription repository.
const List<SetupStep> revenuecatSetupSteps = [
  SetupStep(
    id: 'revenuecat.keys',
    module: SetupModule.revenuecat,
    kind: SetupCheckKind.staticCheck,
    title: 'RevenueCat SDK keys pasted into RevenueCatConfig',
    remediation:
        'Paste your appl_/goog_ public SDK keys into '
        'lib/core/config/revenuecat/revenuecat_config.dart and remove the '
        'REVENUECAT_KEYS_PLACEHOLDER marker.',
    docPath: 'docs/setup/REVENUECAT_SETUP.md',
    link: 'https://app.revenuecat.com/',
  ),
  SetupStep(
    id: 'revenuecat.products',
    module: SetupModule.revenuecat,
    kind: SetupCheckKind.manual,
    title: 'Store products created and attached to the premium entitlement',
    remediation:
        'Create products in App Store Connect / Play Console, import them '
        'in the RevenueCat dashboard, and attach them to the entitlement '
        'named in RevenueCatConfig.premiumEntitlementId.',
    docPath: 'docs/setup/REVENUECAT_SETUP.md',
    link: 'https://app.revenuecat.com/',
  ),
  SetupStep(
    id: 'revenuecat.sandbox_purchase',
    module: SetupModule.revenuecat,
    kind: SetupCheckKind.manual,
    title: 'Sandbox purchase tested end-to-end',
    remediation:
        'Complete a purchase with a sandbox tester account and confirm the '
        'entitlement unlocks in-app.',
    docPath: 'docs/setup/REVENUECAT_SETUP.md',
  ),
];
