/// Top-level barrel export for all public core infrastructure.
///
/// Provides a single import for constants, utilities, configuration,
/// and foundational widgets used across every feature in the app:
/// ```dart
/// import 'package:craft_flutter_template/core/core.dart';
/// ```
///
/// Note: service providers are not included here — import them directly
/// from their respective service files to keep provider access explicit.
library;

// Constants
export 'package:craft_flutter_template/core/constants/app_colors.dart';
export 'package:craft_flutter_template/core/constants/app_constants.dart';

// Utilities
export 'package:craft_flutter_template/core/utils/result.dart';

// Configuration
export 'package:craft_flutter_template/core/config/app_env.dart';
export 'package:craft_flutter_template/core/config/app_flavor.dart';
export 'package:craft_flutter_template/core/config/firebase/firebase_config.dart'; // MODULE(firebase)
export 'package:craft_flutter_template/core/config/revenuecat/revenuecat_config.dart'; // MODULE(revenuecat)

// Widgets
export 'package:craft_flutter_template/core/widgets/widgets.dart';
