part of 'onboarding_bloc.dart';

enum OnboardingStatus { initial, loading, loaded, submitting, success, error }
enum RecordingStatus { idle, recording, completed }

class OnboardingState extends Equatable {
  final OnboardingStatus status;
  final int currentQuestionIndex;
  final List<QuestionConfig> questions;
  final Map<String, OnboardingAnswer> answers;

  // Experience selection state
  final List<ExperienceModel> experiences;
  final bool isLoadingExperiences;

  // Recording state
  final RecordingStatus audioRecordingStatus;
  final RecordingStatus videoRecordingStatus;
  final Duration audioRecordingDuration;
  final Duration videoRecordingDuration;

  final List<double> audioWaveformData;
  final PlaybackState audioPlaybackState;
  final Duration audioPlaybackPosition;

  final String? errorMessage;

  const OnboardingState({
    this.status = OnboardingStatus.initial,
    this.currentQuestionIndex = 0,
    this.questions = OnboardingQuestions.allQuestions,
    this.answers = const {},
    this.experiences = const [],
    this.isLoadingExperiences = false,
    this.audioRecordingStatus = RecordingStatus.idle,
    this.videoRecordingStatus = RecordingStatus.idle,
    this.audioRecordingDuration = Duration.zero,
    this.videoRecordingDuration = Duration.zero,
    this.errorMessage,
    this.audioWaveformData = const [],
    this.audioPlaybackState = PlaybackState.idle,
    this.audioPlaybackPosition = Duration.zero,
  });

  QuestionConfig get currentQuestion => questions[currentQuestionIndex];
  OnboardingAnswer get currentAnswer => answers[currentQuestion.id] ?? OnboardingAnswer(questionId: currentQuestion.id);

  bool get isFirstQuestion => currentQuestionIndex == 0;
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;
  bool get canProceed => currentAnswer.hasAnyAnswer;
  bool get isRecordingAudio => audioRecordingStatus == RecordingStatus.recording;
  bool get isRecordingVideo => videoRecordingStatus == RecordingStatus.recording;
  bool get hasAudioRecording => currentAnswer.hasAudioAnswer;
  bool get hasVideoRecording => currentAnswer.hasVideoAnswer;

  OnboardingState copyWith({
    OnboardingStatus? status,
    int? currentQuestionIndex,
    List<QuestionConfig>? questions,
    Map<String, OnboardingAnswer>? answers,
    List<ExperienceModel>? experiences,
    bool? isLoadingExperiences,
    RecordingStatus? audioRecordingStatus,
    RecordingStatus? videoRecordingStatus,
    Duration? audioRecordingDuration,
    Duration? videoRecordingDuration,
    String? errorMessage,
    List<double>? audioWaveformData,
    PlaybackState? audioPlaybackState,
    Duration? audioPlaybackPosition,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      experiences: experiences ?? this.experiences,
      isLoadingExperiences: isLoadingExperiences ?? this.isLoadingExperiences,
      audioRecordingStatus: audioRecordingStatus ?? this.audioRecordingStatus,
      videoRecordingStatus: videoRecordingStatus ?? this.videoRecordingStatus,
      audioRecordingDuration: audioRecordingDuration ?? this.audioRecordingDuration,
      videoRecordingDuration: videoRecordingDuration ?? this.videoRecordingDuration,
      errorMessage: errorMessage,
      audioWaveformData: audioWaveformData ?? this.audioWaveformData,
      audioPlaybackState: audioPlaybackState ?? this.audioPlaybackState,
      audioPlaybackPosition: audioPlaybackPosition ?? this.audioPlaybackPosition,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentQuestionIndex,
    questions,
    answers,
    experiences,
    isLoadingExperiences,
    audioRecordingStatus,
    videoRecordingStatus,
    audioRecordingDuration,
    videoRecordingDuration,
    errorMessage,
    audioWaveformData,
    audioPlaybackState,
    audioPlaybackPosition,
  ];
}