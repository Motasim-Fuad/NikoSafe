import '../../models/FAQ/faq_model.dart';


class FaqRepository {
  List<FaqModel> fetchFaqList() {
    return [
      FaqModel(question: "What is NikoSafe?", answer: "NikoSafe is a safety service app..."),
      FaqModel(question: "How do I contact support?", answer: "You can reach us at support@example.com"),
      FaqModel(question: "Is it free to use?", answer: "Yes, it's free for basic usage."),
    ];
  }
}
