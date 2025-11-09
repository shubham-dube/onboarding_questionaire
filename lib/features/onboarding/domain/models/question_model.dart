class QuestionModel {
  final String id;
  final String questionNumber;
  final String question;
  final int characterLimit;

  const QuestionModel({
    required this.id,
    required this.questionNumber,
    required this.question,
    required this.characterLimit,
  });
}