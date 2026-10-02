import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shox/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shox/features/database/controller/database_controller.dart';
import 'package:shox/features/database/models/pdf_collection_summary.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/core/utils/db_localized_values.dart';
import 'package:shox/core/utils/shoes_text_translations.dart';
import 'package:shox/core/services/downloads_service.dart';
import 'package:shox/core/utils/constants.dart';

final Logger _logger = Logger();

/// Longest side of the shoe photos embedded in the PDF.
const int _pdfImageMaxSide = 640;

/// JPEG quality of the embedded photos: keeps the file a few MB.
const int _pdfImageQuality = 80;

PdfColor _pdfColor(Color color) => PdfColor.fromInt(color.toARGB32());

final PdfColor _ink = _pdfColor(AppColors.darkGray);
final PdfColor _muted = _pdfColor(AppColors.mutedText);
final PdfColor _accent = _pdfColor(AppColors.darkPeach);
final PdfColor _cream = _pdfColor(AppColors.whiteSmoke);
final PdfColor _outline = _pdfColor(AppColors.outline);

/// Filled heart for favorite shoes (Material "favorite" icon path).
final String _heartSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
    '<path fill="#${(AppColors.darkPeach.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}" '
    'd="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3'
    'c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5'
    'c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>';

/// Photos are flattened on the panel color, so background-free shoes blend
/// into the panel instead of showing a white box.
const Color _photoBackground = AppColors.whiteSmoke;

/// Texts and fonts shared by every page.
class _PdfStyle {
  final pw.Font regular;
  final pw.Font bold;
  final pw.MemoryImage logo;
  final AppLocalizations l10n;
  final String languageCode;

  _PdfStyle({
    required this.regular,
    required this.bold,
    required this.logo,
    required this.l10n,
    required this.languageCode,
  });

  pw.PageTheme pageTheme({PdfColor? background}) => pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(
          _pageMarginH,
          36,
          _pageMarginH,
          28,
        ),
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        buildBackground: background == null
            ? null
            : (context) => pw.FullPage(
                  ignoreMargins: true,
                  child: pw.Container(color: background),
                ),
      );

  pw.TextStyle label() => pw.TextStyle(
        font: bold,
        fontSize: 8,
        letterSpacing: 1.2,
        color: _muted,
      );

  pw.TextStyle body({double size = 11, PdfColor? color}) =>
      pw.TextStyle(font: regular, fontSize: size, color: color ?? _ink);

  pw.TextStyle strong({double size = 11, PdfColor? color}) =>
      pw.TextStyle(font: bold, fontSize: size, color: color ?? _ink);

  String date(DateTime value) => DateFormat.yMMMd(languageCode).format(value);
}

/// Service for generating PDF documents from shoes database
/// This service handles the creation of formatted PDF reports with user data and shoes collection
class PdfService {
  final BuildContext context;
  final DatabaseController _databaseController;

  PdfService(this.context, this._databaseController);

