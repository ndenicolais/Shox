import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shox/common/widgets/toast_widget.dart';
import 'package:shox/screens/home/screens/home_screen.dart';

class GenderSelectionController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<void> saveGenderAndProceed({
    required BuildContext context,
    required String userId,
    required String userEmail,
    required String userName,
    String? userImage,
    required String gender,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'gender': gender,
      });

      _logger.i("Gender '$gender' saved for user: $userEmail");

      if (context.mounted) {
        showSuccessToast(
          context,
          AppLocalizations.of(context)!.gender_selection_toast_success,
        );
        Get.offAll(
          () => const HomeScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      }
    } catch (e) {
      _logger.e("Error saving gender: $e");
      if (context.mounted) {
        showErrorToast(
          context,
          AppLocalizations.of(context)!.gender_selection_toast_error,
        );
      }
    }
  }
}
