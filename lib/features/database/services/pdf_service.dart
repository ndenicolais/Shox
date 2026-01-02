import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shox/features/database/controller/database_controller.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/core/utils/db_localized_values.dart';
import 'package:shox/core/utils/permission_helper.dart';
import 'package:shox/theme/app_font_sizes.dart';

/// Service for generating PDF documents from shoes database
/// This service handles the creation of formatted PDF reports with user data and shoes collection
class PdfService {
  final BuildContext context;
  final DatabaseController _databaseController;

  PdfService(this.context, this._databaseController);

  /// Generate a complete PDF report of all shoes in the database
  ///
  /// Parameters:
  /// - [context]: BuildContext for localization and theme access
  /// - [onProgress]: Callback to report generation progress (0.0 to 1.0)
  ///
  /// Returns: File path of the generated PDF
  ///
  /// Throws: Exception if permission is denied or PDF generation fails
  Future<String> generateShoesPdf(
      BuildContext context, Function(double) onProgress) async {
    try {
      String permissionStatus =
          await requestManageExternalStoragePermission(context);
      if (permissionStatus != 'Permission granted') {
        throw Exception('Permission not granted');
      }

      List<ShoesModel> shoesList = await _databaseController.getShoes();
      int totalShoesCount = shoesList.length;
      shoesList.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      final userData = await _databaseController.getCurrentUserData();
      String userId = userData['userId'] ?? '';
      DateTime creationDate =
          await _databaseController.getUserCreationDate(userId);
      String creationDateString = DateFormat('dd/MM/yyyy').format(creationDate);
      final pdf = pw.Document();
      final customFont = await rootBundle.load("assets/fonts/Montserrat.ttf");
      final pw.Font ttf = pw.Font.ttf(customFont.buffer.asByteData());
      final customFontBold =
          await rootBundle.load("assets/fonts/Montserrat-Bold.ttf");
      final pw.Font ttfBold = pw.Font.ttf(customFontBold.buffer.asByteData());
      final ByteData data = await rootBundle.load('assets/images/app_logo.png');
      final Uint8List bytes = data.buffer.asUint8List();
      final logoImage = pw.MemoryImage(bytes);
      final appLocalizations = AppLocalizations.of(context)!;

      pdf.addPage(_buildFirstPage(logoImage, ttf, appLocalizations));
      onProgress(0.1);
      pdf.addPage(_buildUserPage(logoImage, userData, creationDateString,
          totalShoesCount, ttf, ttfBold, appLocalizations));
      onProgress(0.2);

      for (var i = 0; i < shoesList.length; i++) {
        var shoes = shoesList[i];
        await _addShoesPage(
            context, pdf, shoes, logoImage, ttf, ttfBold, appLocalizations);
        onProgress(0.2 + 0.8 * (i + 1) / shoesList.length);

        double additionalProgress = 0.8 * (i + 1) / shoesList.length;
        onProgress(0.2 + additionalProgress);
      }

      final filePath = await _savePdf(pdf);
      onProgress(1.0);
      return filePath;
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }
}

/// Fetch image from URL and return as bytes
Future<Uint8List> fetchImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

/// Save PDF document to Downloads folder with timestamp
Future<String> _savePdf(pw.Document pdf) async {
  final directory = Directory('/storage/emulated/0/Download');
  final now = DateTime.now();
  final dateFormat = DateFormat('yyyyMMdd_HHmmss');
  final formattedDate = dateFormat.format(now);
  final filePath = '${directory.path}/shox_db_$formattedDate.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  return filePath;
}

pw.TextStyle _headerTextStyle(pw.Font font) {
  return pw.TextStyle(
    color: PdfColor.fromInt(AppColors.darkGray.value),
    font: font,
  );
}

pw.TextStyle _bodyTextStyle(pw.Font font) {
  return pw.TextStyle(
    color: PdfColor.fromInt(AppColors.darkGray.value),
    font: font,
  );
}

pw.Column _buildShoesDetails(
  BuildContext context,
  ShoesModel shoes,
  String formattedDate,
  pw.Font ttf,
  pw.Font ttfBold,
  AppLocalizations localizations,
) {
  return pw.Column(
    children: [
      pw.Text(localizations.pdf_field_date, style: _headerTextStyle(ttfBold)),
      pw.Text(formattedDate, style: _bodyTextStyle(ttf)),
      pw.Text(localizations.pdf_field_color_primary,
          style: _headerTextStyle(ttfBold)),
      pw.Text(DbLocalizedValues.getColorName(context, shoes.colorPrimary),
          style: _bodyTextStyle(ttf)),
      pw.Text(localizations.pdf_field_color_secondary,
          style: _headerTextStyle(ttfBold)),
      pw.Text(
        shoes.colorExtra == Colors.transparent
            ? "-"
            : DbLocalizedValues.getColorName(
                context,
                Color.fromARGB(shoes.colorExtra![0], shoes.colorExtra![1],
                    shoes.colorExtra![2], shoes.colorExtra![3])),
        style: _bodyTextStyle(ttf),
      ),
      pw.Text(localizations.pdf_field_brand, style: _headerTextStyle(ttfBold)),
      pw.Text(shoes.brand, style: _bodyTextStyle(ttf)),
      pw.Text(localizations.pdf_field_size, style: _headerTextStyle(ttfBold)),
      pw.Text(shoes.size, style: _bodyTextStyle(ttf)),
      pw.Text(localizations.pdf_field_category,
          style: _headerTextStyle(ttfBold)),
      pw.Text(DbLocalizedValues.getCategoryName(context, shoes.category),
          style: _bodyTextStyle(ttf)),
      pw.Text(localizations.pdf_field_type, style: _headerTextStyle(ttfBold)),
      pw.Text(DbLocalizedValues.getTypeName(context, shoes.type),
          style: _bodyTextStyle(ttf)),
      pw.Text(localizations.pdf_field_notes, style: _headerTextStyle(ttfBold)),
      pw.Container(
        width: 300,
        child: pw.Text(
          shoes.notes ?? '-',
          style: _bodyTextStyle(ttf),
          textAlign: pw.TextAlign.center,
        ),
      ),
    ],
  );
}

pw.Page _buildFirstPage(
    pw.ImageProvider logoImage, pw.Font ttf, AppLocalizations localizations) {
  return pw.Page(
    build: (pw.Context context) {
      return pw.Stack(
        children: [
          pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Image(logoImage, height: 260, width: 260),
                pw.Text(
                  'Shox',
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.darkGray.value),
                    font: ttf,
                    fontSize: AppFontSizes.titanic,
                  ),
                ),
              ],
            ),
          ),
          pw.Align(
            alignment: pw.Alignment.bottomCenter,
            child: pw.Text(
              localizations.pdf_copyright,
              style: pw.TextStyle(
                color: PdfColor.fromInt(AppColors.darkGray.value),
                fontSize: AppFontSizes.extraSmall,
                font: ttf,
              ),
            ),
          ),
        ],
      );
    },
  );
}

