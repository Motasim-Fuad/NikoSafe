class FaqModel {
  final int id;
  final String question;
  final String answer;
  final bool isActive;
  final int order;
  final String createdAt;
  final String updatedAt;
  bool isExpanded;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.isActive,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    this.isExpanded = false,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      isActive: json['is_active'] ?? false,
      order: json['order'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isExpanded: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'is_active': isActive,
      'order': order,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class FaqResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<FaqModel> results;

  FaqResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) {
    return FaqResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
          ?.map((item) => FaqModel.fromJson(item))
          .toList() ??
          [],
    );
  }
}
