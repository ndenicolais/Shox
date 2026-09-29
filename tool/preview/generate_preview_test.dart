// Generates the README preview images from the raw device screenshots.
//
// Not part of the test suite (it lives outside test/). Run it on demand:
//   flutter test tool/preview/generate_preview_test.dart
//
// Inputs:  images/screenshots/<name>_raw.png (1080x2392, with system bars)
// Outputs: images/shox_preview.png  banner with tilted phones
//          images/screenshots/<name>.png  screens without system bars
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shox/theme/app_colors.dart';

const _dir = 'images/screenshots';
const _screens = ['form', 'details', 'home', 'dashboard', 'database'];

// System bars on the raw 1080x2392 screenshots.
const _statusBarHeight = 108;
const _navBarHeight = 70;

// The README shows the gallery at 160 px wide: half resolution is plenty.
const _galleryScale = 0.5;

const _bannerSize = Size(2400, 1350);

Future<ui.Image> _decode(List<int> bytes) async {
  final codec = await ui.instantiateImageCodec(Uint8List.fromList(bytes));
  return (await codec.getNextFrame()).image;
}

Future<void> _loadFonts() async {
  final loader = FontLoader('Montserrat')
    ..addFont(_fontBytes('assets/fonts/Montserrat.ttf'))
    ..addFont(_fontBytes('assets/fonts/Montserrat-Bold.ttf'));
  await loader.load();
}

Future<ByteData> _fontBytes(String path) async =>
    ByteData.sublistView(await File(path).readAsBytes());

Future<void> _capture(WidgetTester tester, GlobalKey key, String path) async {
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage();
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    await File(path).writeAsBytes(png!.buffer.asUint8List());
  });
}

Future<void> _render(
  WidgetTester tester,
  Size size,
  Widget child,
  String path,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  final key = GlobalKey();
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: RepaintBoundary(key: key, child: child),
    ),
  );
  await tester.pump();
  await _capture(tester, key, path);
}

void main() {
  testWidgets('generate README previews', (tester) async {
    addTearDown(tester.view.reset);
    await tester.runAsync(_loadFonts);

    final raw = <String, ui.Image>{};
    await tester.runAsync(() async {
      for (final name in _screens) {
        raw[name] = await _decode(
          await File('$_dir/${name}_raw.png').readAsBytes(),
        );
      }
    });

    // Gallery: each screen without status and navigation bars.
    for (final name in _screens) {
      final image = raw[name]!;
      final crop = Rect.fromLTRB(
        0,
        _statusBarHeight.toDouble(),
        image.width.toDouble(),
        (image.height - _navBarHeight).toDouble(),
      );
      await _render(
        tester,
        crop.size * _galleryScale,
        CustomPaint(
          size: crop.size * _galleryScale,
          painter: _CropPainter(image, crop),
        ),
        '$_dir/$name.png',
      );
    }

    // Banner: five phones fanned out on the app background.
    await _render(
      tester,
      _bannerSize,
      _Banner(screens: [for (final name in _screens) raw[name]!]),
      'images/shox_preview.png',
    );
  });
}

class _CropPainter extends CustomPainter {
  _CropPainter(this.image, this.source);

  final ui.Image image;
  final Rect source;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      source,
      Offset.zero & size,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(_CropPainter oldDelegate) => false;
}

class _Banner extends StatelessWidget {
  const _Banner({required this.screens});

  final List<ui.Image> screens;

  @override
  Widget build(BuildContext context) {
    // (horizontal center, phone height, rotation around Y, around Z)
    const slots = [
      (360.0, 820.0, 0.55, -0.05),
      (760.0, 960.0, 0.35, -0.03),
      (1200.0, 1120.0, 0.0, 0.0),
      (1640.0, 960.0, -0.35, 0.03),
      (2040.0, 820.0, -0.55, 0.05),
    ];
    // Paint back to front so the center phone overlaps its neighbours.
    const order = [0, 4, 1, 3, 2];

    return Container(
      width: _bannerSize.width,
      height: _bannerSize.height,
      color: AppColors.whiteSmoke,
      child: Stack(
        children: [
          for (final i in order)
            _PositionedPhone(
              image: screens[i],
              centerX: slots[i].$1,
              height: slots[i].$2,
              rotateY: slots[i].$3,
              rotateZ: slots[i].$4,
            ),
        ],
      ),
    );
  }
}

class _PositionedPhone extends StatelessWidget {
  const _PositionedPhone({
    required this.image,
    required this.centerX,
    required this.height,
    required this.rotateY,
    required this.rotateZ,
  });

  final ui.Image image;
  final double centerX;
  final double height;
  final double rotateY;
  final double rotateZ;

  @override
  Widget build(BuildContext context) {
    final width = height * image.width / image.height;
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0008)
      ..rotateY(rotateY)
      ..rotateZ(rotateZ);

    return Positioned(
      left: centerX - width / 2,
      top: (_bannerSize.height - height) / 2,
      width: width,
      height: height,
      child: Transform(
        alignment: Alignment.center,
        transform: transform,
        child: _Phone(image: image),
      ),
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone({required this.image});

  final ui.Image image;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final bezel = width * 0.035;
        final radius = width * 0.12;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF1F1B17),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: const Color(0xFF8C8276),
              width: math.max(2, width * 0.006),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkGray.withValues(alpha: 0.28),
                blurRadius: width * 0.14,
                offset: Offset(0, width * 0.07),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(bezel),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius - bezel),
              child: RawImage(
                image: image,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        );
      },
    );
  }
}
