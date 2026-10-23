import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shox/core/utils/app_exceptions.dart';
import 'package:shox/features/auth/services/auth_service.dart';
import 'package:shox/features/users/repository/user_repository.dart';

class MockAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserInfo extends Mock implements UserInfo {}

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockStorage extends Mock implements FirebaseStorage {}

class MockAuthService extends Mock implements AuthService {}

class FakeCredential extends Fake implements AuthCredential {}

void main() {
  late MockAuth auth;
  late MockUser user;
  late UserRepository repository;

  setUpAll(() => registerFallbackValue(FakeCredential()));

  setUp(() {
    auth = MockAuth();
    user = MockUser();
    final info = MockUserInfo();
    when(() => info.providerId).thenReturn('password');
    when(() => user.providerData).thenReturn([info]);
    when(() => user.email).thenReturn('mario@example.com');
    when(() => auth.currentUser).thenReturn(user);
    repository = UserRepository(
      auth: auth,
      firestore: MockFirestore(),
      storage: MockStorage(),
      authService: MockAuthService(),
    );
  });

  group('reauthenticate', () {
    test('uses the typed password for email accounts', () async {
      when(() => user.reauthenticateWithCredential(any())).thenAnswer(
        (_) async => _FakeUserCredential(),
      );

      await repository.reauthenticate(password: 'secret');

      final credential =
          verify(() => user.reauthenticateWithCredential(captureAny()))
              .captured
              .single as AuthCredential;
      expect(credential.providerId, 'password');
    });

    test('maps a wrong password to invalid_credentials', () async {
      when(() => user.reauthenticateWithCredential(any())).thenThrow(
        FirebaseAuthException(code: 'invalid-credential'),
      );

      await expectLater(
        repository.reauthenticate(password: 'wrong'),
        throwsA(
          isA<AuthException>()
              .having((e) => e.code, 'code', 'invalid_credentials'),
        ),
      );
    });

    test('rejects an empty password without calling Firebase', () async {
      await expectLater(
        repository.reauthenticate(password: ''),
        throwsA(isA<AuthException>()),
      );
      verifyNever(() => user.reauthenticateWithCredential(any()));
    });

    test('reports other Firebase errors as reauth_failed', () async {
      when(() => user.reauthenticateWithCredential(any())).thenThrow(
        FirebaseAuthException(code: 'network-request-failed'),
      );

      await expectLater(
        repository.reauthenticate(password: 'secret'),
        throwsA(
          isA<AuthException>().having((e) => e.code, 'code', 'reauth_failed'),
        ),
      );
    });
  });
}

class _FakeUserCredential extends Fake implements UserCredential {}
