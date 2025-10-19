class SuportModel {
  final int? id;
  final String userType;
  final String subject;
  final String description;
  final String priority;
  final String? createdAt;
  final String? updatedAt;

  SuportModel({
    this.id,
    required this.userType,
    required this.subject,
    required this.description,
    required this.priority,
    this.createdAt,
    this.updatedAt,
  });

  factory SuportModel.fromJson(Map<String, dynamic> json) {
    return SuportModel(
      id: json['id'],
      userType: json['user_type'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? 'medium',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_type': userType,
      'subject': subject,
      'description': description,
      'priority': priority,
    };
  }
}
