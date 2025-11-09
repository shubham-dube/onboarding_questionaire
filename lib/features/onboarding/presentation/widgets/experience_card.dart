import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/models/experience_model.dart';

class ExperienceCard extends StatelessWidget {
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

  double _getRotation() {
    final rotations = [-3.0, 3.0, 0.0, -3.0, 0.0];
    return rotations[index % rotations.length];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: _getRotation() * 3.14159 / 180,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: isSelected
                ? Border.all(
              color: Colors.transparent,
              width: 2,
            )
                : null,
          ),
          child: Stack(
            children: [
              // Background image or placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: experience.imageUrl != null
                    ? ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.grey,
                    isSelected ? BlendMode.dst : BlendMode.saturation,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: experience.imageUrl!,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceWhite1,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.text3),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceWhite1,
                      child: Center(
                        child: Text(
                          experience.name,
                          style: AppTextStyles.b2Bold.copyWith(
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
                      experience.name,
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
    );
  }
}