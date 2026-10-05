import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shox/core/utils/app_exceptions.dart';
import 'package:shox/features/auth/login/repository/login_repository.dart';
import 'package:shox/features/auth/services/auth_service.dart';

class MockAuth extends Mock implements FirebaseAuth {}

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockAuthService extends Mock implements AuthService {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

Matcher throwsAuthException(String code) =>
    throwsA(isA<AuthException>().having((e) => e.code, 'code', code));

void main() {
  late MockAuth auth;
  late MockFirestore firestore;
  late MockAuthService authService;
  late MockGoogleSignIn googleSignIn;
  late LoginRepository repository;

  setUp(() {
    auth = MockAuth();
    firestore = MockFirestore();
    authService = MockAuthService();
    googleSignIn = MockGoogleSignIn();
    repository = LoginRepository(
      auth: auth,
      firestore: firestore,
      authService: authService,
      googleSignIn: googleSignIn,
    );
  });

  group('loginWithEmailPassword', () {
    void givenSignInError(String code) {
      when(
        () => auth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(FirebaseAuthException(code: code));
    }

    test('never queries Firestore before signing in', () async {
      givenSignInError('wrong-password');

      await expectLater(
        repository.loginWithEmailPassword('a@b.it', 'bad', false),
        throwsA(isA<AuthException>()),
      );
      verifyZeroInteractions(firestore);
    });

    test('maps user-not-found to email_not_found', () async {
      givenSignInError('user-not-found');

      expect(
        repository.loginWithEmailPassword('x@y.it', 'pwd', false),
        throwsAuthException('email_not_found'),
      );
    });

    test('maps a wrong password to invalid_password', () async {
      givenSignInError('wrong-password');

      expect(
        repository.loginWithEmailPassword('a@b.it', 'bad', false),
        throwsAuthException('invalid_password'),
      );
    });

    test('maps invalid-credential to invalid_credentials', () async {
      givenSignInError('invalid-credential');

      expect(
        repository.loginWithEmailPassword('a@b.it', 'bad', false),
        throwsAuthException('invalid_credentials'),
      );
    });

    test('saves the session only when remember me is on', () async {
      final user = MockUser();
      final credential = MockCredential();
      when(() => user.uid).thenReturn('uid-1');
      when(() => credential.user).thenReturn(user);
      when(
        () => auth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => credential);
      when(() => authService.saveSession(any())).thenAnswer((_) async {});

      await repository.loginWithEmailPassword('a@b.it', 'pwd', false);
      verifyNever(() => authService.saveSession(any()));

      final result =
          await repository.loginWithEmailPassword('a@b.it', 'pwd', true);
      expect(result, same(user));
      verify(() => authService.saveSession('uid-1')).called(1);
    });
  });

  group('loginWithGoogle', () {
    test('returns null when the user cancels the picker', () async {
      when(() => googleSignIn.signIn()).thenAnswer((_) async => null);

      expect(await repository.loginWithGoogle(true), isNull);
    });

    test('maps Play Services network errors to network_error', () async {
      when(() => googleSignIn.signIn()).thenThrow(
        PlatformException(code: GoogleSignIn.kNetworkError),
      );

      expect(
        repository.loginWithGoogle(true),
        throwsAuthException('network_error'),
      );
    });

    test('maps other platform errors to google_sign_in_failed', () async {
      when(() => googleSignIn.signIn()).thenThrow(
        PlatformException(code: GoogleSignIn.kSignInFailedError),
      );

      expect(
        repository.loginWithGoogle(true),
        throwsAuthException('google_sign_in_failed'),
      );
    });
  });
}
