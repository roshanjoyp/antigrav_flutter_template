import 'package:craft_flutter_template/app/bootstrap.dart';
import 'package:craft_flutter_template/core/core.dart';

/// Default entry point — boots the **development** flavor.
///
/// Exists so `flutter run` with no `--target` still works (IDEs, CI, quick
/// starts). Real builds should pick their environment explicitly via the
/// flavor entry points, combined with the matching platform flavor:
///
/// ```sh
/// flutter run --flavor dev --target lib/main_dev.dart
/// flutter build apk --flavor prod --target lib/main_prod.dart
/// flutter build ipa --flavor prod --target lib/main_prod.dart
/// ```
///
/// Platform flavors (Android `productFlavors`, iOS schemes) give each
/// environment its own application/bundle id (`.dev` / `.stg` suffixes)
/// and launcher label, so all three install side by side. Desktop and web
/// targets have no flavor concept — they always run this default target.
void main() => bootstrap(AppEnv.development);
