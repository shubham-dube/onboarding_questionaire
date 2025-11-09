import 'dart:ui';
import 'package:flutter/material.dart';

class AppEffects {
  AppEffects._();

  // Background blur values
  static const double blurLight = 6.0; // bg-blur12
  static const double blurMedium = 20.0; // bg-blur40
  static const double blurHeavy = 40.0; // bg-blur80

  // Elevation shadows (if needed)
  static List<BoxShadow> get shadowSM => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMD => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowLG => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}

/// Theme Extension for effects
class AppEffectsExtension extends ThemeExtension<AppEffectsExtension> {
  const AppEffectsExtension();

  @override
  ThemeExtension<AppEffectsExtension> copyWith() => this;

  @override
  ThemeExtension<AppEffectsExtension> lerp(
      ThemeExtension<AppEffectsExtension>? other,
      double t,
      ) {
    return this;
  }
}

// Helper widget for backdrop blur
class BlurredContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color? color;
  final BorderRadius? borderRadius;

  const BlurredContainer({
    super.key,
    required this.child,
    this.blur = AppEffects.blurMedium,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}