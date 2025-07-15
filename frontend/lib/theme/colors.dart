import 'package:flutter/material.dart';

class AppColors {
  static const Color gray = Color(0xFFBFBFBF);
  static const Color lightGray = Color(0xFFF3F3F3);
  static const Color darkGray = Color(0xFF8A8A8A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color cyan = Color(0xFF5ADBE4);
  static const Color ocean = Color(0xFF2C508C);
  static const Color oceanBlue = Color(0xFF56AEFF);
  static const Color indigo = Color(0xFF2E1B5B);
  static const Color navy = Color(0xFF2A4384);
  static const Color blue = Color(0xFF0958B2);
  static const Color skyBlue = Color(0xFFE8EEF8);
  static const Color yellow = Color(0xFFEAAC35);

  // custom gradient - buttons
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF58D8E3), Color(0xFF0958B2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
