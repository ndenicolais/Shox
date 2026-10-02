import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shox/features/database/models/pdf_collection_summary.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';

ShoesModel _shoe(
  String brand, {
  String category = 'Sneakers',
  Color color = Colors.black,
  bool favorite = false,
}) =>
    ShoesModel(
      imageUrl: '',
      colorPrimary: color,
      brand: brand,
      size: '42',
      category: category,
      isFavorite: favorite,
    );

void main() {
  test('counts pairs, favorites and distinct brands', () {
    final summary = PdfCollectionSummary.fromShoes([
      _shoe('Nike', favorite: true),
      _shoe('Nike '),
      _shoe('Adidas', favorite: true),
      _shoe(''),
    ]);

    expect(summary.totalPairs, 4);
    expect(summary.favorites, 2);
    expect(summary.brandCount, 2);
  });

  test('ranks by count, then A-Z, and caps the rows', () {
    final summary = PdfCollectionSummary.fromShoes([
      for (final brand in ['B', 'A', 'C', 'D', 'E', 'F', 'G']) _shoe(brand),
      _shoe('G'),
      _shoe('Boots', category: 'Boots', color: Colors.white),
      _shoe('Boots', category: 'Boots', color: Colors.white),
    ]);

    expect(
      summary.topBrands.map((e) => e.key),
      ['Boots', 'G', 'A', 'B', 'C'],
    );
    expect(summary.topBrands, hasLength(PdfCollectionSummary.maxRows));
    expect(summary.topCategories.first.key, 'Sneakers');
    expect(summary.topColors.first.key, Colors.black.toARGB32());
    expect(summary.topColors.first.value, 8);
  });
}
