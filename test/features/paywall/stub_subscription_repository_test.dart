import 'package:antigrav_flutter_template/features/paywall/data/subscription_repository_impl.dart';
import 'package:antigrav_flutter_template/features/paywall/domain/paywall_offering_entity.dart';
import 'package:antigrav_flutter_template/features/paywall/domain/subscription_status_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StubSubscriptionRepository', () {
    test('starts unsubscribed and serves the fake offering', () async {
      final StubSubscriptionRepository repository =
          StubSubscriptionRepository();

      final statusResult = await repository.fetchStatus();
      expect(statusResult.getOrNull()?.isSubscribed, isFalse);

      final offeringResult = await repository.fetchOffering();
      final PaywallOfferingEntity? offering = offeringResult.getOrNull();
      expect(offering?.id, 'default');
      expect(offering?.packages, hasLength(3));
      expect(
        offering?.packages.map((PaywallPackageEntity p) => p.periodLabel),
        containsAll(<String>['Monthly', 'Annual', 'Lifetime']),
      );
    });

    test(
      'purchase grants the stub entitlement and notifies watchers',
      () async {
        final StubSubscriptionRepository repository =
            StubSubscriptionRepository();
        final List<SubscriptionStatusEntity> emitted =
            <SubscriptionStatusEntity>[];
        final subscription = repository.watchStatus().listen(emitted.add);
        await Future<void>.delayed(Duration.zero);
        expect(emitted.single.isSubscribed, isFalse);

        final result = await repository.purchase(
          StubSubscriptionRepository.stubOffering.packages.first,
        );
        expect(result.getOrNull()?.isSubscribed, isTrue);
        expect(result.getOrNull()?.activeEntitlementIds, <String>[
          StubSubscriptionRepository.stubEntitlementId,
        ]);

        await Future<void>.delayed(Duration.zero);
        expect(emitted.last.isSubscribed, isTrue);

        await subscription.cancel();
      },
    );

    test(
      'restorePurchases reports the current status without granting',
      () async {
        final StubSubscriptionRepository repository =
            StubSubscriptionRepository();
        final result = await repository.restorePurchases();
        expect(result.isSuccess, isTrue);
        expect(result.getOrNull()?.isSubscribed, isFalse);
      },
    );
  });
}