  /// Generate a complete PDF report of all shoes in the database:
  /// cover, summary and one page per shoe.
  ///
  /// Parameters:
  /// - [context]: BuildContext for localization and theme access
  /// - [onProgress]: Callback to report generation progress (0.0 to 1.0)
  ///
  /// Returns: path of the PDF in the app cache (used for sharing); a copy is
  /// saved in the public Download/Shox folder
  ///
  /// Throws: Exception if PDF generation or saving fails
  Future<String> generateShoesPdf(
    BuildContext context,
    Function(double) onProgress,
  ) async {
    try {
      // Independent loads run in parallel.
      final (shoesList, userData, regularData, boldData, logoData, info) =
          await (
        _databaseController.getShoes(),
        _databaseController.getCurrentUserData(),
        rootBundle.load('assets/fonts/Montserrat.ttf'),
        rootBundle.load('assets/fonts/Montserrat-Bold.ttf'),
        rootBundle.load('assets/images/app_logo.png'),
        PackageInfo.fromPlatform(),
      ).wait;
      shoesList.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      final regular = pw.Font.ttf(regularData);
      final bold = pw.Font.ttf(boldData);
      final logo = pw.MemoryImage(logoData.buffer.asUint8List());
      onProgress(0.05);

      final photos = await _loadShoesImages(
        shoesList.map((s) => s.imageUrl).toList(),
        (fraction) => onProgress(0.05 + 0.8 * fraction),
      );
      if (!context.mounted) {
        throw Exception('Context no longer mounted');
      }
      final l10n = AppLocalizations.of(context)!;
      final style = _PdfStyle(
        regular: regular,
        bold: bold,
        logo: logo,
        l10n: l10n,
        languageCode: Localizations.localeOf(context).languageCode,
      );

      final pdf = pw.Document(title: 'Shox', author: 'Shox');
      pdf.addPage(
        _buildCoverPage(
          style,
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          totalPairs: shoesList.length,
        ),
      );
      pdf.addPage(
        _buildSummaryPage(
          context,
          style,
          PdfCollectionSummary.fromShoes(shoesList),
        ),
      );
      for (var i = 0; i < shoesList.length; i++) {
        pdf.addPage(_buildShoesPage(context, style, shoesList[i], photos[i]));
      }
      pdf.addPage(_buildCreditsPage(style, version: info.version));
      onProgress(0.9);

      final filePath = await _savePdf(pdf);
      await DownloadsService.saveToDownloads(
        filePath,
        mimeType: 'application/pdf',
      );
      onProgress(1.0);
      return filePath;
    } catch (e, stackTrace) {
      _logger.e('Failed to generate PDF', error: e, stackTrace: stackTrace);
      throw Exception('Failed to generate PDF: $e');
    }
  }
}

/// Photos downloaded and processed at the same time.
const int _imageConcurrency = 4;

/// Loads every photo with [_imageConcurrency] parallel workers sharing one
/// HTTP client (kept-alive connections); results keep the order of [urls].
Future<List<pw.MemoryImage?>> _loadShoesImages(
  List<String> urls,
  void Function(double fraction) onProgress,
) async {
  final results = List<pw.MemoryImage?>.filled(urls.length, null);
  final client = http.Client();
  var next = 0;
  var done = 0;
  Future<void> worker() async {
    while (next < urls.length) {
      final i = next++;
      results[i] = await _loadShoesImage(client, urls[i]);
      onProgress(++done / urls.length);
    }
  }

  try {
    await Future.wait(List.generate(_imageConcurrency, (_) => worker()));
  } finally {
    client.close();
  }
  return results;
}

/// Fetch image from URL and return as bytes
Future<Uint8List> fetchImage(http.Client client, String imageUrl) async {
  final response = await client.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

/// Downloads a shoe photo, downscales it and re-encodes it as JPEG flattened
/// on the photo panel color.
///
/// Returns null when the photo is missing or cannot be decoded, so a single
/// broken image does not abort the whole export.
Future<pw.MemoryImage?> _loadShoesImage(
  http.Client client,
  String imageUrl,
) async {
  if (!imageUrl.startsWith('http')) return null;
  try {
    final bytes = await fetchImage(client, imageUrl);
    final backgroundArgb = _photoBackground.toARGB32();
    final jpg = await Isolate.run(() {
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;
      // Background-free photos keep wide transparent margins: crop them so
      // the shoe fills the panel.
      final trimmed = decoded.hasAlpha
          ? img.trim(decoded, mode: img.TrimMode.transparent)
          : decoded;
      final image = trimmed.width > 1 && trimmed.height > 1 ? trimmed : decoded;
      final landscape = image.width >= image.height;
      final longest = landscape ? image.width : image.height;
      final resized = longest <= _pdfImageMaxSide
          ? image
          : landscape
              ? img.copyResize(image, width: _pdfImageMaxSide)
              : img.copyResize(image, height: _pdfImageMaxSide);
      final flat = img.Image(width: resized.width, height: resized.height)
        ..clear(
          img.ColorRgb8(
            (backgroundArgb >> 16) & 0xFF,
            (backgroundArgb >> 8) & 0xFF,
            backgroundArgb & 0xFF,
          ),
        );
      img.compositeImage(flat, resized);
      return img.encodeJpg(flat, quality: _pdfImageQuality);
    });
    return jpg == null ? null : pw.MemoryImage(jpg);
  } catch (e) {
    _logger.w('Skipping PDF image $imageUrl: $e');
    return null;
  }
}

/// Writes the PDF to the app cache with a timestamped name
Future<String> _savePdf(pw.Document pdf) async {
  final directory = await getTemporaryDirectory();
  final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  final filePath = '${directory.path}/shox_db_$formattedDate.pdf';
  await File(filePath).writeAsBytes(await pdf.save());
  return filePath;
}

// ========== COVER ==========

pw.Page _buildCoverPage(
  _PdfStyle style, {
  required String name,
  required String email,
  required int totalPairs,
}) {
  final l10n = style.l10n;
  return pw.Page(
    pageTheme: style.pageTheme(background: _cream),
    build: (context) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Spacer(flex: 2),
        pw.Image(style.logo, width: 96, height: 96),
        pw.SizedBox(height: 24),
        pw.Text('Shox', style: style.strong(size: 56)),
        pw.SizedBox(height: 4),
        pw.Text(l10n.pdf_cover_title, style: style.body(size: 20)),
        pw.SizedBox(height: 20),
        pw.Container(width: 48, height: 3, color: _accent),
        pw.SizedBox(height: 20),
        if (name.isNotEmpty) pw.Text(name, style: style.strong(size: 14)),
        if (email.isNotEmpty)
          pw.Text(email, style: style.body(size: 11, color: _muted)),
        pw.SizedBox(height: 28),
        _coverFigure(style, l10n.user_screen_total_shoes, '$totalPairs'),
        pw.Spacer(flex: 3),
        pw.Text(
          l10n.pdf_cover_generated(style.date(DateTime.now())),
          style: style.body(size: 9, color: _muted),
        ),
      ],
    ),
  );
}

