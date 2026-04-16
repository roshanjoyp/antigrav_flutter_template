/// Top-level barrel export for all public core infrastructure.
///
/// Provides a single import for constants, utilities, configuration,
/// and foundational widgets used across every feature in the app:
/// ```dart
/// import 'package:antigrav_flutter_template/core/core.dart';
/// ```
///
/// Note: service providers are not included here — import them directly
/// from their respective service files to keep provider access explicit.
library;

// Constants
export 'package:antigrav_flutter_template/core/constants/app_colors.dart';
export 'package:antigrav_flutter_template/core/constants/app_constants.dart';

// Utilities
export 'package:antigrav_flutter_template/core/utils/result.dart';

// Configuration
export 'package:antigrav_flutter_template/core/config/app_env.dart';
export 'package:antigrav_flutter_template/core/config/app_flavor.dart';

// Widgets
export 'package:antigrav_flutter_template/core/widgets/widgets.dart';
