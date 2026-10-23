import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shox/features/data_management/models/shoes_backup.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

ShoesModel shoe(String brand, {bool isFavorite = false}) => ShoesModel(
      id: 'old-$brand',
      imageUrl: 'https://example.com/$brand.png',
      colorPrimary: const Color(0xFF112233),
      colorExtra: [0xFF445566],
      brand: brand,
      size: '42',
      category: 'Sneakers',
      type: 'Running',
      season: 'Summer',
      notes: 'note',
      isFavorite: isFavorite,
      dateAdded: DateTime(2024, 5, 1),
      dateUpdated: DateTime(2024, 6, 1),
    );

ShoesBackup backupOf(List<BackupShoe> shoes) => ShoesBackup(
      manifest: BackupManifest(
        formatVersion: ShoesBackup.currentFormatVersion,
        createdAt: DateTime(2026, 10, 23, 10),
        shoesCount: shoes.length,
        appVersion: '5.0.0',
      ),
      shoes: shoes,
    );

Uint8List zipOf(Map<String, Object?> files) {
  final archive = Archive();
  files.forEach((name, content) {
    archive.addFile(
      content is List<int>
          ? ArchiveFile.bytes(name, content)
          : ArchiveFile.string(name, jsonEncode(content)),
    );
  });
  return ZipEncoder().encodeBytes(archive);
}

Matcher throwsBackupError(String code) => throwsA(
      isA<BackupFormatException>().having((e) => e.code, 'code', code),
    );

void main() {
  final photo = Uint8List.fromList([1, 2, 3, 4]);

  group('ZIP round trip', () {
    test('keeps every field, photo and the manifest', () {
      final bytes = backupOf([
        BackupShoe(
          shoe: shoe('Nike', isFavorite: true),
          image: photo,
          imageExtension: '.png',
        ),
        BackupShoe(shoe: shoe('Adidas')),
      ]).encode();

      final decoded = ShoesBackup.decode(bytes);

      expect(decoded.isLegacy, isFalse);
      expect(decoded.manifest.formatVersion, 1);
      expect(decoded.manifest.createdAt, DateTime(2026, 10, 23, 10));
      expect(decoded.manifest.shoesCount, 2);
      expect(decoded.manifest.appVersion, '5.0.0');

      final nike = decoded.shoes[0];
      expect(nike.image, photo);
      expect(nike.imageExtension, '.png');
      expect(nike.shoe.brand, 'Nike');
      expect(nike.shoe.colorPrimary, const Color(0xFF112233));
      expect(nike.shoe.colorExtra, [0xFF445566]);
      expect(nike.shoe.type, 'Running');
      expect(nike.shoe.season, 'Summer');
      expect(nike.shoe.notes, 'note');
      expect(nike.shoe.isFavorite, isTrue);
      expect(nike.shoe.dateAdded, DateTime(2024, 5, 1));
      expect(nike.shoe.dateUpdated, DateTime(2024, 6, 1));

      expect(decoded.shoes[1].image, isNull);
      expect(decoded.shoes[1].hasImage, isFalse);
    });

    test('does not keep the old download URLs or IDs', () {
      final decoded = ShoesBackup.decode(
        backupOf([BackupShoe(shoe: shoe('Nike'), image: photo)]).encode(),
      );

      expect(decoded.shoes.single.shoe.imageUrl, '');
      expect(decoded.shoes.single.shoe.id, '');
    });

    test('an empty collection is a valid backup', () {
      final decoded = ShoesBackup.decode(backupOf([]).encode());

      expect(decoded.shoes, isEmpty);
    });
  });

  group('ZIP validation', () {
    final validShoe = {'brand': 'Nike', 'category': 'Sneakers'};

    test('rejects a ZIP without manifest', () {
      expect(
        () => ShoesBackup.decode(
          zipOf({
            'shoes.json': [validShoe],
          }),
        ),
        throwsBackupError('not_a_backup'),
      );
    });

    test('rejects a newer format version', () {
      expect(
        () => ShoesBackup.decode(
          zipOf({
            'manifest.json': {'formatVersion': 99},
            'shoes.json': [validShoe],
          }),
        ),
        throwsBackupError('unsupported_version'),
      );
    });

    test('rejects a missing photo', () {
      expect(
        () => ShoesBackup.decode(
          zipOf({
            'manifest.json': {'formatVersion': 1, 'shoesCount': 1},
            'shoes.json': [
              {...validShoe, 'image': 'images/0.jpg'},
            ],
          }),
        ),
        throwsBackupError('corrupted'),
      );
    });

    test('rejects a shoe count different from the manifest', () {
      expect(
        () => ShoesBackup.decode(
          zipOf({
            'manifest.json': {'formatVersion': 1, 'shoesCount': 3},
            'shoes.json': [validShoe],
          }),
        ),
        throwsBackupError('corrupted'),
      );
    });

    test('rejects entries that are not shoes', () {
      expect(
        () => ShoesBackup.decode(
          zipOf({
            'manifest.json': {'formatVersion': 1},
            'shoes.json': [
              {'name': 'something else'},
            ],
          }),
        ),
        throwsBackupError('not_a_backup'),
      );
    });

    test('rejects a truncated archive', () {
      final bytes =
          backupOf([BackupShoe(shoe: shoe('Nike'), image: photo)]).encode();

      expect(
        () => ShoesBackup.decode(Uint8List.sublistView(bytes, 0, 40)),
        throwsA(isA<BackupFormatException>()),
      );
    });
  });

  group('legacy JSON export', () {
    test('reads the old list with photo URLs', () {
      final bytes = utf8.encode(
        jsonEncode([
          {
            'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/app/o/'
                'uid%2Fshoes%2Fid%2Fphoto.PNG?alt=media&token=t',
            'colorPrimary': 0xFF000000,
            'brand': 'Nike',
            'size': '42',
            'category': 'Sneakers',
            'type': 'Running',
            'isFavorite': true,
            'dateAdded': '2024-05-01T00:00:00.000',
            'dateUpdated': '2024-05-01T00:00:00.000',
          },
          {'imageUrl': '', 'brand': 'Adidas', 'category': 'Sneakers'},
        ]),
      );

      final decoded = ShoesBackup.decode(Uint8List.fromList(bytes));

      expect(decoded.isLegacy, isTrue);
      expect(decoded.manifest.createdAt, isNull);
      expect(decoded.shoes, hasLength(2));
      expect(decoded.shoes[0].legacyImageUrl, contains('photo.PNG'));
      expect(decoded.shoes[0].imageExtension, '.png');
      expect(decoded.shoes[0].shoe.isFavorite, isTrue);
      expect(decoded.shoes[0].shoe.dateAdded, DateTime(2024, 5, 1));
      expect(decoded.shoes[1].hasImage, isFalse);
    });

    test('rejects files that are neither ZIP nor a shoes list', () {
      expect(
        () => ShoesBackup.decode(Uint8List.fromList(utf8.encode('hello'))),
        throwsBackupError('not_a_backup'),
      );
      expect(
        () => ShoesBackup.decode(
          Uint8List.fromList(utf8.encode(jsonEncode({'a': 1}))),
        ),
        throwsBackupError('not_a_backup'),
      );
    });
  });
}
