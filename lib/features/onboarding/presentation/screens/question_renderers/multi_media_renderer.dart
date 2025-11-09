import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../widgets/improved_text_field.dart';
import '../../widgets/gradient_next_button.dart';
import '../../widgets/media_recording_controls.dart';

class MultiMediaRenderer extends StatelessWidget {
  const MultiMediaRenderer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        // Calculate dynamic min lines based on UI state
        final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
        final hasMediaUI = state.isRecordingAudio ||
            state.isRecordingVideo ||
            state.hasAudioRecording ||
            state.hasVideoRecording;

        // Determine min lines dynamically
        int minLines;
        if (keyboardOpen) {
          minLines = 3; // Minimal when keyboard is open
        } else if (hasMediaUI) {
          minLines = 5; // Medium when media UI is present
        } else {
          minLines = 15; // Full height when nothing else is there
        }

        return Column(
          children: [
            // Scrollable content
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
                                  AppSpacing.verticalSpaceLG,

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

                                  // Description
                                  if (state.currentQuestion.description != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      state.currentQuestion.description!,
                                      style: AppTextStyles.b1Regular.copyWith(
                                        color: AppColors.text3,
                                      ),
                                    ),
                                  ],

                                  AppSpacing.verticalSpaceXL,

                                  // Text field
                                  if (state.currentQuestion.hasTextInput)
                                    ImprovedTextField(
                                      hintText: 'Share your thoughts here...',
                                      characterLimit: state.currentQuestion.textCharacterLimit ?? 600,
                                      value: state.currentAnswer.textAnswer ?? '',
                                      onChanged: (text) {
                                        context.read<OnboardingBloc>().add(UpdateTextAnswer(text));
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

            // Bottom section with media controls and next button
            _BottomMediaControls(),
          ],
        );
      },
    );
  }
}

class _BottomMediaControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        // Determine which buttons to show
        final showAudioButton = state.currentQuestion.hasAudioInput &&
            !state.hasAudioRecording &&
            !state.isRecordingAudio;

        final showVideoButton = state.currentQuestion.hasVideoInput &&
            !state.hasVideoRecording &&
            !state.isRecordingVideo;

        final showMediaButtons = showAudioButton || showVideoButton;

        return Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Recording controls
              if (state.isRecordingAudio)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MediaRecordingControls(
                    type: MediaType.audio,
                    duration: state.audioRecordingDuration,
                    onStop: () {
                      context.read<OnboardingBloc>().add(const StopAudioRecording());
                    },
                    onCancel: () {
                      context.read<OnboardingBloc>().add(const CancelAudioRecording());
                    },
                  ),
                ),

              if (state.isRecordingVideo)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MediaRecordingControls(
                    type: MediaType.video,
                    duration: state.videoRecordingDuration,
                    onStop: () {
                      context.read<OnboardingBloc>().add(const StopVideoRecording());
                    },
                    onCancel: () {
                      context.read<OnboardingBloc>().add(const CancelVideoRecording());
                    },
                  ),
                ),

              // Media previews
              if (state.hasAudioRecording && !state.isRecordingAudio)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MediaPreview(
                    type: MediaType.audio,
                    duration: state.currentAnswer.audioDuration ?? Duration.zero,
                    onDelete: () {
                      context.read<OnboardingBloc>().add(const DeleteAudioRecording());
                    },
                  ),
                ),

              if (state.hasVideoRecording && !state.isRecordingVideo)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MediaPreview(
                    type: MediaType.video,
                    duration: state.currentAnswer.videoDuration ?? Duration.zero,
                    onDelete: () {
                      context.read<OnboardingBloc>().add(const DeleteVideoRecording());
                    },
                  ),
                ),

              // Bottom row with media buttons and next button
              Row(
                children: [
                  // Media buttons container (both in one widget)
                  if (showMediaButtons)
                    _MediaButtonsGroup(
                      showAudioButton: showAudioButton,
                      showVideoButton: showVideoButton,
                      isRecordingAudio: state.isRecordingAudio,
                      isRecordingVideo: state.isRecordingVideo,
                    ),

                  if (showMediaButtons) const SizedBox(width: 12),

                  // Next button (expands to fill remaining space)
                  Expanded(
                    flex: showMediaButtons ? 2 : 1,
                    child: GradientNextButton(
                      onPressed: () {
                        context.read<OnboardingBloc>().add(const NextQuestion());
                      },
                      enabled: state.canProceed,
                      isLoading: state.status == OnboardingStatus.submitting,
                      isExpanded: true,
                      text: state.isLastQuestion ? 'Submit' : 'Next',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MediaButtonsGroup extends StatelessWidget {
  final bool showAudioButton;
  final bool showVideoButton;
  final bool isRecordingAudio;
  final bool isRecordingVideo;

  const _MediaButtonsGroup({
    required this.showAudioButton,
    required this.showVideoButton,
    required this.isRecordingAudio,
    required this.isRecordingVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Audio button
          if (showAudioButton)
            _MediaButton(
              icon: Icons.mic,
              onPressed: () {
                context.read<OnboardingBloc>().add(const StartAudioRecording());
              },
              isRecording: isRecordingAudio,
              borderRadius: showVideoButton
                  ? const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              )
                  : BorderRadius.circular(8),
            ),

          // Divider
          if (showAudioButton && showVideoButton)
            Container(
              width: 1,
              height: 28,
              color: Colors.white.withOpacity(0.08),
            ),

          // Video button
          if (showVideoButton)
            _MediaButton(
              icon: Icons.videocam,
              onPressed: () {
                context.read<OnboardingBloc>().add(const StartVideoRecording());
              },
              isRecording: isRecordingVideo,
              borderRadius: showAudioButton
                  ? const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              )
                  : BorderRadius.circular(8),
            ),
        ],
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isRecording;
  final BorderRadius borderRadius;

  const _MediaButton({
    required this.icon,
    required this.onPressed,
    required this.isRecording,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: isRecording
                  ? const RadialGradient(
                center: Alignment(-0.9, -0.9),
                radius: 2.0,
                colors: [
                  Color(0x66222222), // rgba(34, 34, 34, 0.4)
                  Color(0x66E2E2E2), // rgba(153, 153, 153, 0.4)
                  Color(0x66222222), // rgba(34, 34, 34, 0.4)
                ],
                stops: [0.0, 0.4987, 1.0],
              )
                  : null,
              borderRadius: borderRadius,
            ),
            child: Icon(
              icon,
              color: AppColors.text1 ,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
