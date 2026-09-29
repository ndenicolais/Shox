import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shox/features/users/controller/user_controller.dart';
import 'package:shox/features/users/models/user_model.dart';
import 'package:shox/features/users/repository/user_repository.dart';

class MockRepository extends Mock implements UserRepository {}

void main() {
  late MockRepository repository;
  late UserController controller;

  setUp(() {
    repository = MockRepository();
    controller = UserController(userRepository: repository);
  });

  group('loadUserProfile', () {
    test('stores the first name, email and photo', () async {
      when(() => repository.getUserDetails('uid-1')).thenAnswer(
        (_) async => UserModel(
          userEmail: 'mario@example.com',
          userName: 'Mario Rossi',
        ),
      );
      when(() => repository.getUserProfileImageUrl('uid-1'))
          .thenAnswer((_) async => 'https://example.com/me.png');

      await controller.loadUserProfile('uid-1');

      expect(controller.userName.value, 'Mario');
      expect(controller.userEmail.value, 'mario@example.com');
      expect(controller.userProfileImage.value, 'https://example.com/me.png');
      expect(controller.isLoadingProfile.value, isFalse);
    });

    test('keeps the defaults and stops loading when the fetch fails', () async {
      when(() => repository.getUserDetails(any()))
          .thenThrow(Exception('offline'));

      await controller.loadUserProfile('uid-1');

      expect(controller.userName.value, 'User');
      expect(controller.userProfileImage.value, isEmpty);
      expect(controller.isLoadingProfile.value, isFalse);
    });
  });

  group('loadUserName', () {
    test('uses the stored name', () async {
      when(() => repository.loadUserName()).thenAnswer((_) async => 'Mario');

      await controller.loadUserName();

      expect(controller.userName.value, 'Mario');
    });

    test('falls back to "User" on errors', () async {
      when(() => repository.loadUserName())
          .thenAnswer((_) async => throw Exception('offline'));

      await controller.loadUserName();

      expect(controller.userName.value, 'User');
    });
  });
}
