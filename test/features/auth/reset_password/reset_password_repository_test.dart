import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shox/core/utils/app_exceptions.dart';
import 'package:shox/features/auth/reset_password/repository/reset_password_repository.dart';

class MockAuth extends Mock implements FirebaseAuth {}

Matcher throwsAuthException(String code) =>
    throwsA(isA<AuthException>().having((e) => e.code, 'code', code));

void main() {
  late MockAuth auth;
  late ResetPasswordRepository repository;

  setUp(() {
    auth = MockAuth();
    repository = ResetPasswordRepository(auth: auth);
  });

  void givenResetError(String code) {
    when(() => auth.sendPasswordResetEmail(email: any(named: 'email')))
        .thenThrow(FirebaseAuthException(code: code));
  }

  test('returns the email once the reset email is sent', () async {
    when(() => auth.sendPasswordResetEmail(email: any(named: 'email')))
        .thenAnswer((_) async {});

    expect(await repository.resetPassword('a@b.it'), 'a@b.it');
  });

  test('maps user-not-found to email_not_found', () {
    givenResetError('user-not-found');

    expect(
      repository.resetPassword('x@y.it'),
      throwsAuthException('email_not_found'),
    );
  });

  test('maps any other failure to reset_failed', () {
    givenResetError('too-many-requests');

    expect(
      repository.resetPassword('a@b.it'),
      throwsAuthException('reset_failed'),
    );
  });
}
