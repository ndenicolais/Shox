import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/repository/shoes_repository.dart';

class MockRepository extends Mock implements ShoesRepository {}

class MockAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

ShoesModel shoe({
  String? id = 'shoe-1',
  String imageUrl = 'https://example.com/old.png',
  bool isFavorite = false,
}) {
  return ShoesModel(
    id: id,
    imageUrl: imageUrl,
    colorPrimary: const Color(0xFF000000),
    brand: 'Nike',
    size: '42',
    category: 'Sneakers',
    type: 'Running',
    isFavorite: isFavorite,
    dateAdded: DateTime(2024, 5, 1),
  );
}

void main() {
  late MockRepository repository;
  late MockAuth auth;
  late ShoesController controller;
  final photo = File('photo.png');

  setUpAll(() {
    registerFallbackValue(shoe());
    registerFallbackValue(File('fallback'));
  });

  setUp(() {
    repository = MockRepository();
    auth = MockAuth();
    final user = MockUser();
    when(() => user.uid).thenReturn('uid-1');
    when(() => auth.currentUser).thenReturn(user);
    when(() => repository.updateShoes(any())).thenAnswer((_) async {});
    controller = ShoesController(
      repository: repository,
      auth: auth,
    );
  });

  group('addShoes', () {
    void stubUpload() {
      when(
        () => repository.uploadImage(
          userId: any(named: 'userId'),
          shoesId: any(named: 'shoesId'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenAnswer((_) async => 'https://example.com/new.png');
    }

    setUp(() {
      when(() => repository.newShoesId()).thenReturn('new-id');
      when(() => repository.deleteImage(any())).thenAnswer((_) async {});
    });

    test('uploads the photo first, then writes the document once', () async {
      stubUpload();
      when(() => repository.addShoes(any())).thenAnswer((_) async => 'new-id');

      await controller.addShoes(shoe(id: '', isFavorite: true), photo);

      verify(
        () => repository.uploadImage(
          userId: 'uid-1',
          shoesId: 'new-id',
          imageFile: photo,
        ),
      ).called(1);
      final saved = verify(() => repository.addShoes(captureAny()))
          .captured
          .single as ShoesModel;
      expect(saved.id, 'new-id');
      expect(saved.imageUrl, 'https://example.com/new.png');
      expect(saved.isFavorite, isTrue);
      verifyNever(() => repository.updateShoes(any()));
    });

    test('creates no document when the upload fails', () async {
      when(
        () => repository.uploadImage(
          userId: any(named: 'userId'),
          shoesId: any(named: 'shoesId'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenThrow(Exception('upload failed'));

      await expectLater(controller.addShoes(shoe(), photo), throwsException);
      verifyNever(() => repository.addShoes(any()));
    });

    test('removes the uploaded photo when the document write fails', () async {
      stubUpload();
      when(() => repository.addShoes(any()))
          .thenThrow(Exception('write failed'));

      await expectLater(controller.addShoes(shoe(), photo), throwsException);
      verify(() => repository.deleteImage('https://example.com/new.png'))
          .called(1);
    });

    test('refuses to run without a signed-in user', () async {
      when(() => auth.currentUser).thenReturn(null);

      expect(controller.addShoes(shoe(), photo), throwsException);
      verifyNever(() => repository.addShoes(any()));
    });
  });

  group('updateShoes', () {
    test('requires the shoe id', () async {
      expect(controller.updateShoes(shoe(id: '')), throwsException);
    });

    test('deletes removed photos, uploads the new one and keeps the flags',
        () async {
      when(() => repository.deleteImage(any())).thenAnswer((_) async {});
      when(
        () => repository.uploadImage(
          userId: any(named: 'userId'),
          shoesId: any(named: 'shoesId'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenAnswer((_) async => 'https://example.com/new.png');

      await controller.updateShoes(
        shoe(isFavorite: true),
        newImage: photo,
        removedImages: ['https://example.com/old.png'],
      );

      verify(() => repository.deleteImage('https://example.com/old.png'))
          .called(1);
      final saved = verify(() => repository.updateShoes(captureAny()))
          .captured
          .single as ShoesModel;
      expect(saved.imageUrl, 'https://example.com/new.png');
      expect(saved.isFavorite, isTrue);
      expect(saved.dateAdded, DateTime(2024, 5, 1));
    });

    test('keeps the old photo when the new upload fails', () async {
      when(
        () => repository.uploadImage(
          userId: any(named: 'userId'),
          shoesId: any(named: 'shoesId'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenThrow(Exception('upload failed'));

      await expectLater(
        controller.updateShoes(
          shoe(),
          newImage: photo,
          removedImages: ['https://example.com/old.png'],
        ),
        throwsException,
      );
      verifyNever(() => repository.deleteImage(any()));
      verifyNever(() => repository.updateShoes(any()));
    });

    test('deletes the old photo only after the document is updated', () async {
      when(() => repository.deleteImage(any())).thenAnswer((_) async {});
      when(
        () => repository.uploadImage(
          userId: any(named: 'userId'),
          shoesId: any(named: 'shoesId'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenAnswer((_) async => 'https://example.com/new.png');
      when(() => repository.updateShoes(any()))
          .thenThrow(Exception('write failed'));

      await expectLater(
        controller.updateShoes(
          shoe(),
          newImage: photo,
          removedImages: ['https://example.com/old.png'],
        ),
        throwsException,
      );
      verifyNever(() => repository.deleteImage('https://example.com/old.png'));
      verify(() => repository.deleteImage('https://example.com/new.png'))
          .called(1);
    });

    test('keeps the stored photo when nothing changed', () async {
      await controller.updateShoes(shoe());

      verifyNever(() => repository.deleteImage(any()));
      final saved = verify(() => repository.updateShoes(captureAny()))
          .captured
          .single as ShoesModel;
      expect(saved.imageUrl, 'https://example.com/old.png');
    });
  });

  group('deleteShoes', () {
    test('removes the document and then the photo', () async {
      when(() => repository.deleteImage(any())).thenAnswer((_) async {});
      when(() => repository.deleteShoes(any())).thenAnswer((_) async {});

      await controller.deleteShoes(shoe());

      verifyInOrder([
        () => repository.deleteShoes('shoe-1'),
        () => repository.deleteImage('https://example.com/old.png'),
      ]);
    });

    test('still succeeds when the photo cannot be deleted', () async {
      when(() => repository.deleteImage(any()))
          .thenThrow(Exception('storage error'));
      when(() => repository.deleteShoes(any())).thenAnswer((_) async {});

      await controller.deleteShoes(shoe());

      verify(() => repository.deleteShoes('shoe-1')).called(1);
    });

    test('skips the storage call when the shoe has no photo', () async {
      when(() => repository.deleteShoes(any())).thenAnswer((_) async {});

      await controller.deleteShoes(shoe(imageUrl: ''));

      verifyNever(() => repository.deleteImage(any()));
      verify(() => repository.deleteShoes('shoe-1')).called(1);
    });
  });
}
