import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:craft_flutter_template/core/widgets/app_error.dart';
import 'package:craft_flutter_template/core/widgets/app_loading.dart';
import 'package:craft_flutter_template/features/paywall/data/subscription_repository_impl.dart';
import 'package:craft_flutter_template/features/paywall/domain/paywall_offering_entity.dart';
import 'package:craft_flutter_template/features/paywall/domain/subscription_repository.dart';
import 'package:craft_flutter_template/features/paywall/domain/subscription_status_entity.dart';
import 'package:craft_flutter_template/features/paywall/presentation/paywall_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A [SubscriptionRepository] that fails every call — drives the
/// screen's error state and the cancelled-purchase path.
class FailingSubscriptionRepository implements SubscriptionRepository {
  /// Creates a repository failing with [exception].
  FailingSubscriptionRepository(this.exception);

  /// The exception every method fails with.
  final AppException exception;

  @override
  Stream<SubscriptionStatusEntity> watchStatus() =>
      Stream<SubscriptionStatusEntity>.value(const SubscriptionStatusEntity());

  @override
  Future<Result<SubscriptionStatusEntity>> fetchStatus() async =>
      Failure<SubscriptionStatusEntity>(exception);

  @override
  Future<Result<PaywallOfferingEntity?>> fetchOffering() async =>
      Failure<PaywallOfferingEntity?>(exception);

  @override
  Future<Result<SubscriptionStatusEntity>> purchase(
    PaywallPackageEntity package,
  ) async => Failure<SubscriptionStatusEntity>(exception);

  @override
  Future<Result<SubscriptionStatusEntity>> restorePurchases() async =>
      Failure<SubscriptionStatusEntity>(exception);
}

/// Like the stub, but purchases fail as user-cancelled.
class CancellingSubscriptionRepository extends StubSubscriptionRepository {
  @override
  Future<Result<SubscriptionStatusEntity>> purchase(
    PaywallPackageEntity package,
  ) async => const Failure<SubscriptionStatusEntity>(
    AppException(
      message: 'Purchase cancelled.',
      code: 'paywall/purchase-cancelled',
    ),
  );
}

void main() {
  Widget buildScreen(SubscriptionRepository repository) => ProviderScope(
    overrides: [
      subscriptionRepositoryProvider.overrideWith((ref) => repository),
    ],
    child: const MaterialApp(home: PaywallScreen()),
  );

  group('PaywallScreen', () {
    testWidgets('shows loading, then the offering packages', (tester) async {
      await tester.pumpWidget(buildScreen(StubSubscriptionRepository()));
      expect(find.byType(AppLoading), findsOneWidget);

      await tester.pump(AppConstants.durationStubNetwork);
      await tester.pump();
      expect(find.text('Go Premium'), findsOneWidget);
      expect(find.text('Monthly'), findsOneWidget);
      expect(find.text('Annual'), findsOneWidget);
      expect(find.text('Lifetime'), findsOneWidget);

      // The restore button sits at the end of the (lazy) ListView.
      await tester.scrollUntilVisible(
        find.text('Restore purchases'),
        AppConstants.space5xl,
      );
      expect(find.text('Restore purchases'), findsOneWidget);
    });

    testWidgets('purchasing unlocks the subscribed state', (tester) async {
      await tester.pumpWidget(buildScreen(StubSubscriptionRepository()));
      await tester.pump(AppConstants.durationStubNetwork);
      await tester.pump();

      await tester.tap(find.text('Buy').first);
      await tester.pump();
      // Purchase in flight — the tapped button shows a spinner.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(AppConstants.durationStubNetwork);
      await tester.pump();
      expect(
        find.text('Purchase successful — welcome aboard!'),
        findsOneWidget,
      );
      expect(find.text("You're premium!"), findsOneWidget);
      expect(find.text('Buy'), findsNothing);
    });

    testWidgets('a cancelled purchase shows no feedback', (tester) async {
      await tester.pumpWidget(buildScreen(CancellingSubscriptionRepository()));
      await tester.pump(AppConstants.durationStubNetwork);
      await tester.pump();

      await tester.tap(find.text('Buy').first);
      await tester.pump(AppConstants.durationStubNetwork);
      await tester.pump();

      expect(find.byType(SnackBar), findsNothing);
      expect(find.text('Go Premium'), findsOneWidget);
    });

    testWidgets('restore reports when nothing was restored', (tester) async {
      await tester.pumpWidget(buildScreen(StubSubscriptionRepository()));
      await tester.pump(AppConstants.durationStubNetwork);
      await tester.pump();

      await tester.scrollUntilVisible(
        find.text('Restore purchases'),
        AppConstants.space5xl,
      );
      // Real-font metrics can leave the row only partially on screen
      // after the scroll — bring it fully into view before tapping.
      await tester.ensureVisible(find.text('Restore purchases'));
      await tester.pump();
      await tester.tap(find.text('Restore purchases'));
      await tester.pump();
      expect(find.text('Restoring...'), findsOneWidget);

      await tester.pump(AppConstants.durationStubNetwork);
      await tester.pump();
      expect(find.text('No previous purchases found.'), findsOneWidget);
    });

    testWidgets('shows AppError with retry when the offering fails', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildScreen(
          FailingSubscriptionRepository(
            const AppException(
              message: 'The store is misconfigured.',
              code: 'paywall/configuration',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(AppError), findsOneWidget);
      expect(find.text('The store is misconfigured.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
