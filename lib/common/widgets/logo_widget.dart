import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String? semanticLabel;

  const LogoWidget({
    super.key,
    this.width,
    this.height,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/app_logo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
      semanticLabel: semanticLabel,
    );
  }
}
