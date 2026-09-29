import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shox/core/utils/mask_refinement.dart';

/// Square [size]x[size] alpha mask, opaque inside [from, to) on both axes.
Uint8List squareMask(int size, int from, int to) {
  final alpha = Uint8List(size * size);
  for (int y = from; y < to; y++) {
    for (int x = from; x < to; x++) {
      alpha[y * size + x] = 255;
    }
  }
  return alpha;
}

int opaqueCount(Uint8List alpha) => alpha.where((a) => a == 255).length;

void main() {
  group('alphaFromConfidence', () {
    test('maps low confidence to transparent and high to opaque', () {
      final alpha = MaskRefinement.alphaFromConfidence([0.0, 0.3, 0.7, 1.0]);

      expect(alpha, [0, 0, 255, 255]);
    });

    test('ramps linearly between the thresholds', () {
      final alpha = MaskRefinement.alphaFromConfidence([0.5]);

      expect(alpha.single, closeTo(128, 1));
    });
  });

  group('erode', () {
    test('shrinks the opaque area by the radius on every side', () {
      final mask = squareMask(12, 2, 10); // 8x8 opaque square

      final eroded = MaskRefinement.erode(mask, 12, 12, 1);

      expect(opaqueCount(eroded), 6 * 6);
      expect(eroded[2 * 12 + 2], 0, reason: 'old corner is now transparent');
      expect(eroded[3 * 12 + 3], 255, reason: 'new corner stays opaque');
    });

    test('removes shapes thinner than the erosion diameter', () {
      final mask = squareMask(10, 4, 6); // 2x2 speck

      expect(opaqueCount(MaskRefinement.erode(mask, 10, 10, 1)), 0);
    });

    test('radius 0 returns an unchanged copy', () {
      final mask = squareMask(6, 1, 5);
      final result = MaskRefinement.erode(mask, 6, 6, 0);

      expect(result, mask);
      expect(identical(result, mask), isFalse);
    });
  });

  group('decontaminateEdges', () {
    test('edge pixels take the color of the opaque interior', () {
      const size = 9;
      final alpha = squareMask(size, 2, 7); // 5x5 subject
      // Semi-transparent ring around it, like a feathered edge.
      for (int i = 0; i < 9; i++) {
        alpha[1 * size + i] = alpha[1 * size + i] == 0 ? 128 : 255;
      }
      final rgba = Uint8List(size * size * 4);
      for (int i = 0; i < size * size; i++) {
        // Dark subject on a white background.
        final inside = alpha[i] == 255;
        rgba[i * 4] = inside ? 20 : 250;
        rgba[i * 4 + 1] = inside ? 20 : 250;
        rgba[i * 4 + 2] = inside ? 20 : 250;
        rgba[i * 4 + 3] = alpha[i];
      }
      // A light, background-tinted pixel on the opaque border of the subject.
      const border = 2 * size + 4;
      rgba[border * 4] = 200;

      final result = MaskRefinement.decontaminateEdges(rgba, alpha, size, size);

      const ring = 1 * size + 4; // semi-transparent pixel above the subject
      expect(result[ring * 4], 20, reason: 'ring pixel no longer white');
      expect(result[border * 4], lessThan(200), reason: 'border pixel cleaned');
      const center = 4 * size + 4;
      expect(result[center * 4], 20, reason: 'interior untouched');
      expect(result[0], 250, reason: 'fully transparent pixels untouched');
    });
  });
}
