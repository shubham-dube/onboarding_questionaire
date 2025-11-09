import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppBorders {
  AppBorders._();

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusCircle = 9999.0;

  // BorderRadius objects
  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderRadiusSM = BorderRadius.all(Radius.circular(radiusSM));
  static const BorderRadius borderRadiusMD = BorderRadius.all(Radius.circular(radiusMD));
  static const BorderRadius borderRadiusLG = BorderRadius.all(Radius.circular(radiusLG));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderRadiusCircle = BorderRadius.all(Radius.circular(radiusCircle));

  // Border sides
  static const BorderSide border1 = BorderSide(color: AppColors.border1, width: 1);
  static const BorderSide border2 = BorderSide(color: AppColors.border2, width: 1);
  static const BorderSide border3 = BorderSide(color: AppColors.border3, width: 1);
}

/// Theme Extension for borders
class AppBordersExtension extends ThemeExtension<AppBordersExtension> {
  const AppBordersExtension();

  @override
  ThemeExtension<AppBordersExtension> copyWith() => this;

  @override
  ThemeExtension<AppBordersExtension> lerp(
      ThemeExtension<AppBordersExtension>? other,
      double t,
      ) {
    return this;
  }
}