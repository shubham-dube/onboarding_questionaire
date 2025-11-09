import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_borders.dart';

enum RecordButtonType { audio, video }

class RecordButton extends StatelessWidget {
  final RecordButtonType type;
  final VoidCallback onPressed;
  final bool isRecording;

  const RecordButton({
    Key? key,
    required this.type,
    required this.onPressed,
    this.isRecording = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.5, -0.5),
            radius: 2.0,
            colors: [
              const Color(0x66222222),
              const Color(0x66999999),
              const Color(0x66222222),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: AppBorders.borderRadiusSM,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == RecordButtonType.audio ? Icons.mic : Icons.videocam,
              color: isRecording ? AppColors.negative : AppColors.text1,
              size: 20,
            ),
            AppSpacing.horizontalSpaceSM,
            Text(
              type == RecordButtonType.audio ? 'Record Audio' : 'Record Video',
              style: AppTextStyles.b1Regular,
            ),
          ],
        ),
      ),
    );
  }
}