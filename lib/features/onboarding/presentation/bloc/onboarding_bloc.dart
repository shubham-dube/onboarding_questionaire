import 'dart:async';
import 'dart:io';
import 'package:eight_club/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/experience_model.dart';
import '../../domain/models/onboarding_answer.dart';
import '../../domain/models/question_config.dart';
import 'package:equatable/equatable.dart';
import '../../domain/services/audio_recording_service.dart';
import '../../domain/services/audio_playback_service.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository _onboardingRepository;
  final AudioRecordingService _audioRecordingService = AudioRecordingService();
  final AudioPlaybackService _audioPlaybackService = AudioPlaybackService();

  Timer? _recordingTimer;
  StreamSubscription<double>? _amplitudeSubscription;
  StreamSubscription<PlaybackState>? _playbackStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;

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
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<SeekAudio>(_onSeekAudio);
    on<StartVideoRecording>(_onStartVideoRecording);
    on<StopVideoRecording>(_onStopVideoRecording);
    on<CancelVideoRecording>(_onCancelVideoRecording);
    on<DeleteVideoRecording>(_onDeleteVideoRecording);
    on<UpdateAudioAmplitude>(_onUpdateAudioAmplitude);
    on<UpdateRecordingDuration>(_onUpdateRecordingDuration);
    on<UpdatePlaybackPosition>(_onUpdatePlaybackPosition);
    on<UpdatePlaybackState>(_onUpdatePlaybackState);
    on<SaveVideoRecording>(_onSaveVideoRecording);
  }

  void _onLoadQuestion(LoadQuestion event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(currentQuestionIndex: event.questionIndex));

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
      print('=== ONBOARDING SUBMISSION ===');
      state.answers.forEach((questionId, answer) {
        print('Question: $questionId');
        print('Answer: ${answer.toJson()}');
      });

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

  Future<void> _onStartAudioRecording(StartAudioRecording event, Emitter<OnboardingState> emit) async {
    final started = await _audioRecordingService.startRecording();

    if (!started) {
      emit(state.copyWith(
        errorMessage: 'Failed to start recording. Please check microphone permissions.',
      ));
      return;
    }

    emit(state.copyWith(
      audioRecordingStatus: RecordingStatus.recording,
      audioRecordingDuration: Duration.zero,
      audioWaveformData: [],
    ));

    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = _audioRecordingService.amplitudeStream.listen((amplitude) {
      add(UpdateAudioAmplitude(amplitude));
    });

    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.audioRecordingStatus == RecordingStatus.recording) {
        add(const UpdateRecordingDuration());
      }
    });
  }

  void _onUpdateAudioAmplitude(UpdateAudioAmplitude event, Emitter<OnboardingState> emit) {
    final currentWaveform = List<double>.from(state.audioWaveformData);
    currentWaveform.add(event.amplitude);

    if (currentWaveform.length > 50) {
      currentWaveform.removeAt(0);
    }

    emit(state.copyWith(audioWaveformData: currentWaveform));
  }

  void _onUpdateRecordingDuration(UpdateRecordingDuration event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
      audioRecordingDuration: state.audioRecordingDuration + const Duration(seconds: 1),
    ));
  }

  Future<void> _onStopAudioRecording(StopAudioRecording event, Emitter<OnboardingState> emit) async {
    _recordingTimer?.cancel();
    await _amplitudeSubscription?.cancel();

    final audioPath = await _audioRecordingService.stopRecording();

    if (audioPath == null) {
      emit(state.copyWith(
        audioRecordingStatus: RecordingStatus.idle,
        errorMessage: 'Failed to save recording',
      ));
      return;
    }

    final updatedAnswer = state.currentAnswer.copyWith(
      audioPath: audioPath,
      audioDuration: state.audioRecordingDuration,
    );
    final updatedAnswers = Map<String, OnboardingAnswer>.from(state.answers);
    updatedAnswers[state.currentQuestion.id] = updatedAnswer;

    emit(state.copyWith(
      audioRecordingStatus: RecordingStatus.completed,
      answers: updatedAnswers,
      audioPlaybackState: PlaybackState.idle,
      audioPlaybackPosition: Duration.zero,
    ));

    try {
      await _audioPlaybackService.loadAudio(audioPath);
    } catch (e) {
      print('Error loading audio for playback: $e');
    }
  }

  Future<void> _onCancelAudioRecording(CancelAudioRecording event, Emitter<OnboardingState> emit) async {
    _recordingTimer?.cancel();
    await _amplitudeSubscription?.cancel();
    await _audioRecordingService.cancelRecording();

    emit(state.copyWith(
      audioRecordingStatus: RecordingStatus.idle,
      audioRecordingDuration: Duration.zero,
      audioWaveformData: [],
    ));
  }

  Future<void> _onDeleteAudioRecording(DeleteAudioRecording event, Emitter<OnboardingState> emit) async {
    await _playbackStateSubscription?.cancel();
    _playbackStateSubscription = null;

    await _positionSubscription?.cancel();
    _positionSubscription = null;

    try {
      await _audioPlaybackService.stop();
    } catch (e) {
      print('Error stopping audio during delete: $e');
    }

    final audioPath = state.currentAnswer.audioPath;
    if (audioPath != null) {
      try {
        final file = File(audioPath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Error deleting audio file: $e');
      }
    }

    final updatedAnswer = state.currentAnswer.copyWith(
      audioPath: null,
      audioDuration: null,
    );
    final updatedAnswers = Map<String, OnboardingAnswer>.from(state.answers);
    updatedAnswers[state.currentQuestion.id] = updatedAnswer;

    emit(state.copyWith(
      audioRecordingStatus: RecordingStatus.idle,
      audioRecordingDuration: Duration.zero,
      audioWaveformData: [],
      audioPlaybackState: PlaybackState.idle,
      audioPlaybackPosition: Duration.zero,
      answers: updatedAnswers,
    ));
  }

  Future<void> _onPlayAudio(PlayAudio event, Emitter<OnboardingState> emit) async {
    try {
      await _audioPlaybackService.play();

      _playbackStateSubscription?.cancel();
      _playbackStateSubscription = _audioPlaybackService.playbackStateStream.listen((playbackState) {
        add(UpdatePlaybackState(playbackState));

        if (playbackState == PlaybackState.completed) {
          add(const PauseAudio());
        }
      });

      _positionSubscription?.cancel();
      _positionSubscription = _audioPlaybackService.positionStream.listen((position) {
        add(UpdatePlaybackPosition(position));
      });

      emit(state.copyWith(audioPlaybackState: PlaybackState.playing));
    } catch (e) {
      print('Error playing audio: $e');
      emit(state.copyWith(
        audioPlaybackState: PlaybackState.idle,
        errorMessage: 'Failed to play audio',
      ));
    }
  }

  void _onUpdatePlaybackPosition(UpdatePlaybackPosition event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(audioPlaybackPosition: event.position));
  }

  void _onUpdatePlaybackState(UpdatePlaybackState event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(audioPlaybackState: event.playbackState));
  }

  Future<void> _onPauseAudio(PauseAudio event, Emitter<OnboardingState> emit) async {
    try {
      await _audioPlaybackService.pause();
      await _positionSubscription?.cancel();
      await _playbackStateSubscription?.cancel();

      emit(state.copyWith(audioPlaybackState: PlaybackState.paused));
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> _onSeekAudio(SeekAudio event, Emitter<OnboardingState> emit) async {
    try {
      await _audioPlaybackService.seek(event.position);
      emit(state.copyWith(audioPlaybackPosition: event.position));
    } catch (e) {
      print('Error seeking audio: $e');
    }
  }

  // Video recording - just marks intent to record
  void _onStartVideoRecording(StartVideoRecording event, Emitter<OnboardingState> emit) {
    // This will be handled by navigation to VideoRecordingScreen
    // The actual recording state is managed in that screen
    emit(state.copyWith(
      videoRecordingStatus: RecordingStatus.idle,
    ));
  }

  // Called after video is recorded and user returns
  void _onSaveVideoRecording(SaveVideoRecording event, Emitter<OnboardingState> emit) {
    final updatedAnswer = state.currentAnswer.copyWith(
      videoPath: event.videoPath,
      videoDuration: event.duration,
    );
    final updatedAnswers = Map<String, OnboardingAnswer>.from(state.answers);
    updatedAnswers[state.currentQuestion.id] = updatedAnswer;

    emit(state.copyWith(
      videoRecordingStatus: RecordingStatus.completed,
      answers: updatedAnswers,
    ));
  }

  void _onStopVideoRecording(StopVideoRecording event, Emitter<OnboardingState> emit) {
    // No longer used - handled by VideoRecordingScreen
  }

  void _onCancelVideoRecording(CancelVideoRecording event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
      videoRecordingStatus: RecordingStatus.idle,
    ));
  }

  Future<void> _onDeleteVideoRecording(DeleteVideoRecording event, Emitter<OnboardingState> emit) async {
    final videoPath = state.currentAnswer.videoPath;
    if (videoPath != null) {
      try {
        final file = File(videoPath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Error deleting video file: $e');
      }
    }

    final updatedAnswer = state.currentAnswer.copyWith(
      videoPath: null,
      videoDuration: null,
    );
    final updatedAnswers = Map<String, OnboardingAnswer>.from(state.answers);
    updatedAnswers[state.currentQuestion.id] = updatedAnswer;

    emit(state.copyWith(
      videoRecordingStatus: RecordingStatus.idle,
      answers: updatedAnswers,
    ));
  }

  @override
  Future<void> close() async {
    _recordingTimer?.cancel();
    await _amplitudeSubscription?.cancel();
    await _playbackStateSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _audioRecordingService.dispose();
    await _audioPlaybackService.dispose();
    return super.close();
  }
}