import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../widgets/experience_card.dart';
import '../../widgets/improved_text_field.dart';
import '../../widgets/gradient_next_button.dart';

class ExperienceSelectionRenderer extends StatelessWidget {
  const ExperienceSelectionRenderer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Column(
          children: [
            // Scrollable content area
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // This spacer will push content to bottom
                            const Spacer(),

                            // Actual content
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Question number
                                  Text(
                                    state.currentQuestion.questionNumber,
                                    style: AppTextStyles.s1Regular.copyWith(
                                      color: AppColors.text5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Question text
                                  Text(
                                    state.currentQuestion.question,
                                    style: AppTextStyles.h2Bold,
                                  ),

                                  AppSpacing.verticalSpaceLG,

                                  // Experience horizontal scroll
                                  if (state.isLoadingExperiences)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(40),
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                                        ),
                                      ),
                                    )
                                  else if (state.experiences.isEmpty)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(40),
                                        child: Text(
                                          'No experiences available',
                                          style: AppTextStyles.b1Regular.copyWith(
                                            color: AppColors.text3,
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    SizedBox(
                                      height: 96,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: state.experiences.length,
                                        itemBuilder: (context, index) {
                                          final experience = state.experiences[index];
                                          final isSelected = state.currentAnswer.selectedExperienceIds
                                              ?.contains(experience.id) ??
                                              false;

                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: index < state.experiences.length - 1 ? 12 : 0,
                                            ),
                                            child: ExperienceCard(
                                              experience: experience,
                                              isSelected: isSelected,
                                              index: index,
                                              onTap: () {
                                                context.read<OnboardingBloc>().add(
                                                  ToggleExperienceSelection(experience.id),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                  AppSpacing.verticalSpaceLG,

                                  // Description text field
                                  ImprovedTextField(
                                    hintText: 'Describe your perfect hotspot',
                                    characterLimit: state.currentQuestion.textCharacterLimit ?? 250,
                                    value: state.currentAnswer.textAnswer ?? '',
                                    onChanged: (text) {
                                      context.read<OnboardingBloc>().add(UpdateTextAnswer(text));
                                    },
                                    showCharacterCount: true,
                                    minLines: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom section with Next button
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
                top: 16,
              ),
              child: GradientNextButton(
                onPressed: () {
                  context.read<OnboardingBloc>().add(const NextQuestion());
                },
                enabled: state.canProceed,
                isLoading: state.status == OnboardingStatus.submitting,
                isExpanded: true,
              ),
            ),
          ],
        );
      },
    );
  }
}