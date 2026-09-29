import 'dart:math' as math;
import 'dart:typed_data';

/// Pure helpers that clean up the alpha mask produced by the background
/// removal model. They work on flat buffers (row-major, `width * height`
/// alpha values, `width * height * 4` RGBA bytes) so they are fast inside an
/// isolate and easy to unit test.
class MaskRefinement {
  /// Maps segmentation confidence (0..1 per pixel) to alpha: below [low] is
  /// background, above [high] fully opaque, with a linear ramp in between
  /// for soft but tight edges.
  static Uint8List alphaFromConfidence(
    List<double> confidence, {
    double low = 0.35,
    double high = 0.65,
  }) {
    final alpha = Uint8List(confidence.length);
    final span = high - low;
    for (int i = 0; i < confidence.length; i++) {
      final t = ((confidence[i] - low) / span).clamp(0.0, 1.0);
      alpha[i] = (t * 255).round();
    }
    return alpha;
  }

  /// Shrinks the opaque area by [radius] pixels (min filter, done as two
  /// separable passes), removing the rim of background left around the
  /// subject.
  static Uint8List erode(Uint8List alpha, int width, int height, int radius) {
    if (radius <= 0) return Uint8List.fromList(alpha);
    final horizontal = Uint8List(alpha.length);
    for (int y = 0; y < height; y++) {
      final row = y * width;
      for (int x = 0; x < width; x++) {
        int value = 255;
        final from = math.max(0, x - radius);
        final to = math.min(width - 1, x + radius);
        for (int k = from; k <= to && value > 0; k++) {
          value = math.min(value, alpha[row + k]);
        }
        horizontal[row + x] = value;
      }
    }
    final result = Uint8List(alpha.length);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int value = 255;
        final from = math.max(0, y - radius);
        final to = math.min(height - 1, y + radius);
        for (int k = from; k <= to && value > 0; k++) {
          value = math.min(value, horizontal[k * width + x]);
        }
        result[y * width + x] = value;
      }
    }
    return result;
  }

  /// Replaces the color of edge pixels (partially transparent, or opaque but
  /// touching transparency) with the average color of fully opaque interior
  /// pixels within [radius], so the edges no longer carry the tint of the
  /// removed background. Returns a new RGBA buffer; alpha is not changed.
  static Uint8List decontaminateEdges(
    Uint8List rgba,
    Uint8List alpha,
    int width,
    int height, {
    int radius = 3,
  }) {
    final result = Uint8List.fromList(rgba);
    // Interior = opaque pixels whose whole 3x3 neighbourhood is opaque.
    final interior = erode(_opaqueOnly(alpha), width, height, 1);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final i = y * width + x;
        if (alpha[i] == 0 || interior[i] == 255) continue;

        int r = 0, g = 0, b = 0, count = 0;
        final y0 = math.max(0, y - radius),
            y1 = math.min(height - 1, y + radius);
        final x0 = math.max(0, x - radius),
            x1 = math.min(width - 1, x + radius);
        for (int ny = y0; ny <= y1; ny++) {
          for (int nx = x0; nx <= x1; nx++) {
            final j = ny * width + nx;
            if (interior[j] != 255) continue;
            r += rgba[j * 4];
            g += rgba[j * 4 + 1];
            b += rgba[j * 4 + 2];
            count++;
          }
        }
        if (count == 0) continue;
        result[i * 4] = r ~/ count;
        result[i * 4 + 1] = g ~/ count;
        result[i * 4 + 2] = b ~/ count;
      }
    }
    return result;
  }

  static Uint8List _opaqueOnly(Uint8List alpha) {
    final out = Uint8List(alpha.length);
    for (int i = 0; i < alpha.length; i++) {
      out[i] = alpha[i] == 255 ? 255 : 0;
    }
    return out;
  }
}
