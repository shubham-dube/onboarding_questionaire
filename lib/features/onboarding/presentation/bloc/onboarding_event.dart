part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

// Navigation events
class LoadQuestion extends OnboardingEvent {
  final int questionIndex;

  const LoadQuestion(this.questionIndex);

  @override
  List<Object?> get props => [questionIndex];
}

class NextQuestion extends OnboardingEvent {
  const NextQuestion();
}

class PreviousQuestion extends OnboardingEvent {
  const PreviousQuestion();
}

class SubmitOnboarding extends OnboardingEvent {
  const SubmitOnboarding();
}

// Experience selection events
class LoadExperiences extends OnboardingEvent {
  const LoadExperiences();
}

class ToggleExperienceSelection extends OnboardingEvent {
  final int experienceId;

  const ToggleExperienceSelection(this.experienceId);

  @override
  List<Object?> get props => [experienceId];
}

// Text input events
class UpdateTextAnswer extends OnboardingEvent {
  final String text;

  const UpdateTextAnswer(this.text);

  @override
  List<Object?> get props => [text];
}

// Audio recording events
class StartAudioRecording extends OnboardingEvent {
  const StartAudioRecording();
}

class StopAudioRecording extends OnboardingEvent {
  const StopAudioRecording();
}

class CancelAudioRecording extends OnboardingEvent {
  const CancelAudioRecording();
}

class DeleteAudioRecording extends OnboardingEvent {
  const DeleteAudioRecording();
}

class PlayAudio extends OnboardingEvent {
  const PlayAudio();
}

class PauseAudio extends OnboardingEvent {
  const PauseAudio();
}

class SeekAudio extends OnboardingEvent {
  final Duration position;

  const SeekAudio(this.position);

  @override
  List<Object?> get props => [position];
}

// Video recording events
class CancelVideoRecording extends OnboardingEvent {
  const CancelVideoRecording();
}

class DeleteVideoRecording extends OnboardingEvent {
  const DeleteVideoRecording();
}

class SaveVideoRecording extends OnboardingEvent {
  final String videoPath;
  final Duration duration;

  const SaveVideoRecording({
    required this.videoPath,
    required this.duration,
  });

  @override
  List<Object?> get props => [videoPath, duration];
}

// Internal update events
class UpdateAudioAmplitude extends OnboardingEvent {
  final double amplitude;

  const UpdateAudioAmplitude(this.amplitude);

  @override
  List<Object?> get props => [amplitude];
}

class UpdateRecordingDuration extends OnboardingEvent {
  const UpdateRecordingDuration();
}

class UpdatePlaybackPosition extends OnboardingEvent {
  final Duration position;

  const UpdatePlaybackPosition(this.position);

  @override
  List<Object?> get props => [position];
}

class UpdatePlaybackState extends OnboardingEvent {
  final PlaybackState playbackState;

  const UpdatePlaybackState(this.playbackState);

  @override
  List<Object?> get props => [playbackState];
}