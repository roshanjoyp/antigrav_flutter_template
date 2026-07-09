import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:antigrav_flutter_template/core/widgets/app_error.dart';
import 'package:antigrav_flutter_template/core/widgets/app_loading.dart';
import 'package:antigrav_flutter_template/features/auth/data/auth_repository_impl.dart';
import 'package:antigrav_flutter_template/features/profile/data/profile_repository_impl.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_entity.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_repository.dart';
import 'package:antigrav_flutter_template/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A [ProfileRepository] whose watch stream fails immediately — used to
/// drive the screen's error state.
class FailingProfileRepository implements ProfileRepository {
  static const AppException _exception = AppException(
    message: 'You do not have permission to access this profile.',
    code: 'profile/permission-denied',
  );

  @override
  Stream<ProfileEntity?> watchProfile(String uid) =>
      Stream<ProfileEntity?>.error(_exception);

  @override
  Future<Result<ProfileEntity?>> fetchProfile(String uid) async =>
      const Failure<ProfileEntity?>(_exception);

  @override
  Future<Result<void>> saveProfile(ProfileEntity profile) async =>
      const Failure<void>(_exception);
}

void main() {
  Widget buildScreen(ProfileRepository repository) => ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWith((ref) => repository),
      authRepositoryProvider.overrideWith((ref) => StubAuthRepository()),
    ],
    child: const MaterialApp(home: ProfileScreen()),
  );

  group('ProfileScreen', () {
    testWidgets('shows loading, then the editable form', (tester) async {
      await tester.pumpWidget(buildScreen(StubProfileRepository()));
      expect(find.byType(AppLoading), findsOneWidget);

      await tester.pump();
      expect(find.text('Create your profile'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('saving shows feedback and the stream updates the form', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen(StubProfileRepository()));
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'Alice');
      await tester.tap(find.text('Save profile'));
      await tester.pump();
      // Save is in flight (stub network delay) — button shows a spinner.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(AppConstants.durationStubNetwork);
      await tester.pump();
      expect(find.text('Profile saved.'), findsOneWidget);
      expect(find.text('Your profile'), findsOneWidget);
    });

    testWidgets('shows AppError with retry when the stream fails', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen(FailingProfileRepository()));
      // Two pumps: one for the stream error to arrive, one for the
      // AsyncError rebuild.
      await tester.pump();
      await tester.pump();

      expect(find.byType(AppError), findsOneWidget);
      expect(
        find.text('You do not have permission to access this profile.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