// ========== CREDITS ==========

/// Closing page with app version, developer and copyright.
pw.Page _buildCreditsPage(_PdfStyle style, {required String version}) {
  final l10n = style.l10n;
  return pw.Page(
    pageTheme: style.pageTheme(background: _cream),
    build: (context) => pw.Center(
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Image(style.logo, width: 72, height: 72),
          pw.SizedBox(height: 16),
          pw.Text('Shox', style: style.strong(size: 32)),
          pw.SizedBox(height: 4),
          pw.Text(
            l10n.info_screen_version(version),
            style: style.body(size: 11, color: _muted),
          ),
          pw.SizedBox(height: 20),
          pw.Container(width: 48, height: 3, color: _accent),
          pw.SizedBox(height: 20),
          pw.Text(
            l10n.info_screen_made_by(AppConstants.developerName),
            style: style.body(size: 12),
          ),
          pw.SizedBox(height: 10),
          for (final uri in [
            AppConstants.uriGithubProfile,
            AppConstants.uriGithubLink,
          ])
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 4),
              child: pw.UrlLink(
                destination: uri.toString(),
                child: pw.Text(
                  uri.host + uri.path.replaceAll(RegExp(r'/$'), ''),
                  style: style.strong(size: 10, color: _accent),
                ),
              ),
            ),
          pw.SizedBox(height: 28),
          pw.Text(
            l10n.pdf_copyright,
            style: style.body(size: 9, color: _muted),
          ),
        ],
      ),
    ),
  );
}

pw.Widget _coverFigure(_PdfStyle style, String label, String value) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(label.toUpperCase(), style: style.label()),
      pw.SizedBox(height: 4),
      pw.Text(value, style: style.strong(size: 18)),
    ],
  );
}

// ========== SUMMARY ==========

