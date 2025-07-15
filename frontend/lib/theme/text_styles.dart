import 'package:flutter/material.dart';
import 'package:frontend/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle heading = TextStyle(
    fontFamily: 'Retropix',
    fontSize: 40,
    color: AppColors.black,
  );
  static TextStyle headingOutline = TextStyle(
    fontFamily: 'Retropix',
    fontSize: 31,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4
      ..color = AppColors.white,
  );
  static TextStyle onboardingText = TextStyle(
    fontFamily: 'Retropix',
    fontSize: 30,
    color: AppColors.white,
  );
  static TextStyle subheading = TextStyle(
    fontFamily: 'Retropix',
    fontSize: 20,
    color: AppColors.black,
  );
  static TextStyle label1 = TextStyle(
    fontFamily: 'Retropix',
    fontSize: 18,
    color: AppColors.black,
  );

  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static TextStyle subLabel = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static TextStyle subText = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static TextStyle placeholder = GoogleFonts.poppins(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    color: AppColors.darkGray,
  );
}
