import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_borders.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final bool isExpanded;

  const NextButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isExpanded ? double.infinity : null,
      height: 56,
      child: GestureDetector(
        onTap: enabled && !isLoading ? onPressed : null,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isExpanded ? 16 : 24,
          ),
          decoration: BoxDecoration(
            gradient: enabled
                ? RadialGradient(
              center: const Alignment(-0.5, -0.5),
              radius: 2.0,
              colors: [
                const Color(0x66222222),
                const Color(0x66999999),
                const Color(0x66222222),
              ],
              stops: const [0.0, 0.5, 1.0],
            )
                : null,
            color: enabled ? null : AppColors.surfaceBlack3,
            borderRadius: AppBorders.borderRadiusSM,
          ),
          child: Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.text1),
                  ),
                )
              else ...[
                Text(
                  'Next',
                  style: AppTextStyles.b1Regular.copyWith(
                    color: enabled ? AppColors.text1 : AppColors.text4,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  color: enabled ? AppColors.text1 : AppColors.text4,
                  size: 24,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
