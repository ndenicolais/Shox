import 'dart:io';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:shox/services/database_service.dart';
import 'package:shox/services/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/utils/db_localized_values.dart';

class PdfService {
  final ShoesService _shoesService;
  final DatabaseService _databaseService;
  var logger = Logger();

  PdfService(this._shoesService, this._databaseService);

  Future<void> generateShoesPdf() async {
    try {
      // Request write permission on Android
      if (await Permission.manageExternalStorage.request().isGranted) {
        List<Shoes> shoesList = await _shoesService.getShoes();
        int totalShoesCount = shoesList.length;

        final userData = await _databaseService.getCurrentUserData();
        String userId = userData['userId'] ?? '';

        // Call the function to get the date of creation of the user
        DateTime creationDate =
            await _databaseService.getUserCreationDate(userId);
        String creationDateString =
            DateFormat('dd/MM/yyyy').format(creationDate);

        // Sort shoes by descending date (most recent above)
        shoesList.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));

        final pdf = pw.Document();

        // Upload your own fonts
        final customFont = await rootBundle.load("assets/fonts/Montserrat.ttf");
        final pw.Font ttf = pw.Font.ttf(customFont.buffer.asByteData());
        final customFontBold =
            await rootBundle.load("assets/fonts/Montserrat-Bold.ttf");
        final pw.Font ttfBold = pw.Font.ttf(customFontBold.buffer.asByteData());

        // Logo
        final ByteData data =
            await rootBundle.load('assets/images/app_logo.png');
        final Uint8List bytes = data.buffer.asUint8List();
        final logoImage = pw.MemoryImage(bytes);

        pdf.addPage(_buildFirstPage(logoImage, ttf));
        pdf.addPage(_buildUserPage(logoImage, userData, creationDateString,
            totalShoesCount, ttf, ttfBold));

        for (var shoes in shoesList) {
          await _addShoesPage(pdf, shoes, logoImage, ttf, ttfBold);
        }

        // Save PDF
        await _savePdf(pdf);
      } else {
        throw Exception('Storage permission denied');
      }
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  pw.Page _buildUserPage(
      pw.MemoryImage logoImage,
      Map<String, dynamic> userData,
      String creationDateString,
      int totalShoesCount,
      pw.Font ttf,
      pw.Font ttfBold) {
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
                      ttf, ttfBold),
                  pw.Spacer(),
                  _buildFooter(pageNumber, pagesCount, ttf),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addShoesPage(pw.Document pdf, Shoes shoes,
      pw.MemoryImage logoImage, pw.Font ttf, pw.Font ttfBold) async {
    final imageBytes = await fetchImage(shoes.imageUrl);
    final image = img.decodeImage(imageBytes)!;
    final pdfImage = pw.MemoryImage(Uint8List.fromList(img.encodePng(image)));

    DateTime dateTime = shoes.dateAdded;
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    final shoesDetails = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            _buildShoesDetailsLabels(ttfBold),
            _buildShoesDetailsValues(shoes, formattedDate, ttf),
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
              pw.SizedBox(height: 8),
              pw.Text('ID', style: _headerTextStyle(ttfBold)),
              pw.Text(shoes.id ?? 'N/A', style: _bodyTextStyle(ttf)),
              pw.Image(pdfImage, width: 350, height: 350),
              shoesDetails,
              _buildShoesNotes(shoes, ttfBold, ttf),
              pw.Spacer(),
              _buildFooter(pageNumber, pagesCount, ttf),
            ],
          );
        },
      ),
    );
  }

  pw.Column _buildShoesDetailsLabels(pw.Font ttfBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(S.current.field_date, style: _headerTextStyle(ttfBold)),
        pw.Text(S.current.field_color, style: _headerTextStyle(ttfBold)),
        pw.Text(S.current.field_brand, style: _headerTextStyle(ttfBold)),
        pw.Text(S.current.field_size, style: _headerTextStyle(ttfBold)),
        pw.Text(S.current.field_category, style: _headerTextStyle(ttfBold)),
        pw.Text(S.current.field_type, style: _headerTextStyle(ttfBold)),
      ],
    );
  }

  pw.Column _buildShoesDetailsValues(
      Shoes shoes, String formattedDate, pw.Font ttf) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(formattedDate, style: _bodyTextStyle(ttf)),
        pw.Text(DbLocalizedValues.getColorName(shoes.color),
            style: _bodyTextStyle(ttf)),
        pw.Text(shoes.brand, style: _bodyTextStyle(ttf)),
        pw.Text(shoes.size, style: _bodyTextStyle(ttf)),
        pw.Text(DbLocalizedValues.getCategoryName(shoes.category),
            style: _bodyTextStyle(ttf)),
        pw.Text(DbLocalizedValues.getTypeName(shoes.type),
            style: _bodyTextStyle(ttf)),
      ],
    );
  }

  pw.Column _buildShoesNotes(Shoes shoes, pw.Font ttfBold, pw.Font ttf) {
    return pw.Column(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 28.0),
          child:
              pw.Text(S.current.field_notes, style: _headerTextStyle(ttfBold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 28.0),
          child: pw.Text(shoes.notes ?? 'N/A', style: _bodyTextStyle(ttf)),
        ),
      ],
    );
  }

  pw.TextStyle _headerTextStyle(pw.Font font) {
    return pw.TextStyle(
      color: PdfColor.fromInt(AppColors.smoothBlack.value),
      font: font,
      fontSize: 18,
    );
  }

  pw.TextStyle _bodyTextStyle(pw.Font font) {
    return pw.TextStyle(
      color: PdfColor.fromInt(AppColors.smoothBlack.value),
      font: font,
      fontSize: 18,
    );
  }

  Future<void> _savePdf(pw.Document pdf) async {
    // Get the directory Download
    final directory = Directory('/storage/emulated/0/Download');

    // Get the current date and time and format the string
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyyMMdd_HHmmss');
    final formattedGeneratedDate = dateFormat.format(now);

    // Create the file path with the generation date
    final filePath = '${directory.path}/Shox_db_$formattedGeneratedDate.pdf';
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());
    logger.e('PDF saved to $filePath');
  }

  Future<Uint8List> fetchImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }
}

