/// Barrel export for the profile feature.
///
/// The template's reference feature: a complete clean-architecture
/// slice (entity → repository interface → stub/Firestore data layer →
/// controller → view). Read it top to bottom to learn the house
/// pattern before adding your own features.
library;

// Domain
export 'package:craft_flutter_template/features/profile/domain/profile_entity.dart';
export 'package:craft_flutter_template/features/profile/domain/profile_repository.dart';

// Data — exported for the Riverpod provider (profileRepositoryProvider)
export 'package:craft_flutter_template/features/profile/data/profile_repository_impl.dart';

// Data — Firestore implementation, bound when Firebase is enabled
export 'package:craft_flutter_template/features/profile/data/firestore_profile_repository_impl.dart'; // MODULE(firebase)

// Presentation
export 'package:craft_flutter_template/features/profile/presentation/profile_controller.dart';
export 'package:craft_flutter_template/features/profile/presentation/profile_screen.dart';
