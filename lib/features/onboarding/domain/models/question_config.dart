enum QuestionType { experienceSelection, textOnly, multiMedia }

enum AnswerInputType { text, audio, video, experienceIds }

class QuestionConfig {
  final String id;
  final String questionNumber;
  final String question;
  final String? description;
  final QuestionType type;
  final List<AnswerInputType> allowedInputTypes;
  final int? textCharacterLimit;

  const QuestionConfig({
    required this.id,
    required this.questionNumber,
    required this.question,
    this.description,
    required this.type,
    required this.allowedInputTypes,
    this.textCharacterLimit,
  });

  bool get hasTextInput => allowedInputTypes.contains(AnswerInputType.text);
  bool get hasAudioInput => allowedInputTypes.contains(AnswerInputType.audio);
  bool get hasVideoInput => allowedInputTypes.contains(AnswerInputType.video);
  bool get hasExperienceSelection => allowedInputTypes.contains(AnswerInputType.experienceIds);
}

class OnboardingQuestions {
  static const question1 = QuestionConfig(
    id: 'q1',
    questionNumber: '01',
    question: 'What kind of hotspots do you want to host?',
    type: QuestionType.experienceSelection,
    allowedInputTypes: [
      AnswerInputType.experienceIds,
      AnswerInputType.text,
    ],
    textCharacterLimit: 250,
  );

  static const question2 = QuestionConfig(
    id: 'q2',
    questionNumber: '02',
    question: 'Why do you want to host with us?',
    description: 'Tell us about your intent and what motivates you to create experiences.',
    type: QuestionType.multiMedia,
    allowedInputTypes: [
      AnswerInputType.text,
      AnswerInputType.audio,
      AnswerInputType.video,
    ],
    textCharacterLimit: 600,
  );

  static const allQuestions = [question1, question2];
}