pw.Widget _buildHeader(pw.ImageProvider logoImage, pw.Font ttf) {
  return pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          width: 1,
          color: PdfColor.fromInt(AppColors.darkPeach.value),
        ),
      ),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Text(
              'Shox',
              style: pw.TextStyle(
                font: ttf,
                fontSize: AppFontSizes.medium,
                color: PdfColor.fromInt(AppColors.darkGray.value),
              ),
            ),
            pw.Spacer(),
            pw.Image(logoImage, height: 30, width: 30),
          ],
        ),
        pw.SizedBox(height: 10),
      ],
    ),
  );
}

pw.Page _buildUserPage(
  pw.MemoryImage logoImage,
  Map<String, dynamic> userData,
  String creationDateString,
  int totalShoesCount,
  pw.Font ttf,
  pw.Font ttfBold,
  AppLocalizations localizations,
) {
  return pw.Page(
    build: (pw.Context context) {
      final pageNumber = context.pageNumber;
      final pagesCount = context.pagesCount;
      return pw.Stack(
        children: [
          pw.Center(
            child: pw.Column(
              children: [
                _buildHeader(logoImage, ttf),
                pw.SizedBox(height: 8),
                _buildUserInfo(userData, creationDateString, totalShoesCount,
                    ttf, ttfBold, localizations),
                pw.Spacer(),
                _buildFooter(pageNumber, pagesCount, ttf, localizations),
              ],
            ),
          ),
        ],
      );
    },
  );
}

