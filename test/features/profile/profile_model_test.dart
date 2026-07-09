import 'package:antigrav_flutter_template/features/profile/data/profile_model.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final DateTime when = DateTime.utc(2026, 7, 9, 12);

  group('ProfileModel', () {
    test('fromJson converts a Firestore Timestamp to DateTime', () {
      final ProfileModel model = ProfileModel.fromJson(<String, dynamic>{
        'uid': 'u1',
        'displayName': 'Alice',
        'bio': 'Hi',
        'photoUrl': null,
        'updatedAt': Timestamp.fromDate(when),
      });
      expect(model.uid, 'u1');
      // Timestamp.toDate() returns local time; compare instants, not zones.
      expect(model.updatedAt, when.toLocal());
    });

    test('fromJson tolerates a missing or malformed updatedAt', () {
      final ProfileModel missing = ProfileModel.fromJson(<String, dynamic>{
        'uid': 'u1',
      });
      expect(missing.updatedAt, isNull);

      final ProfileModel malformed = ProfileModel.fromJson(<String, dynamic>{
        'uid': 'u1',
        'updatedAt': 'not-a-timestamp',
      });
      expect(malformed.updatedAt, isNull);
    });

    test('toJson converts DateTime back to a Firestore Timestamp', () {
      final Map<String, dynamic> json = ProfileModel(
        uid: 'u1',
        displayName: 'Alice',
        updatedAt: when,
      ).toJson();
      expect(json['updatedAt'], Timestamp.fromDate(when));
    });

    test('entity round-trip preserves all fields', () {
      final ProfileEntity entity = ProfileEntity(
        uid: 'u1',
        displayName: 'Alice',
        bio: 'Hi',
        photoUrl: 'https://example.com/a.png',
        updatedAt: when,
      );
      expect(ProfileModel.fromEntity(entity).toEntity(), entity);
    });
  });
}
