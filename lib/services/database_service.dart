import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shox/generated/l10n.dart';
import 'package:shox/models/shoes_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:shox/services/shoes_service.dart';
import 'package:shox/theme/app_colors.dart';
import 'package:shox/utils/db_localized_values.dart';

class DatabaseService {
  var logger = Logger();
  final ShoesService _shoesService;

  DatabaseService(this._shoesService);

  // This function retrieves a list of shoes asynchronously and returns the total count of shoes in the list.
  Future<int> getTotalShoesCount() async {
    List<Shoes> shoesList = await _shoesService.getShoes();
    return shoesList.length;
  }

  // This function retrieves a list of shoes asynchronously and returns a map containing the count of shoes for each color.
  Future<Map<String, int>> getShoesCountByColor() async {
    List<Shoes> shoesList = await _shoesService.getShoes();
    Map<String, int> colorCounts = {};

    for (var shoes in shoesList) {
      String colorHex = shoes.color.value.toRadixString(16);
      if (colorCounts.containsKey(colorHex)) {
        colorCounts[colorHex] = colorCounts[colorHex]! + 1;
      } else {
        colorCounts[colorHex] = 1;
      }
    }

    return colorCounts;
  }

  // This function retrieves a list of shoes asynchronously and returns a map containing the count of shoes for each brand.
  Future<Map<String, int>> getShoesCountByBrand() async {
    List<Shoes> shoesList = await _shoesService.getShoes();
    Map<String, int> brandCounts = {};

    for (var shoes in shoesList) {
      if (brandCounts.containsKey(shoes.brand)) {
        brandCounts[shoes.brand] = brandCounts[shoes.brand]! + 1;
      } else {
        brandCounts[shoes.brand] = 1;
      }
    }

    return brandCounts;
  }

  // This function retrieves a list of shoes asynchronously and returns a map containing the count of shoes for each category.
  Future<Map<String, int>> getShoesCountByCategory() async {
    List<Shoes> shoesList = await _shoesService.getShoes();
    Map<String, int> categoryCounts = {};

    for (var shoes in shoesList) {
      if (categoryCounts.containsKey(shoes.category)) {
        categoryCounts[shoes.category] = categoryCounts[shoes.category]! + 1;
      } else {
        categoryCounts[shoes.category] = 1;
      }
    }

    return categoryCounts;
  }

  // This function retrieves a list of shoes asynchronously and returns a map containing the count of shoes for each type.
  Future<Map<String, int>> getShoesCountByType() async {
    List<Shoes> shoesList = await _shoesService.getShoes();
    Map<String, int> typeCounts = {};

    for (var shoes in shoesList) {
      if (typeCounts.containsKey(shoes.type)) {
        typeCounts[shoes.type] = typeCounts[shoes.type]! + 1;
      } else {
        typeCounts[shoes.type] = 1;
      }
    }

    return typeCounts;
  }

  Future<Map<String, dynamic>> getCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    String userName = 'User';
    String userEmail = user.email ?? 'Email';

