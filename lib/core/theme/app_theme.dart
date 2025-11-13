import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'app_borders.dart';
import 'app_effects.dart';

class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.base1,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryAccent,
        secondary: AppColors.secondaryAccent,
        surface: AppColors.base1,
        error: AppColors.negative,
        onPrimary: AppColors.text1,
        onSecondary: AppColors.text1,
        onSurface: AppColors.text1,
        onError: AppColors.text1,
      ),
      textTheme: AppTextStyles.textTheme,
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      dividerTheme: _dividerTheme,
      extensions: [
        AppColorsExtension.light,
        AppSpacingExtension(),
        AppBordersExtension(),
        AppEffectsExtension(),
      ],
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.base1,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryAccent,
        secondary: AppColors.secondaryAccent,
        surface: AppColors.base1,
        background: AppColors.base1,
        error: AppColors.negative,
        onPrimary: AppColors.text1,
        onSecondary: AppColors.text1,
        onSurface: AppColors.text1,
        onBackground: AppColors.text1,
        onError: AppColors.text1,
      ),
      textTheme: AppTextStyles.textTheme,
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      dividerTheme: _dividerTheme,
      extensions: [
        AppColorsExtension.dark,
        AppSpacingExtension(),
        AppBordersExtension(),
        AppEffectsExtension(),
      ],
    );
  }

  // AppBar Theme
  static AppBarTheme get _appBarTheme => AppBarTheme(
    elevation: 0,
    backgroundColor: AppColors.base1,
    foregroundColor: AppColors.text1,
    centerTitle: false,
    titleTextStyle: AppTextStyles.h2Bold,
    iconTheme: IconThemeData(color: AppColors.text1),
  );

  // Elevated Button Theme
  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: AppColors.text1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.b1Bold,
          elevation: 0,
        ),
      );

  // Outlined Button Theme
  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: BorderSide(color: AppColors.border1, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.b1Bold,
        ),
      );

  // Text Button Theme
  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryAccent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: AppTextStyles.b1Bold,
    ),
  );

  // Input Decoration Theme
  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceWhite1,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.border1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.border1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primaryAccent, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.negative),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: AppTextStyles.b1Regular.copyWith(color: AppColors.text4),
  );

  // Card Theme
  static CardTheme get _cardTheme => CardTheme(
    color: AppColors.surfaceWhite1,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: AppColors.border1),
    ),
    margin: const EdgeInsets.all(0),
  );

  // Divider Theme
  static DividerThemeData get _dividerTheme => DividerThemeData(
    color: AppColors.border1,
    thickness: 1,
    space: 1,
  );
}