import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/models/experience_model.dart';

class ExperienceCard extends StatefulWidget {
  final ExperienceModel experience;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const ExperienceCard({
    Key? key,
    required this.experience,
    required this.isSelected,
    required this.onTap,
    this.index = 0,
  }) : super(key: key);

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(ExperienceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getRotation() {
    final rotations = [-3.0, 3.0, 0.0, -3.0, 0.0];
    return rotations[widget.index % rotations.length];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Transform.rotate(
              angle: _getRotation() * 3.14159 / 180,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: widget.isSelected
                      ? Border.all(
                    color: Colors.transparent,
                    width: 3,
                  )
                      : Border.all(
                    color: Colors.transparent,
                    width: 3,
                  ),
                ),
                child: Stack(
                  children: [
                    // Background image or placeholder
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: widget.experience.imageUrl != null
                          ? ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.grey,
                          widget.isSelected
                              ? BlendMode.dst
                              : BlendMode.saturation,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.experience.imageUrl!,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.surfaceWhite1,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                AlwaysStoppedAnimation<Color>(
                                  AppColors.text3,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Container(
                                color: AppColors.surfaceWhite1,
                                child: Center(
                                  child: Text(
                                    widget.experience.name,
                                    style:
                                    AppTextStyles.b2Bold.copyWith(
                                      color: AppColors.text3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                        ),
                      )
                          : Container(
                        color: AppColors.surfaceWhite1,
                        child: Center(
                          child: Text(
                            widget.experience.name,
                            style: AppTextStyles.b2Bold.copyWith(
                              color: AppColors.text3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}