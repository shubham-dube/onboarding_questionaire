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

// Video recording events
class StartVideoRecording extends OnboardingEvent {
  const StartVideoRecording();
}

class StopVideoRecording extends OnboardingEvent {
  const StopVideoRecording();
}

class CancelVideoRecording extends OnboardingEvent {
  const CancelVideoRecording();
}

class DeleteVideoRecording extends OnboardingEvent {
  const DeleteVideoRecording();
}