import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/repository/shoes_repository.dart';

class MockRepository extends Mock implements ShoesRepository {}

class MockAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockHttpClient extends Mock implements http.Client {}

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
  late MockHttpClient httpClient;
  late ShoesController controller;
  final photo = File('photo.png');

  setUpAll(() {
    registerFallbackValue(shoe());
    registerFallbackValue(File('fallback'));
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    repository = MockRepository();
    auth = MockAuth();
    httpClient = MockHttpClient();
    final user = MockUser();
    when(() => user.uid).thenReturn('uid-1');
    when(() => auth.currentUser).thenReturn(user);
    when(() => repository.updateShoes(any())).thenAnswer((_) async {});
    controller = ShoesController(
      repository: repository,
      auth: auth,
      httpClient: httpClient,
    );
  });

  group('addShoes', () {
    test('creates the document, uploads the photo and stores its URL',
        () async {
      when(() => repository.addShoes(any())).thenAnswer((_) async => 'new-id');
      when(
        () => repository.uploadImage(
          userId: any(named: 'userId'),
          shoesId: any(named: 'shoesId'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenAnswer((_) async => 'https://example.com/new.png');

      await controller.addShoes(shoe(id: '', isFavorite: true), photo);

      verify(
        () => repository.uploadImage(
          userId: 'uid-1',
          shoesId: 'new-id',
          imageFile: photo,
        ),
      ).called(1);
      final saved = verify(() => repository.updateShoes(captureAny()))
          .captured
          .single as ShoesModel;
      expect(saved.id, 'new-id');
      expect(saved.imageUrl, 'https://example.com/new.png');
      expect(saved.isFavorite, isTrue);
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
    test('removes the photo and then the document', () async {
      when(() => repository.deleteImage(any())).thenAnswer((_) async {});
      when(() => repository.deleteShoes(any())).thenAnswer((_) async {});

      await controller.deleteShoes(shoe());

      verifyInOrder([
        () => repository.deleteImage('https://example.com/old.png'),
        () => repository.deleteShoes('shoe-1'),
      ]);
    });

    test('skips the storage call when the shoe has no photo', () async {
      when(() => repository.deleteShoes(any())).thenAnswer((_) async {});

      await controller.deleteShoes(shoe(imageUrl: ''));

      verifyNever(() => repository.deleteImage(any()));
      verify(() => repository.deleteShoes('shoe-1')).called(1);
    });
  });

  group('JSON import/export', () {
    test('exports every shoe as a JSON list', () async {
      when(() => repository.getAllShoes())
          .thenAnswer((_) async => [shoe(), shoe(id: 'shoe-2')]);
      when(() => repository.convertTimestampsToStrings(any()))
          .thenAnswer((inv) => {'brand': 'Nike'});

      final json = await controller.exportShoesToJson();

      expect(jsonDecode(json), hasLength(2));
    });

    test('imports shoes, re-uploads photos and reports progress', () async {
      when(() => repository.addShoes(any())).thenAnswer((_) async => 'id');
      when(() => httpClient.get(any()))
          .thenAnswer((_) async => http.Response('bytes', 200));
      when(
        () => repository.uploadImage(
          userId: any(named: 'userId'),
          shoesId: any(named: 'shoesId'),
          imageFile: any(named: 'imageFile'),
        ),
      ).thenAnswer((_) async => 'https://example.com/copy.png');
      final data = jsonEncode([
        {
          'imageUrl': 'https://example.com/a.png',
          'colorPrimary': 0xFF000000,
          'brand': 'Nike',
          'size': '42',
          'category': 'Sneakers',
          'type': 'Running',
          'season': 'All',
          'isFavorite': false,
          'dateAdded': '2024-05-01T00:00:00.000',
          'dateUpdated': '2024-05-01T00:00:00.000',
        },
        {
          'imageUrl': '',
          'colorPrimary': 0xFFFFFFFF,
          'brand': 'Adidas',
          'size': '41',
          'category': 'Sneakers',
          'type': 'Casual',
          'season': 'All',
          'isFavorite': true,
          'dateAdded': '2024-05-02T00:00:00.000',
          'dateUpdated': '2024-05-02T00:00:00.000',
        },
      ]);
      final progress = <double>[];

      await controller.importShoesFromJson(data, onProgress: progress.add);

      expect(progress, [0.5, 1.0]);
      verify(() => httpClient.get(Uri.parse('https://example.com/a.png')))
          .called(1);
      final saved = verify(() => repository.updateShoes(captureAny()))
          .captured
          .cast<ShoesModel>();
      expect(saved.map((s) => s.imageUrl), [
        'https://example.com/copy.png',
        '',
      ]);
    });
  });
}
