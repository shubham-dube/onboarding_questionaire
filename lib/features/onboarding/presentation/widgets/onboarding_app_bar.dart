import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const OnboardingAppBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: AppColors.base2,
        backgroundBlendMode: BlendMode.srcOver,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: AppColors.text1,
              ),
            ),
          ),

          // Progress indicator
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 39),
              child: _ProgressIndicator(
                currentStep: currentStep,
                totalSteps: totalSteps,
              ),
            ),
          ),

          // Close button
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              child: Icon(
                Icons.close,
                size: 20,
                color: AppColors.text1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _ProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: Stack(
        children: [
          // Background track
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.border2,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // Progress fill
          FractionallySizedBox(
            widthFactor: currentStep / totalSteps,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryAccent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}