import 'package:eight_club/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/question_config.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_app_bar.dart';
import 'question_renderers/experience_selection_renderer.dart';
import 'question_renderers/multi_media_renderer.dart';

class OnboardingFlowScreen extends StatelessWidget {
  const OnboardingFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(
        onboardingRepository: OnboardingRepository(DioClient()),
      )..add(const LoadQuestion(0)),
      child: const _OnboardingFlowView(),
    );
  }
}

class _OnboardingFlowView extends StatelessWidget {
  const _OnboardingFlowView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base1,
      body: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state.status == OnboardingStatus.success) {
          } else if (state.status == OnboardingStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: AppColors.negative,
              ),
            );
          }
        },
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/onboarding_background.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: AppColors.base1);
                  },
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                // App bar
                BlocBuilder<OnboardingBloc, OnboardingState>(
                  builder: (context, state) {
                    return OnboardingAppBar(
                      currentStep: state.currentQuestionIndex + 1,
                      totalSteps: state.questions.length,
                      onBack: state.isFirstQuestion
                          ? () => Navigator.of(context).pop()
                          : () => context.read<OnboardingBloc>().add(const PreviousQuestion()),
                      onClose: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    );
                  },
                ),

                // Question content
                Expanded(
                  child: BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          // Slide and fade transition
                          final offsetAnimation = Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ),
                          );

                          final fadeAnimation = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
                            ),
                          );

                          return SlideTransition(
                            position: offsetAnimation,
                            child: FadeTransition(
                              opacity: fadeAnimation,
                              child: child,
                            ),
                          );
                        },
                        child: _QuestionRenderer(
                          key: ValueKey('question_${state.currentQuestionIndex}'),
                          questionType: state.currentQuestion.type,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionRenderer extends StatelessWidget {
  final QuestionType questionType;

  const _QuestionRenderer({
    super.key,
    required this.questionType,
  });

  @override
  Widget build(BuildContext context) {
    switch (questionType) {
      case QuestionType.experienceSelection:
        return const ExperienceSelectionRenderer();
      case QuestionType.multiMedia:
        return const MultiMediaRenderer();
      case QuestionType.textOnly:
        return const MultiMediaRenderer();
    }
  }
}