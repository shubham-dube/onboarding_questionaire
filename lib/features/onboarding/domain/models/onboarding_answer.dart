class OnboardingAnswer {
  final String questionId;
  final String? textAnswer;
  final List<int>? selectedExperienceIds;
  final String? audioPath;
  final String? videoPath;
  final Duration? audioDuration;
  final Duration? videoDuration;

  const OnboardingAnswer({
    required this.questionId,
    this.textAnswer,
    this.selectedExperienceIds,
    this.audioPath,
    this.videoPath,
    this.audioDuration,
    this.videoDuration,
  });

  OnboardingAnswer copyWith({
    String? questionId,
    String? textAnswer,
    List<int>? selectedExperienceIds,
    String? audioPath,
    String? videoPath,
    Duration? audioDuration,
    Duration? videoDuration,
  }) {
    return OnboardingAnswer(
      questionId: questionId ?? this.questionId,
      textAnswer: textAnswer ?? this.textAnswer,
      selectedExperienceIds: selectedExperienceIds ?? this.selectedExperienceIds,
      audioPath: audioPath ?? this.audioPath,
      videoPath: videoPath ?? this.videoPath,
      audioDuration: audioDuration ?? this.audioDuration,
      videoDuration: videoDuration ?? this.videoDuration,
    );
  }

  bool get hasTextAnswer => textAnswer != null && textAnswer!.trim().isNotEmpty;
  bool get hasExperienceSelection => selectedExperienceIds != null && selectedExperienceIds!.isNotEmpty;
  bool get hasAudioAnswer => audioPath != null;
  bool get hasVideoAnswer => videoPath != null;
  bool get hasAnyAnswer => hasTextAnswer || hasExperienceSelection || hasAudioAnswer || hasVideoAnswer;

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'text_answer': textAnswer,
      'selected_experience_ids': selectedExperienceIds,
      'audio_path': audioPath,
      'video_path': videoPath,
      'audio_duration_seconds': audioDuration?.inSeconds,
      'video_duration_seconds': videoDuration?.inSeconds,
    };
  }
}