pw.Widget _buildUserInfo(
  Map<String, dynamic> userData,
  String creationDateString,
  int totalShoesCount,
  pw.Font ttf,
  pw.Font ttfBold,
  AppLocalizations localizations,
) {
  return pw.Column(
    children: [
      pw.Text(
        localizations.database_screen_pdf_user,
        style: pw.TextStyle(
          font: ttfBold,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromInt(AppColors.darkPeach.value),
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        localizations.database_screen_pdf_name,
        style: pw.TextStyle(font: ttfBold),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        '${userData['name'] ?? 'No Name'}',
        style: pw.TextStyle(font: ttf),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        localizations.database_screen_pdf_email,
        style: pw.TextStyle(font: ttfBold),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        '${userData['email'] ?? 'No Email'}',
        style: pw.TextStyle(font: ttf),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        localizations.database_screen_pdf_date,
        style: pw.TextStyle(font: ttfBold),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        creationDateString,
        style: pw.TextStyle(font: ttf),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        localizations.database_screen_pdf_shoes,
        style: pw.TextStyle(font: ttfBold),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        '$totalShoesCount',
        style: pw.TextStyle(font: ttf),
      ),
    ],
  );
}

Future<void> _addShoesPage(
  BuildContext context,
  pw.Document pdf,
  ShoesModel shoes,
  pw.MemoryImage logoImage,
  pw.Font ttf,
  pw.Font ttfBold,
  AppLocalizations localizations,
) async {
  final imageBytes = await fetchImage(shoes.imageUrl);
  final image = img.decodeImage(imageBytes)!;
  final pdfImage = pw.MemoryImage(Uint8List.fromList(img.encodePng(image)));

  DateTime dateTime = shoes.dateAdded;
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

  final shoesDetails = pw.Column(
    children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        children: [
          _buildShoesDetails(
              context, shoes, formattedDate, ttf, ttfBold, localizations),
        ],
      ),
    ],
  );

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        final pageNumber = context.pageNumber;
        final pagesCount = context.pagesCount;
        return pw.Column(
          children: [
            _buildHeader(logoImage, ttf),
            pw.Image(pdfImage, width: 300, height: 300),
            pw.Text(localizations.pdf_field_id,
                style: _headerTextStyle(ttfBold)),
            pw.Text(shoes.id ?? 'N/A', style: _bodyTextStyle(ttf)),
            shoesDetails,
            pw.Spacer(),
            _buildFooter(pageNumber, pagesCount, ttf, localizations),
          ],
        );
      },
    ),
  );
}

pw.Widget _buildFooter(int pageNumber, int pagesCount, pw.Font ttf,
    AppLocalizations localizations) {
  return pw.Container(
    padding: const pw.EdgeInsets.only(top: 10, bottom: 10),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        top: pw.BorderSide(
          width: 1,
          color: PdfColor.fromInt(AppColors.darkPeach.value),
        ),
      ),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Text(
          '${localizations.database_screen_pdf_page} $pageNumber of $pagesCount',
          style: pw.TextStyle(
            font: ttf,
            fontSize: AppFontSizes.extraSmall,
            color: PdfColor.fromInt(AppColors.darkGray.value),
          ),
        ),
      ],
    ),
  );
}
