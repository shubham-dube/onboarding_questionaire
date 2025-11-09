import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Base Colors
  static const Color base1 = Color(0xFF101010);
  static const Color base2 = Color(0xFF151515);

  // Text Colors
  static const Color text1 = Color(0xFFFFFFFF); // 100% opacity
  static const Color text2 = Color(0xB8FFFFFF); // 72% opacity
  static const Color text3 = Color(0x7AFFFFFF); // 48% opacity
  static const Color text4 = Color(0x52FFFFFF); // 32% opacity
  static const Color text5 = Color(0x29FFFFFF); // 16% opacity

  // Surface Colors (White overlays)
  static const Color surfaceWhite1 = Color(0x05FFFFFF); // 2% opacity
  static const Color surfaceWhite2 = Color(0x0DFFFFFF); // 5% opacity

  // Surface Colors (Black overlays)
  static const Color surfaceBlack1 = Color(0xE6101010); // 90% opacity
  static const Color surfaceBlack2 = Color(0xB3101010); // 70% opacity
  static const Color surfaceBlack3 = Color(0x80101010); // 50% opacity

  // Border Colors
  static const Color border1 = Color(0x14FFFFFF); // 8% opacity
  static const Color border2 = Color(0x29FFFFFF); // 16% opacity
  static const Color border3 = Color(0x3DFFFFFF); // 24% opacity

  // Accent Colors
  static const Color primaryAccent = Color(0xFF9196FF);
  static const Color secondaryAccent = Color(0xFF5961FF);

  // Status Colors
  static const Color positive = Color(0xFF63FF60);
  static const Color negative = Color(0xFFC22743);

  // Background Blur Effects
  static const Color bgBlur12 = Color(0x80101010); // 50% opacity + blur(6px)
  static const Color bgBlur40 = Color(0x80101010); // 50% opacity + blur(20px)
  static const Color bgBlur80 = Color(0x80101010); // 50% opacity + blur(40px)
}

/// Theme Extension for additional colors
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color base1;
  final Color base2;
  final Color text1;
  final Color text2;
  final Color text3;
  final Color text4;
  final Color text5;
  final Color surfaceWhite1;
  final Color surfaceWhite2;
  final Color surfaceBlack1;
  final Color surfaceBlack2;
  final Color surfaceBlack3;
  final Color border1;
  final Color border2;
  final Color border3;
  final Color primaryAccent;
  final Color secondaryAccent;
  final Color positive;
  final Color negative;

  const AppColorsExtension({
    required this.base1,
    required this.base2,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
    required this.surfaceWhite1,
    required this.surfaceWhite2,
    required this.surfaceBlack1,
    required this.surfaceBlack2,
    required this.surfaceBlack3,
    required this.border1,
    required this.border2,
    required this.border3,
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.positive,
    required this.negative,
  });

  static const light = AppColorsExtension(
    base1: AppColors.base1,
    base2: AppColors.base2,
    text1: AppColors.text1,
    text2: AppColors.text2,
    text3: AppColors.text3,
    text4: AppColors.text4,
    text5: AppColors.text5,
    surfaceWhite1: AppColors.surfaceWhite1,
    surfaceWhite2: AppColors.surfaceWhite2,
    surfaceBlack1: AppColors.surfaceBlack1,
    surfaceBlack2: AppColors.surfaceBlack2,
    surfaceBlack3: AppColors.surfaceBlack3,
    border1: AppColors.border1,
    border2: AppColors.border2,
    border3: AppColors.border3,
    primaryAccent: AppColors.primaryAccent,
    secondaryAccent: AppColors.secondaryAccent,
    positive: AppColors.positive,
    negative: AppColors.negative,
  );

  static const dark = AppColorsExtension(
    base1: AppColors.base1,
    base2: AppColors.base2,
    text1: AppColors.text1,
    text2: AppColors.text2,
    text3: AppColors.text3,
    text4: AppColors.text4,
    text5: AppColors.text5,
    surfaceWhite1: AppColors.surfaceWhite1,
    surfaceWhite2: AppColors.surfaceWhite2,
    surfaceBlack1: AppColors.surfaceBlack1,
    surfaceBlack2: AppColors.surfaceBlack2,
    surfaceBlack3: AppColors.surfaceBlack3,
    border1: AppColors.border1,
    border2: AppColors.border2,
    border3: AppColors.border3,
    primaryAccent: AppColors.primaryAccent,
    secondaryAccent: AppColors.secondaryAccent,
    positive: AppColors.positive,
    negative: AppColors.negative,
  );

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? base1,
    Color? base2,
    Color? text1,
    Color? text2,
    Color? text3,
    Color? text4,
    Color? text5,
    Color? surfaceWhite1,
    Color? surfaceWhite2,
    Color? surfaceBlack1,
    Color? surfaceBlack2,
    Color? surfaceBlack3,
    Color? border1,
    Color? border2,
    Color? border3,
    Color? primaryAccent,
    Color? secondaryAccent,
    Color? positive,
    Color? negative,
  }) {
    return AppColorsExtension(
      base1: base1 ?? this.base1,
      base2: base2 ?? this.base2,
      text1: text1 ?? this.text1,
      text2: text2 ?? this.text2,
      text3: text3 ?? this.text3,
      text4: text4 ?? this.text4,
      text5: text5 ?? this.text5,
      surfaceWhite1: surfaceWhite1 ?? this.surfaceWhite1,
      surfaceWhite2: surfaceWhite2 ?? this.surfaceWhite2,
      surfaceBlack1: surfaceBlack1 ?? this.surfaceBlack1,
      surfaceBlack2: surfaceBlack2 ?? this.surfaceBlack2,
      surfaceBlack3: surfaceBlack3 ?? this.surfaceBlack3,
      border1: border1 ?? this.border1,
      border2: border2 ?? this.border2,
      border3: border3 ?? this.border3,
      primaryAccent: primaryAccent ?? this.primaryAccent,
      secondaryAccent: secondaryAccent ?? this.secondaryAccent,
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
      ThemeExtension<AppColorsExtension>? other,
      double t,
      ) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      base1: Color.lerp(base1, other.base1, t)!,
      base2: Color.lerp(base2, other.base2, t)!,
      text1: Color.lerp(text1, other.text1, t)!,
      text2: Color.lerp(text2, other.text2, t)!,
      text3: Color.lerp(text3, other.text3, t)!,
      text4: Color.lerp(text4, other.text4, t)!,
      text5: Color.lerp(text5, other.text5, t)!,
      surfaceWhite1: Color.lerp(surfaceWhite1, other.surfaceWhite1, t)!,
      surfaceWhite2: Color.lerp(surfaceWhite2, other.surfaceWhite2, t)!,
      surfaceBlack1: Color.lerp(surfaceBlack1, other.surfaceBlack1, t)!,
      surfaceBlack2: Color.lerp(surfaceBlack2, other.surfaceBlack2, t)!,
      surfaceBlack3: Color.lerp(surfaceBlack3, other.surfaceBlack3, t)!,
      border1: Color.lerp(border1, other.border1, t)!,
      border2: Color.lerp(border2, other.border2, t)!,
      border3: Color.lerp(border3, other.border3, t)!,
      primaryAccent: Color.lerp(primaryAccent, other.primaryAccent, t)!,
      secondaryAccent: Color.lerp(secondaryAccent, other.secondaryAccent, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
    );
  }
}

// Extension method for easy access
extension AppColorsContext on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}