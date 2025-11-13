import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Font Family
  static const String _fontFamily = 'Space Grotesk';

  // Heading Styles
  static const TextStyle h1Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    height: 1.29, // 36/28
    letterSpacing: -0.03 * 28, // -0.03em
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
  );

  static const TextStyle h1Regular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    height: 1.29,
    letterSpacing: -0.03 * 28,
    fontWeight: FontWeight.w400,
    color: AppColors.text1,
  );

  static const TextStyle h2Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    height: 1.33, // 32/24
    letterSpacing: -0.02 * 24,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
  );

  static const TextStyle h2Regular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    height: 1.33,
    letterSpacing: -0.02 * 24,
    fontWeight: FontWeight.w400,
    color: AppColors.text1,
  );

  static const TextStyle h3Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    height: 1.40, // 28/20
    letterSpacing: -0.01 * 20,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
  );

  static const TextStyle h3Regular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    height: 1.40,
    letterSpacing: -0.01 * 20,
    fontWeight: FontWeight.w400,
    color: AppColors.text1,
  );

  // Body Styles
  static const TextStyle b1Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    height: 1.50, // 24/16
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
  );

  static const TextStyle b1Regular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    height: 1.50,
    fontWeight: FontWeight.w400,
    color: AppColors.text1,
  );

  static const TextStyle b2Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 1.43, // 20/14
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
  );

  static const TextStyle b2Regular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    color: AppColors.text1,
  );

  // Subtext Styles
  static const TextStyle s1Bold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 1.33, // 16/12
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
  );

  static const TextStyle s1Regular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    color: AppColors.text1,
  );

  static const TextStyle s2Regular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    height: 1.20, // 12/10
    fontWeight: FontWeight.w400,
    color: AppColors.text1,
  );

  static TextTheme get textTheme => const TextTheme(
    displayLarge: h1Bold,
    displayMedium: h2Bold,
    displaySmall: h3Bold,
    headlineLarge: h1Regular,
    headlineMedium: h2Regular,
    headlineSmall: h3Regular,
    titleLarge: b1Bold,
    titleMedium: b2Bold,
    titleSmall: s1Bold,
    bodyLarge: b1Regular,
    bodyMedium: b2Regular,
    bodySmall: s1Regular,
    labelLarge: b1Bold,
    labelMedium: b2Bold,
    labelSmall: s2Regular,
  );
}

// Extension for easy access to text styles with custom colors
extension TextStyleExtension on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);

  TextStyle get text1 => copyWith(color: AppColors.text1);
  TextStyle get text2 => copyWith(color: AppColors.text2);
  TextStyle get text3 => copyWith(color: AppColors.text3);
  TextStyle get text4 => copyWith(color: AppColors.text4);
  TextStyle get text5 => copyWith(color: AppColors.text5);
}