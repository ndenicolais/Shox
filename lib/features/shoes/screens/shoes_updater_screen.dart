import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/features/shoes/screens/shoes_form_screen.dart';

class ShoesUpdaterScreen extends StatelessWidget {
  final ShoesModel? shoes;

  const ShoesUpdaterScreen({super.key, this.shoes});

  ShoesModel get _resolvedShoes => shoes ?? Get.arguments as ShoesModel;

  @override
  Widget build(BuildContext context) {
    return ShoesFormScreen(shoes: _resolvedShoes); // EDIT mode
  }
}
