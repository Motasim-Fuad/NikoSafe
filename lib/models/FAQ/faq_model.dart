class FaqModel {
  final String question;
  final String answer;
  bool isExpanded;

  FaqModel({required this.question, required this.answer, this.isExpanded = false});
}