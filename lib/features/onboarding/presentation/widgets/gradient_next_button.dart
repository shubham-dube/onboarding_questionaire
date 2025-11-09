import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_borders.dart';

class GradientNextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final bool isExpanded;
  final String text;
  final Widget? icon;

  const GradientNextButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.isExpanded = false,
    this.text = 'Next',
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 56,
      child: ClipRRect(
        borderRadius: AppBorders.borderRadiusSM,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: enabled ? 20.0 : 10.0,
            sigmaY: enabled ? 20.0 : 10.0,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled && !isLoading ? onPressed : null,
              borderRadius: AppBorders.borderRadiusSM,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: enabled
                        ? [
                      Color(0x33666666), // Darker gray at edges (20% opacity)
                      Color(0x66AAAAAA), // Medium gray (40% opacity)
                      Color(0x66AAAAAA), // Medium gray (40% opacity)
                      Color(0x66AAAAAA), // Medium gray (40% opacity)
                      Color(0x33666666), // Darker gray at edges (20% opacity)
                    ]
                        : [
                      Color(0x0D444444), // Very dimmed dark at edges (5% opacity)
                      Color(0x1A888888), // Dimmed gray (10% opacity)
                      Color(0x26FFFFFF), // Dimmed white at center (15% opacity)
                      Color(0x1A888888), // Dimmed gray (10% opacity)
                      Color(0x0D444444), // Very dimmed dark at edges (5% opacity)
                    ],
                    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                  ),
                  border: Border.all(
                    color: enabled
                        ? Colors.white.withOpacity(0.12)
                        : Colors.white.withOpacity(0.04),
                    width: 1,
                  ),
                  borderRadius: AppBorders.borderRadiusSM,
                ),
                child: Opacity(
                  opacity: enabled ? 1.0 : 0.4,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isExpanded ? 16 : 24,
                    ),
                    child: Row(
                      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.text1),
                            ),
                          )
                        else ...[
                          if (icon != null) ...[
                            icon!,
                            const SizedBox(width: 8),
                          ],
                          Text(
                            text,
                            style: AppTextStyles.b1Regular.copyWith(
                              color: AppColors.text1,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: AppColors.text1,
                            size: 24,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}