pw.Page _buildSummaryPage(
  BuildContext appContext,
  _PdfStyle style,
  PdfCollectionSummary summary,
) {
  final l10n = style.l10n;
  return pw.Page(
    pageTheme: style.pageTheme(),
    build: (context) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _pageHeader(style),
        pw.SizedBox(height: 24),
        pw.Text(l10n.pdf_summary_title, style: style.strong(size: 26)),
        pw.SizedBox(height: 16),
        pw.Row(
          children: [
            _statTile(
              style,
              l10n.user_screen_total_shoes,
              '${summary.totalPairs}',
            ),
            pw.SizedBox(width: 10),
            _statTile(
              style,
              l10n.user_screen_favorites_count,
              '${summary.favorites}',
            ),
            pw.SizedBox(width: 10),
            _statTile(
              style,
              l10n.database_screen_brands,
              '${summary.brandCount}',
            ),
          ],
        ),
        pw.SizedBox(height: 28),
        _ranking(
          style,
          l10n.pdf_summary_top_brands,
          [for (final e in summary.topBrands) (null, e.key, e.value)],
        ),
        pw.SizedBox(height: 22),
        _ranking(
          style,
          l10n.database_screen_categories,
          [
            for (final e in summary.topCategories)
              (
                null,
                DbLocalizedValues.getCategoryName(appContext, e.key),
                e.value,
              ),
          ],
        ),
        pw.SizedBox(height: 22),
        _ranking(
          style,
          l10n.pdf_summary_top_colors,
          [
            for (final e in summary.topColors)
              (
                Color(e.key),
                DbLocalizedValues.getColorName(appContext, Color(e.key)),
                e.value,
              ),
          ],
        ),
        pw.Spacer(),
        _pageFooter(style, context),
      ],
    ),
  );
}

pw.Widget _statTile(_PdfStyle style, String label, String value) {
  return pw.Expanded(
    child: pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _cream,
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(value, style: style.strong(size: 24, color: _accent)),
          pw.SizedBox(height: 2),
          pw.Text(label.toUpperCase(), style: style.label()),
        ],
      ),
    ),
  );
}

