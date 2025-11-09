import 'dart:async';
import 'package:eight_club/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/answer_model.dart';
import '../../domain/models/experience_model.dart';
import '../../domain/models/onboarding_answer.dart';
import '../../domain/models/question_config.dart';
import '../../domain/models/question_model.dart';
import 'package:equatable/equatable.dart';
part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository _onboardingRepository;
  Timer? _recordingTimer;

  OnboardingBloc({required OnboardingRepository onboardingRepository})
      : _onboardingRepository = onboardingRepository,
        super(const OnboardingState()) {
    on<LoadQuestion>(_onLoadQuestion);
    on<NextQuestion>(_onNextQuestion);
    on<PreviousQuestion>(_onPreviousQuestion);
    on<SubmitOnboarding>(_onSubmitOnboarding);
    on<LoadExperiences>(_onLoadExperiences);
    on<ToggleExperienceSelection>(_onToggleExperienceSelection);
    on<UpdateTextAnswer>(_onUpdateTextAnswer);
    on<StartAudioRecording>(_onStartAudioRecording);
    on<StopAudioRecording>(_onStopAudioRecording);
    on<CancelAudioRecording>(_onCancelAudioRecording);
    on<DeleteAudioRecording>(_onDeleteAudioRecording);
    on<StartVideoRecording>(_onStartVideoRecording);
    on<StopVideoRecording>(_onStopVideoRecording);
    on<CancelVideoRecording>(_onCancelVideoRecording);
    on<DeleteVideoRecording>(_onDeleteVideoRecording);
  }

  void _onLoadQuestion(LoadQuestion event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(currentQuestionIndex: event.questionIndex));

    // Load experiences if it's the experience selection question
    if (state.currentQuestion.hasExperienceSelection && state.experiences.isEmpty) {
      add(const LoadExperiences());
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<OnboardingState> emit) {
    if (!state.canProceed) return;

    if (state.isLastQuestion) {
      add(const SubmitOnboarding());
    } else {
      emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1));

      // Load experiences for next question if needed
      if (state.currentQuestion.hasExperienceSelection && state.experiences.isEmpty) {
        add(const LoadExperiences());
      }
    }
  }

  void _onPreviousQuestion(PreviousQuestion event, Emitter<OnboardingState> emit) {
    if (!state.isFirstQuestion) {
      emit(state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1));
    }
  }

  Future<void> _onSubmitOnboarding(SubmitOnboarding event, Emitter<OnboardingState> emit) async {
    emit(state.copyWith(status: OnboardingStatus.submitting));

    try {
      // Log all answers
      print('=== ONBOARDING SUBMISSION ===');
      state.answers.forEach((questionId, answer) {
        print('Question: $questionId');
        print('Answer: ${answer.toJson()}');
      });

      // TODO: Submit to backend API
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(status: OnboardingStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadExperiences(LoadExperiences event, Emitter<OnboardingState> emit) async {
    emit(state.copyWith(isLoadingExperiences: true));

    try {
      final experiences = await _onboardingRepository.getExperiences();
      emit(state.copyWith(
        experiences: experiences,
        isLoadingExperiences: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingExperiences: false,
        errorMessage: 'Failed to load experiences: $e',
      ));
    }
  }

  void _onToggleExperienceSelection(ToggleExperienceSelection event, Emitter<OnboardingState> emit) {
    final currentAnswer = state.currentAnswer;
    final currentIds = List<int>.from(currentAnswer.selectedExperienceIds ?? []);

    if (currentIds.contains(event.experienceId)) {
      currentIds.remove(event.experienceId);
    } else {
      currentIds.add(event.experienceId);
    }

    final updatedAnswer = currentAnswer.copyWith(selectedExperienceIds: currentIds);
    final updatedAnswers = Map<String, OnboardingAnswer>.from(state.answers);
    updatedAnswers[state.currentQuestion.id] = updatedAnswer;

    emit(state.copyWith(answers: updatedAnswers));
  }

  void _onUpdateTextAnswer(UpdateTextAnswer event, Emitter<OnboardingState> emit) {
    final characterLimit = state.currentQuestion.textCharacterLimit ?? 1000;
    if (event.text.length > characterLimit) return;

    final updatedAnswer = state.currentAnswer.copyWith(textAnswer: event.text);
    final updatedAnswers = Map<String, OnboardingAnswer>.from(state.answers);
    updatedAnswers[state.currentQuestion.id] = updatedAnswer;

    emit(state.copyWith(answers: updatedAnswers));
  }

  void _onStartAudioRecording(StartAudioRecording event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
      audioRecordingStatus: RecordingStatus.recording,
      audioRecordingDuration: Duration.zero,
    ));

    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.audioRecordingStatus == RecordingStatus.recording) {
        emit(state.copyWith(
          audioRecordingDuration: state.audioRecordingDuration + const Duration(seconds: 1),
        ));
      }
    });

    // TODO: Start actual audio recording
  }

  void _onStopAudioRecording(StopAudioRecording event, Emitter<OnboardingState> emit) {
    _recordingTimer?.cancel();

    // TODO: Stop actual recording and get file path
    final audioPath = 'mock/path/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    final updatedAnswer = state.currentAnswer.copyWith(
      audioPath: audioPath,
      audioDuration: state.audioRecordingDuration,
    );
    final updatedAnswers = Map<String, OnboardingAnswer>.from(state.answers);
    updatedAnswers[state.currentQuestion.id] = updatedAnswer;

    emit(state.copyWith(
      audioRecordingStatus: RecordingStatus.completed,
      answers: updatedAnswers,
    ));
  }

  void _onCancelAudioRecording(CancelAudioRecording event, Emitter<OnboardingState> emit) {
    _recordingTimer?.cancel();
    emit(state.copyWith(
      audioRecordingStatus: RecordingStatus.idle,
      audioRecordingDuration: Duration.zero,
    ));
  }

  void _onDeleteAudioRecording(DeleteAudioRecording event, Emitter<OnboardingState> emit) {
    final updatedAnswer = state.currentAnswer.copyWith(
      audioPath: null,
      audioDuration: null,
    );
    final updatedAnswers = Map<String, OnboardingAnswer>.from(state.answers);
    updatedAnswers[state.currentQuestion.id] = updatedAnswer;

    emit(state.copyWith(
      audioRecordingStatus: RecordingStatus.idle,
      audioRecordingDuration: Duration.zero,
      answers: updatedAnswers,
    ));
  }

  void _onStartVideoRecording(StartVideoRecording event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
      videoRecordingStatus: RecordingStatus.recording,
      videoRecordingDuration: Duration.zero,
    ));

    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.videoRecordingStatus == RecordingStatus.recording) {
        emit(state.copyWith(
          videoRecordingDuration: state.videoRecordingDuration + const Duration(seconds: 1),
        ));
      }
    });

    // TODO: Start actual video recording
  }

  void _onStopVideoRecording(StopVideoRecording event, Emitter<OnboardingState> emit) {
    _recordingTimer?.cancel();

    // TODO: Stop actual recording and get file path
    final videoPath = 'mock/path/video_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final updatedAnswer = state.currentAnswer.copyWith(
      videoPath: videoPath,
      videoDuration: state.videoRecordingDuration,
    );
    final updatedAnswers = Map<String, OnboardingAnswer>.from(state.answers);
    updatedAnswers[state.currentQuestion.id] = updatedAnswer;

    emit(state.copyWith(
      videoRecordingStatus: RecordingStatus.completed,
      answers: updatedAnswers,
    ));
  }

  void _onCancelVideoRecording(CancelVideoRecording event, Emitter<OnboardingState> emit) {
    _recordingTimer?.cancel();
    emit(state.copyWith(
      videoRecordingStatus: RecordingStatus.idle,
      videoRecordingDuration: Duration.zero,
    ));
  }

  void _onDeleteVideoRecording(DeleteVideoRecording event, Emitter<OnboardingState> emit) {
    final updatedAnswer = state.currentAnswer.copyWith(
      videoPath: null,
      videoDuration: null,
    );
    final updatedAnswers = Map<String, OnboardingAnswer>.from(state.answers);
    updatedAnswers[state.currentQuestion.id] = updatedAnswer;

    emit(state.copyWith(
      videoRecordingStatus: RecordingStatus.idle,
      videoRecordingDuration: Duration.zero,
      answers: updatedAnswers,
    ));
  }

  @override
  Future<void> close() {
    _recordingTimer?.cancel();
    return super.close();
  }
}