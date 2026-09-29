import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shox/core/utils/utils.dart';
import 'package:shox/features/home/widgets/shoes_grid.dart';

void main() {
  group('ShoesGridLayout.columnsFor', () {
    test('keeps the user choice on phones', () {
      expect(const ShoesGridLayout(GridColumns.gOne).columnsFor(390), 1);
      expect(const ShoesGridLayout(GridColumns.gTwo).columnsFor(390), 2);
      expect(const ShoesGridLayout(GridColumns.gThree).columnsFor(390), 3);
    });

    test('adds columns on wide screens, up to 4', () {
      expect(const ShoesGridLayout(GridColumns.gTwo).columnsFor(700), 3);
      expect(const ShoesGridLayout(GridColumns.gTwo).columnsFor(1000), 4);
      expect(const ShoesGridLayout(GridColumns.gThree).columnsFor(1000), 4);
    });

    test('a single column stays single on any width', () {
      expect(const ShoesGridLayout(GridColumns.gOne).columnsFor(1000), 1);
    });
  });

  test('cell width subtracts the gaps between columns', () {
    const layout = ShoesGridLayout(GridColumns.gTwo);
    final width = layout.cellWidth(352, 2);

    expect(width * 2 + ShoesGridLayout.crossSpacing, closeTo(352, 0.001));
  });

  test('cells are the square photo plus the caption', () {
    final delegate = const ShoesGridLayout(GridColumns.gTwo).delegate(
      columns: 2,
      cellWidth: 170,
      captionHeight: 48,
    ) as SliverGridDelegateWithFixedCrossAxisCount;

    expect(delegate.crossAxisCount, 2);
    expect(delegate.mainAxisExtent, 218);
  });
}
