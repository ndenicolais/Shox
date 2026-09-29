// Firestore query/snapshot classes are @sealed to discourage custom
// implementations; mocking them in tests is the intended exception.
// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shox/core/utils/constants.dart';
import 'package:shox/features/auth/services/auth_service.dart';

typedef Json = Map<String, dynamic>;

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollection extends Mock implements CollectionReference<Json> {}

class MockQuery extends Mock implements Query<Json> {}

class MockQuerySnapshot extends Mock implements QuerySnapshot<Json> {}

class MockDocument extends Mock implements QueryDocumentSnapshot<Json> {}

void main() {
  late MockFirestore firestore;
  late MockQuery query;
  late MockQuerySnapshot snapshot;
  late AuthService service;

  setUp(() {
    firestore = MockFirestore();
    final collection = MockCollection();
    final filtered = MockQuery();
    query = MockQuery();
    snapshot = MockQuerySnapshot();

    when(() => firestore.collection('users')).thenReturn(collection);
    when(
      () => collection.where('userEmail', isEqualTo: any(named: 'isEqualTo')),
    ).thenReturn(filtered);
    when(() => filtered.limit(1)).thenReturn(query);
    when(() => query.get()).thenAnswer((_) async => snapshot);

    service = AuthService(firestore: firestore);
  });

  group('findUserByEmail', () {
    test('returns the matching user document', () async {
      final doc = MockDocument();
      when(() => snapshot.docs).thenReturn([doc]);

      expect(await service.findUserByEmail('a@b.it'), same(doc));
    });

    test('returns null when no user has that email', () async {
      when(() => snapshot.docs).thenReturn([]);

      expect(await service.findUserByEmail('none@b.it'), isNull);
    });
  });

  group('session', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('saveSession remembers the user id', () async {
      await service.saveSession('uid-1');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(AppConstants.prefsRememberMe), isTrue);
      expect(prefs.getString(AppConstants.prefsUserId), 'uid-1');
    });

    test('clearSession forgets the user', () async {
      await service.saveSession('uid-1');
      await service.clearSession();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(AppConstants.prefsRememberMe), isNull);
      expect(prefs.getString(AppConstants.prefsUserId), isNull);
    });
  });
}