pw.Page _buildFirstPage(pw.ImageProvider logoImage, pw.Font ttf) {
  return pw.Page(
    build: (pw.Context context) {
      return pw.Stack(
        children: [
          pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Image(logoImage, height: 320, width: 320),
                pw.Text(
                  'Shox',
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(AppColors.smoothBlack.value),
                    font: ttf,
                    fontSize: 80,
                  ),
                ),
                pw.SizedBox(height: 80),
              ],
            ),
          ),
          pw.Align(
            alignment: pw.Alignment.bottomCenter,
            child: pw.Text(
              '© 2024 Nicola De Nicolais',
              style: pw.TextStyle(
                color: PdfColor.fromInt(AppColors.smoothBlack.value),
                fontSize: 20,
                font: ttf,
              ),
            ),
          ),
        ],
      );
    },
  );
}

pw.Widget _buildHeader(pw.ImageProvider logoImage, pw.Font ttf) => pw.Container(
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
                  fontSize: 20,
                  color: PdfColor.fromInt(AppColors.smoothBlack.value),
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

pw.Widget _buildUserInfo(
    Map<String, dynamic> userData,
    String creationDateString,
    int totalShoesCount,
    pw.Font ttf,
    pw.Font ttfBold) {
  return pw.Column(
    children: [
      pw.Text(
        S.current.database_pdf_user,
        style: pw.TextStyle(
          font: ttfBold,
          fontSize: 24,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromInt(AppColors.darkPeach.value),
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        S.current.database_pdf_name,
        style: pw.TextStyle(
          font: ttfBold,
          fontSize: 24,
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        '${userData['name'] ?? 'No Name'}',
        style: pw.TextStyle(
          font: ttf,
          fontSize: 20,
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        S.current.database_pdf_email,
        style: pw.TextStyle(
          font: ttfBold,
          fontSize: 24,
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        '${userData['email'] ?? 'No Email'}',
        style: pw.TextStyle(
          font: ttf,
          fontSize: 20,
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        S.current.database_pdf_date,
        style: pw.TextStyle(
          font: ttfBold,
          fontSize: 24,
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        creationDateString,
        style: pw.TextStyle(
          font: ttf,
          fontSize: 20,
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        S.current.database_pdf_shoes,
        style: pw.TextStyle(
          font: ttfBold,
          fontSize: 24,
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        '$totalShoesCount',
        style: pw.TextStyle(
          font: ttf,
          fontSize: 20,
        ),
      ),
    ],
  );
}

pw.Widget _buildFooter(int pageNumber, int pagesCount, pw.Font ttf) {
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
          '${S.current.database_pdf_page} $pageNumber of $pagesCount',
          style: pw.TextStyle(
            font: ttf,
            fontSize: 12,
            color: PdfColor.fromInt(AppColors.smoothBlack.value),
          ),
        ),
      ],
    ),
  );
}
