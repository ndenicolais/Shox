import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shox/features/data_management/controller/backup_controller.dart';
import 'package:shox/features/data_management/models/shoes_backup.dart';
import 'package:shox/features/data_management/repository/backup_repository.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

class MockRepository extends Mock implements BackupRepository {}

ShoesModel shoe(String id, {String imageUrl = ''}) => ShoesModel(
      id: id,
      imageUrl: imageUrl,
      colorPrimary: const Color(0xFF000000),
      brand: 'Brand $id',
      size: '42',
      category: 'Sneakers',
    );

ShoesBackup backupOf(List<BackupShoe> shoes) => ShoesBackup(
      manifest: BackupManifest(
        formatVersion: 1,
        createdAt: DateTime(2026, 10, 23),
        shoesCount: shoes.length,
      ),
      shoes: shoes,
    );

void main() {
  late MockRepository repository;
  late BackupController controller;
  final photo = Uint8List.fromList([1, 2, 3]);
  var nextId = 0;

  setUpAll(() {
    registerFallbackValue(<ShoesModel>[]);
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    repository = MockRepository();
    controller = BackupController(repository: repository);
    nextId = 0;
    when(() => repository.newShoesId()).thenAnswer((_) => 'new-${nextId++}');
    when(
      () => repository.uploadImage(
        shoesId: any(named: 'shoesId'),
        bytes: any(named: 'bytes'),
        extension: any(named: 'extension'),
      ),
    ).thenAnswer(
      (inv) async => 'https://storage/${inv.namedArguments[#shoesId]}',
    );
    when(() => repository.writeShoes(any())).thenAnswer((_) async {});
    when(() => repository.deleteShoes(any())).thenAnswer((_) async {});
    when(() => repository.deleteImage(any())).thenAnswer((_) async {});
  });

  group('buildBackup', () {
    test('downloads every photo and reports progress', () async {
      when(() => repository.fetchShoes()).thenAnswer(
        (_) async => [
          shoe('a', imageUrl: 'https://firebasestorage.googleapis.com/a.png'),
          shoe('b'),
        ],
      );
      when(() => repository.downloadImage(any()))
          .thenAnswer((_) async => photo);
      final progress = <double>[];

      final backup = await controller.buildBackup(onProgress: progress.add);

      expect(backup.manifest.shoesCount, 2);
      expect(backup.shoes[0].image, photo);
      expect(backup.shoes[0].imageExtension, '.png');
      expect(backup.shoes[1].image, isNull);
      expect(progress, [0.5, 1.0]);
      verify(() => repository.downloadImage(any())).called(1);
    });
  });

  group('restoreBackup', () {
    final current = [
      shoe('old-1', imageUrl: 'https://storage/old-1'),
      shoe('old-2'),
    ];

    setUp(() {
      when(() => repository.fetchShoes()).thenAnswer((_) async => current);
    });

    test('writes the backup first, then removes the current collection',
        () async {
      final result = await controller.restoreBackup(
        backupOf([
          BackupShoe(shoe: shoe(''), image: photo, imageExtension: '.png'),
          BackupShoe(shoe: shoe('')),
        ]),
        onProgress: (_) {},
      );

      expect(result.restoredCount, 2);
      expect(result.missingImages, 0);
      final calls = verifyInOrder([
        () => repository.writeShoes(captureAny()),
        () => repository.deleteShoes(['old-1', 'old-2']),
        () => repository.deleteImage('https://storage/old-1'),
      ]);
      final written = calls.first.captured.single as List<ShoesModel>;
      expect(written.map((s) => s.id), ['new-0', 'new-1']);
      expect(written.map((s) => s.imageUrl), ['https://storage/new-0', '']);
    });

    test('rolls back and keeps the current collection when a step fails',
        () async {
      when(() => repository.writeShoes(any()))
          .thenThrow(Exception('write failed'));

      await expectLater(
        controller.restoreBackup(
          backupOf([BackupShoe(shoe: shoe(''), image: photo)]),
          onProgress: (_) {},
        ),
        throwsException,
      );

      verify(() => repository.deleteShoes(['new-0'])).called(1);
      verify(() => repository.deleteImage('https://storage/new-0')).called(1);
      verifyNever(() => repository.deleteShoes(['old-1', 'old-2']));
      verifyNever(() => repository.deleteImage('https://storage/old-1'));
    });

    test('downloads legacy photos and counts the missing ones', () async {
      when(() => repository.downloadImage('https://legacy/ok'))
          .thenAnswer((_) async => photo);
      when(() => repository.downloadImage('https://legacy/gone'))
          .thenAnswer((_) async => null);

      final result = await controller.restoreBackup(
        backupOf([
          BackupShoe(shoe: shoe(''), legacyImageUrl: 'https://legacy/ok'),
          BackupShoe(shoe: shoe(''), legacyImageUrl: 'https://legacy/gone'),
        ]),
        onProgress: (_) {},
      );

      expect(result.restoredCount, 2);
      expect(result.missingImages, 1);
    });

    test('reports progress up to completion', () async {
      final progress = <double>[];

      await controller.restoreBackup(
        backupOf([BackupShoe(shoe: shoe(''))]),
        onProgress: progress.add,
      );

      expect(progress.last, 1.0);
      expect(progress, orderedEquals([...progress]..sort()));
    });
  });
}
