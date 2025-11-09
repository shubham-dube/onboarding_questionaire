import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../widgets/audio_preview_widget.dart';
import '../../widgets/audio_recording_widget.dart';
import '../../widgets/improved_text_field.dart';
import '../../widgets/gradient_next_button.dart';
import '../../widgets/media_recording_controls.dart';
import '../../widgets/video_preview_widget.dart';
import '../video_recording_screen.dart';

class MultiMediaRenderer extends StatelessWidget {
  const MultiMediaRenderer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
        final hasMediaUI =
            state.isRecordingAudio ||
            state.hasAudioRecording ||
            state.hasVideoRecording;

        // Calculate minLines based on keyboard and media state
        int minLines;
        if (keyboardOpen) {
          minLines = 3;
        } else if (hasMediaUI) {
          minLines = 5;
        } else {
          minLines = 15;
        }

        return Column(
          children: [
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
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppSpacing.verticalSpaceLG,

                                  // Question section
                                  Text(
                                    state.currentQuestion.questionNumber,
                                    style: AppTextStyles.s1Regular.copyWith(
                                      color: AppColors.text5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.currentQuestion.question,
                                    style: AppTextStyles.h2Bold,
                                  ),
                                  if (state.currentQuestion.description !=
                                      null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      state.currentQuestion.description!,
                                      style: AppTextStyles.b1Regular.copyWith(
                                        color: AppColors.text3,
                                      ),
                                    ),
                                  ],
                                  AppSpacing.verticalSpaceXL,

                                  // Text input
                                  if (state.currentQuestion.hasTextInput)
                                    ImprovedTextField(
                                      key: ValueKey('textfield_$minLines'),
                                      // Force rebuild on minLines change
                                      hintText: 'Share your thoughts here...',
                                      characterLimit:
                                          state
                                              .currentQuestion
                                              .textCharacterLimit ??
                                          600,
                                      value:
                                          state.currentAnswer.textAnswer ?? '',
                                      onChanged: (text) {
                                        context.read<OnboardingBloc>().add(
                                          UpdateTextAnswer(text),
                                        );
                                      },
                                      showCharacterCount: true,
                                      minLines: minLines,
                                    ),

                                  // Media recording controls
                                  if (state.isRecordingAudio) ...[
                                    const SizedBox(height: 16),
                                    AudioRecordingWidget(
                                      duration: state.audioRecordingDuration,
                                      waveformData: state.audioWaveformData,
                                      onStop: () {
                                        context.read<OnboardingBloc>().add(
                                          const StopAudioRecording(),
                                        );
                                      },
                                      onCancel: () {
                                        context.read<OnboardingBloc>().add(
                                          const CancelAudioRecording(),
                                        );
                                      },
                                    ),
                                  ],

                                  // Media previews
                                  if (state.hasAudioRecording &&
                                      !state.isRecordingAudio) ...[
                                    const SizedBox(height: 16),
                                    AudioPreviewWidget(
                                      duration:
                                          state.currentAnswer.audioDuration ??
                                          Duration.zero,
                                      currentPosition:
                                          state.audioPlaybackPosition,
                                      playbackState: state.audioPlaybackState,
                                      onPlay: () {
                                        context.read<OnboardingBloc>().add(
                                          const PlayAudio(),
                                        );
                                      },
                                      onPause: () {
                                        context.read<OnboardingBloc>().add(
                                          const PauseAudio(),
                                        );
                                      },
                                      onSeek: (position) {
                                        context.read<OnboardingBloc>().add(
                                          SeekAudio(position),
                                        );
                                      },
                                      onDelete: () {
                                        context.read<OnboardingBloc>().add(
                                          const DeleteAudioRecording(),
                                        );
                                      },
                                    ),
                                  ],

                                  if (state.hasVideoRecording &&
                                      !state.isRecordingVideo) ...[
                                    const SizedBox(height: 16),
                                    VideoPreviewWidget(
                                      videoPath: state.currentAnswer.videoPath!,
                                      duration:
                                          state.currentAnswer.videoDuration ??
                                          Duration.zero,
                                      onDelete: () {
                                        context.read<OnboardingBloc>().add(
                                          const DeleteVideoRecording(),
                                        );
                                      },
                                    ),
                                  ],
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
        final showAudioButton =
            state.currentQuestion.hasAudioInput &&
            !state.hasAudioRecording &&
            !state.isRecordingAudio;

        final showVideoButton =
            state.currentQuestion.hasVideoInput &&
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
          decoration: BoxDecoration(
            color:
                AppColors
                    .surfaceBlack1, // Add background to prevent transparency
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (showMediaButtons)
                _MediaButtonsGroup(
                  showAudioButton: showAudioButton,
                  showVideoButton: showVideoButton,
                  isRecordingAudio: state.isRecordingAudio,
                  isRecordingVideo: state.isRecordingVideo,
                ),
              if (showMediaButtons) const SizedBox(width: 12),
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

  Future<void> _handleVideoRecording(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VideoRecordingScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      if (context.mounted) {
        context.read<OnboardingBloc>().add(
          SaveVideoRecording(
            videoPath: result['videoPath'] as String,
            duration: result['duration'] as Duration,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showAudioButton)
            _MediaButton(
              icon: Icons.mic,
              onPressed: () {
                context.read<OnboardingBloc>().add(const StartAudioRecording());
              },
              isRecording: isRecordingAudio,
              borderRadius:
                  showVideoButton
                      ? const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      )
                      : BorderRadius.circular(8),
            ),
          if (showAudioButton && showVideoButton)
            Container(
              width: 1,
              height: 28,
              color: Colors.white.withOpacity(0.08),
            ),
          if (showVideoButton)
            _MediaButton(
              icon: Icons.videocam,
              onPressed: () => _handleVideoRecording(context),
              isRecording: isRecordingVideo,
              borderRadius:
                  showAudioButton
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
              gradient:
                  isRecording
                      ? const RadialGradient(
                        center: Alignment(-0.9, -0.9),
                        radius: 2.0,
                        colors: [
                          Color(0x66222222),
                          Color(0x66E2E2E2),
                          Color(0x66222222),
                        ],
                        stops: [0.0, 0.4987, 1.0],
                      )
                      : null,
              borderRadius: borderRadius,
            ),
            child: Icon(icon, color: AppColors.text1, size: 20),
          ),
        ),
      ),
    );
  }
}