/// Ranked list with bars relative to the first (largest) row;
/// rows are (color dot, name, pairs).
pw.Widget _ranking(
  _PdfStyle style,
  String title,
  List<(Color?, String, int)> rows,
) {
  final max = rows.isEmpty ? 0 : rows.first.$3;
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(title.toUpperCase(), style: style.label()),
      pw.SizedBox(height: 8),
      for (final (color, name, count) in rows)
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 3),
          child: pw.Row(
            children: [
              pw.SizedBox(
                width: 150,
                child: pw.Row(
                  children: [
                    if (color != null) ...[
                      _colorDot(color, size: 9),
                      pw.SizedBox(width: 6),
                    ],
                    pw.Expanded(
                      child: pw.Text(
                        name,
                        style: style.body(size: 10),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(child: _bar(count, max)),
              pw.SizedBox(width: 10),
              pw.SizedBox(
                width: 24,
                child: pw.Text(
                  '$count',
                  style: style.strong(size: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

pw.Widget _bar(int count, int max) {
  final filled = max == 0 ? 0 : (count * 1000 ~/ max);
  return pw.ClipRRect(
    horizontalRadius: 3,
    verticalRadius: 3,
    child: pw.Container(
      height: 6,
      color: _cream,
      child: pw.Row(
        children: [
          if (filled > 0)
            pw.Expanded(flex: filled, child: pw.Container(color: _accent)),
          if (filled < 1000)
            pw.Expanded(flex: 1000 - filled, child: pw.SizedBox()),
        ],
      ),
    ),
  );
}

// ========== SHOE PAGE ==========

pw.Page _buildShoesPage(
  BuildContext appContext,
  _PdfStyle style,
  ShoesModel shoes,
  pw.MemoryImage? photo,
) {
  final l10n = style.l10n;
  final category =
      DbLocalizedValues.getCategoryName(appContext, shoes.category);
  final type = DbLocalizedValues.getTypeName(appContext, shoes.type);
  final extraColors = shoes.colorExtra ?? const <int>[];
  final notes = shoes.notes?.trim() ?? '';

  return pw.Page(
    pageTheme: style.pageTheme(),
    build: (context) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _pageHeader(style),
        pw.SizedBox(height: 18),
        pw.Container(
          height: 380,
          width: double.infinity,
          padding: const pw.EdgeInsets.all(32),
          decoration: pw.BoxDecoration(
            color: _cream,
            borderRadius: pw.BorderRadius.circular(16),
          ),
          alignment: pw.Alignment.center,
          child: photo != null
              ? pw.Image(photo, fit: pw.BoxFit.contain)
              : pw.Image(style.logo, width: 72, height: 72),
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(shoes.brand, style: style.strong(size: 26)),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    '$category · $type',
                    style: style.body(size: 12, color: _muted),
                  ),
                ],
              ),
            ),
            if (shoes.isFavorite)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 4),
                child: pw.SvgImage(svg: _heartSvg, width: 26, height: 26),
              ),
          ],
        ),
        pw.SizedBox(height: 18),
        pw.Row(
          children: [
            _detailTile(
              style,
              l10n.pdf_field_size,
              pw.Text(shoes.size, style: style.strong(size: 14)),
            ),
            pw.SizedBox(width: _tileGap),
            _detailTile(
              style,
              l10n.home_screen_filter_season,
              pw.Text(
                ShoesTextTranslations.translateSeason(
                  shoes.season ?? 'All',
                  style.languageCode,
                ),
                style: style.strong(size: 14),
              ),
            ),
            pw.SizedBox(width: _tileGap),
            _detailTile(
              style,
              l10n.shoes_details_screen_field_added,
              pw.Text(
                style.date(shoes.dateAdded),
                style: style.strong(size: 14),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _detailTile(
              style,
              l10n.pdf_field_color_primary,
              _colorChip(
                style,
                shoes.colorPrimary,
                DbLocalizedValues.getColorName(appContext, shoes.colorPrimary),
              ),
              width: _tileColumnWidth,
            ),
            if (extraColors.isNotEmpty) ...[
              pw.SizedBox(width: _tileGap),
              _detailTile(
                style,
                l10n.pdf_field_extra_colors,
                pw.Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    for (final argb in extraColors)
                      _colorChip(
                        style,
                        Color(argb),
                        DbLocalizedValues.getColorName(appContext, Color(argb)),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
        if (notes.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _detailTile(
                style,
                l10n.pdf_field_notes,
                pw.Text(notes, style: style.body(size: 10), maxLines: 6),
              ),
            ],
          ),
        ],
        pw.Spacer(),
        _pageFooter(style, context),
      ],
    ),
  );
}

/// Left and right page margin.
const double _pageMarginH = 40;

/// Gap between detail tiles.
const double _tileGap = 8;

/// Width of one column in the 3-column tile grid.
final double _tileColumnWidth =
    (PdfPageFormat.a4.width - 2 * _pageMarginH - 2 * _tileGap) / 3;

/// Cream tile with an uppercase label, meant to sit in a Row: it expands,
/// or takes [width] when given (to line up with the 3-column grid).
pw.Widget _detailTile(
  _PdfStyle style,
  String label,
  pw.Widget value, {
  double? width,
}) {
  final tile = pw.Container(
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: _cream,
      borderRadius: pw.BorderRadius.circular(12),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label.toUpperCase(), style: style.label()),
        pw.SizedBox(height: 4),
        value,
      ],
    ),
  );
  return width != null
      ? pw.SizedBox(width: width, child: tile)
      : pw.Expanded(child: tile);
}

pw.Widget _colorChip(_PdfStyle style, Color color, String name) {
  return pw.Row(
    mainAxisSize: pw.MainAxisSize.min,
    children: [
      _colorDot(color, size: 11),
      pw.SizedBox(width: 5),
      pw.Text(name, style: style.strong(size: 12)),
    ],
  );
}

/// Round swatch with a thin outline, so white and cream stay visible.
pw.Widget _colorDot(Color color, {required double size}) {
  return pw.Container(
    width: size,
    height: size,
    decoration: pw.BoxDecoration(
      color: _pdfColor(color),
      shape: pw.BoxShape.circle,
      border: pw.Border.all(color: _outline, width: 0.6),
    ),
  );
}

// ========== HEADER / FOOTER ==========

pw.Widget _pageHeader(_PdfStyle style) {
  return pw.Row(
    children: [
      pw.Image(style.logo, width: 20, height: 20),
      pw.SizedBox(width: 8),
      pw.Text('Shox', style: style.strong(size: 12)),
    ],
  );
}

pw.Widget _pageFooter(_PdfStyle style, pw.Context context) {
  return pw.Container(
    padding: const pw.EdgeInsets.only(top: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(top: pw.BorderSide(color: _outline, width: 0.8)),
    ),
    alignment: pw.Alignment.centerRight,
    child: pw.Text(
      '${context.pageNumber} / ${context.pagesCount}',
      style: style.strong(size: 8, color: _muted),
    ),
  );
}
