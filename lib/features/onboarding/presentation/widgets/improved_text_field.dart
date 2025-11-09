import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_borders.dart';

class ImprovedTextField extends StatefulWidget {
  final String hintText;
  final int characterLimit;
  final String value;
  final ValueChanged<String> onChanged;
  final bool showCharacterCount;
  final int minLines;

  const ImprovedTextField({
    Key? key,
    required this.hintText,
    required this.characterLimit,
    required this.value,
    required this.onChanged,
    this.showCharacterCount = false,
    this.minLines = 5,
  }) : super(key: key);

  @override
  State<ImprovedTextField> createState() => _ImprovedTextFieldState();
}

class _ImprovedTextFieldState extends State<ImprovedTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(ImprovedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // This allows tapping inside the TextField to work normally
      },
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        maxLines: null,
        minLines: widget.minLines,
        maxLength: widget.characterLimit,
        style: AppTextStyles.h3Regular,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.h3Regular.copyWith(
            color: AppColors.text5,
          ),
          filled: true,
          fillColor: AppColors.surfaceWhite2,
          border: OutlineInputBorder(
            borderRadius: AppBorders.borderRadiusSM,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppBorders.borderRadiusSM,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppBorders.borderRadiusSM,
            borderSide: BorderSide(
              color: AppColors.primaryAccent,
              width: 1.0, // Reduced stroke width (default is 2.0)
            ),
          ),
          counterText: '',
          isDense: true,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}