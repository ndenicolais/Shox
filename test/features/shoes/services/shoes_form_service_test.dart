import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';
import 'package:shox/features/shoes/models/shoes_form_data.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/services/shoes_form_service.dart';

class MockShoesController extends GetxController
    with Mock
    implements ShoesController {}

ShoesFormData formData({
  File? newImage,
  Uint8List? imageNoBgBytes,
  bool hasExistingImage = false,
}) {
  return ShoesFormData(
    brand: 'Nike',
    size: '42',
    category: 'Sneakers',
    type: 'Running',
    season: 'Summer',
    notes: '',
    colorPrimary: const Color(0xFF000000),
    colorPrimarySelected: true,
    newImage: newImage,
    imageNoBgBytes: imageNoBgBytes,
    hasExistingImage: hasExistingImage,
  );
}

final existing = ShoesModel(
  id: 'shoe-1',
  imageUrl: 'https://example.com/old.png',
  colorPrimary: const Color(0xFFFFFFFF),
  brand: 'Old',
  size: '40',
  category: 'Boots',
  isFavorite: true,
  dateAdded: DateTime(2024, 5, 1),
);

void main() {
  late MockShoesController controller;
  late ShoesFormService service;
  final picked = File('picked.jpg');

  setUpAll(() {
    registerFallbackValue(existing);
    registerFallbackValue(File('fallback'));
  });

  setUp(() {
    controller = MockShoesController();
    Get.put<ShoesController>(controller);
    service = ShoesFormService();
    when(() => controller.addShoes(any(), any())).thenAnswer((_) async {});
    when(() => controller.updateShoes(
          any(),
          newImage: any(named: 'newImage'),
          removedImages: any(named: 'removedImages'),
        )).thenAnswer((_) async {});
  });

  tearDown(Get.reset);

  test('adds a new shoe uploading the picked photo', () async {
    await service.save(formData(newImage: picked));

    final captured =
        verify(() => controller.addShoes(captureAny(), captureAny())).captured;
    expect((captured[0] as ShoesModel).imageUrl, picked.path);
    expect(captured[1], same(picked));
  });

  test('uploads the background-free PNG when available', () async {
    await service.save(
      formData(newImage: picked, imageNoBgBytes: Uint8List.fromList([1, 2])),
    );

    final File uploaded =
        verify(() => controller.addShoes(any(), captureAny())).captured.single;
    expect(uploaded.path, endsWith('.png'));
    expect(await uploaded.readAsBytes(), [1, 2]);
    await uploaded.delete();
  });

  test('editing without touching the photo keeps it and the favorite flag',
      () async {
    await service.save(formData(hasExistingImage: true), existing: existing);

    final captured = verify(() => controller.updateShoes(
          captureAny(),
          newImage: captureAny(named: 'newImage'),
          removedImages: captureAny(named: 'removedImages'),
        )).captured;
    final model = captured[0] as ShoesModel;
    expect(model.imageUrl, existing.imageUrl);
    expect(model.isFavorite, isTrue);
    expect(model.id, 'shoe-1');
    expect(captured[1], isNull);
    expect(captured[2], isNull);
  });

  test('replacing a removed photo uploads the new one and deletes the old',
      () async {
    await service.save(formData(newImage: picked), existing: existing);

    final captured = verify(() => controller.updateShoes(
          any(),
          newImage: captureAny(named: 'newImage'),
          removedImages: captureAny(named: 'removedImages'),
        )).captured;
    expect(captured[0], same(picked));
    expect(captured[1], [existing.imageUrl]);
  });
}
