import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../widgets/experience_card.dart';
import '../../widgets/improved_text_field.dart';
import '../../widgets/gradient_next_button.dart';

class ExperienceSelectionRenderer extends StatefulWidget {
  const ExperienceSelectionRenderer({super.key});

  @override
  State<ExperienceSelectionRenderer> createState() =>
      _ExperienceSelectionRendererState();
}

class _ExperienceSelectionRendererState
    extends State<ExperienceSelectionRenderer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _animateToFirstPosition() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check keyboard visibility using MediaQuery
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        // Calculate minLines based on keyboard state
        final minLines = isKeyboardVisible ? 3 : 4;

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
                                  // Question number with animation
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: AppTextStyles.s1Regular.copyWith(
                                      color: AppColors.text5,
                                      fontSize: isKeyboardVisible ? 12 : 14,
                                    ),
                                    child: Text(
                                      state.currentQuestion.questionNumber,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Question text with animation
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: AppTextStyles.h2Bold.copyWith(
                                      fontSize: isKeyboardVisible ? 20 : 28,
                                    ),
                                    child: Text(
                                      state.currentQuestion.question,
                                    ),
                                  ),

                                  AppSpacing.verticalSpaceLG,

                                  // Experience horizontal scroll with fixed height
                                  SizedBox(
                                    height: 96,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: state.isLoadingExperiences
                                          ? Center(
                                        key: const ValueKey('loading_experiences'),
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.primaryAccent,
                                          ),
                                        ),
                                      )
                                          : state.experiences.isEmpty
                                          ? Center(
                                        key: const ValueKey('empty_experiences'),
                                        child: Text(
                                          'No experiences available',
                                          style: AppTextStyles.b1Regular.copyWith(
                                            color: AppColors.text3,
                                          ),
                                        ),
                                      )
                                          : ListView.builder(
                                        key: ValueKey('experiences_${state.experiences.length}'),
                                        controller: _scrollController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: state.experiences.length,
                                        itemBuilder: (context, index) {
                                          final experience = state.experiences[index];
                                          final isSelected = state.currentAnswer
                                              .selectedExperienceIds
                                              ?.contains(experience.id) ??
                                              false;

                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: index < state.experiences.length - 1
                                                  ? 12
                                                  : 0,
                                            ),
                                            child: ExperienceCard(
                                              experience: experience,
                                              isSelected: isSelected,
                                              index: index,
                                              onTap: () {
                                                context.read<OnboardingBloc>().add(
                                                  ToggleExperienceSelection(
                                                      experience.id),
                                                );
                                                // Animate to first position after selection
                                                if (!isSelected) {
                                                  Future.delayed(
                                                    const Duration(milliseconds: 100),
                                                        () => _animateToFirstPosition(),
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  AppSpacing.verticalSpaceLG,

                                  // Description text field
                                  ImprovedTextField(
                                    key: ValueKey('experience_textfield_$minLines'),
                                    hintText: 'Describe your perfect hotspot',
                                    characterLimit:
                                    state.currentQuestion.textCharacterLimit ?? 250,
                                    value: state.currentAnswer.textAnswer ?? '',
                                    onChanged: (text) {
                                      context
                                          .read<OnboardingBloc>()
                                          .add(UpdateTextAnswer(text));
                                    },
                                    showCharacterCount: true,
                                    minLines: minLines,
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