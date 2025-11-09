enum AnswerType { text, audio, video }

class AnswerModel {
  final String questionId;
  final AnswerType type;
  final String? textAnswer;
  final String? audioPath;
  final String? videoPath;
  final Duration? audioDuration;
  final Duration? videoDuration;

  const AnswerModel({
    required this.questionId,
    required this.type,
    this.textAnswer,
    this.audioPath,
    this.videoPath,
    this.audioDuration,
    this.videoDuration,
  });

  AnswerModel copyWith({
    String? questionId,
    AnswerType? type,
    String? textAnswer,
    String? audioPath,
    String? videoPath,
    Duration? audioDuration,
    Duration? videoDuration,
  }) {
    return AnswerModel(
      questionId: questionId ?? this.questionId,
      type: type ?? this.type,
      textAnswer: textAnswer ?? this.textAnswer,
      audioPath: audioPath ?? this.audioPath,
      videoPath: videoPath ?? this.videoPath,
      audioDuration: audioDuration ?? this.audioDuration,
      videoDuration: videoDuration ?? this.videoDuration,
    );
  }

  bool get hasTextAnswer => textAnswer != null && textAnswer!.isNotEmpty;
  bool get hasAudioAnswer => audioPath != null;
  bool get hasVideoAnswer => videoPath != null;
  bool get hasAnyAnswer => hasTextAnswer || hasAudioAnswer || hasVideoAnswer;
}