    if (user.providerData.isNotEmpty &&
        user.providerData[0].providerId == 'google.com') {
      // If the user is logged in via Google, get the name from the Google account
      String? googleUserName = user.displayName;
      if (googleUserName != null) {
        List<String> nameParts = googleUserName.split(" ");
        userName = nameParts.isNotEmpty ? nameParts[0] : 'User';
      }
    } else {
      // Access Firestore to retrieve user data
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        // Handle nullable Map<String, dynamic>
        final userData = docSnapshot.data();
        userName = userData?['name'] ?? 'User';
      }
    }

    return {
      'name': userName,
      'email': userEmail,
    };
  }

  Future<void> generateShoesPdf() async {
    try {
      // Richiedi permesso di scrittura su Android
      if (await Permission.manageExternalStorage.request().isGranted) {
        List<Shoes> shoesList = await _shoesService.getShoes();
        final userData = await getCurrentUserData();
        int totalShoesCount = shoesList.length;

        // Ordina le scarpe per data decrescente (più recente sopra)
        shoesList.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));

        final pdf = pw.Document();

        // Carica i font personalizzati
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

        // Prima pagina
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Stack(
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
            ),
          ),
        );

        // Seconda pagina
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Stack(
              children: [
                pw.Center(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Image(logoImage, height: 320, width: 320),
                      pw.SizedBox(height: 40),
                      pw.Text(
                        S.current.database_pdf_name,
                        style: pw.TextStyle(
                          font: ttfBold,
                          fontSize: 24,
                        ),
                      ),
                      pw.Text(
                        '${userData['name'] ?? 'No Name'}',
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 24,
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
                      pw.Text(
                        '${userData['email'] ?? 'No Email'}',
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 24,
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
                      pw.Text(
                        '$totalShoesCount',
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        for (var shoes in shoesList) {
          final imageBytes = await fetchImage(shoes.imageUrl);
          final image = img.decodeImage(imageBytes)!;
          final pdfImage =
              pw.MemoryImage(Uint8List.fromList(img.encodePng(image)));

          DateTime dateTime = shoes.dateAdded;
          String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

          final shoeDetails = pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'ID',
                style: pw.TextStyle(
                  color: PdfColor.fromInt(AppColors.smoothBlack.value),
                  font: ttfBold,
                  fontSize: 22,
                ),
              ),
              pw.Text(
                shoes.id ?? 'N/A',
                style: pw.TextStyle(
                  color: PdfColor.fromInt(AppColors.smoothBlack.value),
                  font: ttf,
                  fontSize: 20,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        S.current.field_color,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttfBold,
                          fontSize: 22,
                        ),
                      ),
                      pw.Text(
                        DbLocalizedValues.getColorName(shoes.color),
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttf,
                          fontSize: 20,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        S.current.field_brand,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttfBold,
                          fontSize: 22,
                        ),
                      ),
                      pw.Text(
                        shoes.brand,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttf,
                          fontSize: 20,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        S.current.field_size,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttfBold,
                          fontSize: 22,
                        ),
                      ),
                      pw.Text(
                        shoes.size,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttf,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        S.current.field_date,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttfBold,
                          fontSize: 22,
                        ),
                      ),
                      pw.Text(
                        formattedDate,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttf,
                          fontSize: 20,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        S.current.field_category,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttfBold,
                          fontSize: 22,
                        ),
                      ),
                      pw.Text(
                        DbLocalizedValues.getCategoryName(shoes.category),
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttf,
                          fontSize: 20,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        S.current.field_type,
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttfBold,
                          fontSize: 22,
                        ),
                      ),
                      pw.Text(
                        DbLocalizedValues.getTypeName(shoes.type),
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(AppColors.smoothBlack.value),
                          font: ttf,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                S.current.field_notes,
                style: pw.TextStyle(
                  color: PdfColor.fromInt(AppColors.smoothBlack.value),
                  font: ttfBold,
                  fontSize: 22,
                ),
              ),
              pw.Text(
                shoes.notes ?? 'N/A',
                style: pw.TextStyle(
                  color: PdfColor.fromInt(AppColors.smoothBlack.value),
                  font: ttf,
                  fontSize: 20,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );

          pdf.addPage(
            pw.Page(
              build: (pw.Context context) => pw.Center(
                child: pw.Column(
                  children: [
                    pw.SizedBox(height: 8),
                    pw.Image(
                      pdfImage,
                      width: 350,
                      height: 350,
                    ),
                    pw.SizedBox(height: 8),
                    shoeDetails,
                  ],
                ),
              ),
            ),
          );
        }

        // Ottieni la directory Download
        final directory = Directory('/storage/emulated/0/Download');

        // Ottieni la data e l'ora correnti e formatta la stringa
        final now = DateTime.now();
        final dateFormat = DateFormat('yyyyMMdd_HHmmss');
        final formattedGeneratedDate = dateFormat.format(now);

        // Crea il percorso del file con la data di generazione
        final filePath =
            '${directory.path}/Shox_db_$formattedGeneratedDate.pdf';
        final file = File(filePath);

        await file.writeAsBytes(await pdf.save());

        logger.e('PDF saved to $filePath');
      } else {
        // Permesso negato, gestisci l'errore
        logger.e('Storage permission denied');
        throw Exception('Storage permission denied');
      }
    } catch (e) {
      logger.e('Error generating PDF: $e');
      throw Exception('Failed to generate PDF: $e');
    }
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
