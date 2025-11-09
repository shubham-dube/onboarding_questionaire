import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_effects.dart';

class AnswerTextField extends StatelessWidget {
  final String hintText;
  final int characterLimit;
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const AnswerTextField({
    Key? key,
    required this.hintText,
    required this.characterLimit,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite2,
        borderRadius: AppBorders.borderRadiusSM,
      ),
      child: TextField(
        controller: TextEditingController(text: value)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: value.length),
          ),
        onChanged: onChanged,
        enabled: enabled,
        maxLines: null,
        minLines: 5,
        maxLength: characterLimit,
        style: AppTextStyles.h3Regular.copyWith(
          color: enabled ? AppColors.text1 : AppColors.text5,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.h3Regular.copyWith(
            color: AppColors.text5,
          ),
          border: InputBorder.none,
          counterText: '',
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}