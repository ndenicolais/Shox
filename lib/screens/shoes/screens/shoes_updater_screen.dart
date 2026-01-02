import 'package:flutter/material.dart';
import 'package:shox/features/shoes/models/shoes_model.dart';
import 'package:shox/screens/shoes/screens/shoes_form_screen.dart';

class ShoesUpdaterScreen extends StatelessWidget {
  final ShoesModel shoes;

  const ShoesUpdaterScreen({super.key, required this.shoes});

  @override
  Widget build(BuildContext context) {
    return ShoesFormScreen(shoes: shoes); // EDIT mode
  }
}
