class PrivacyOptionsResponse {
  final bool success;
  final String message;
  final String timestamp;
  final int statusCode;
  final List<PrivacyOption> data;

  PrivacyOptionsResponse({
    required this.success,
    required this.message,
    required this.timestamp,
    required this.statusCode,
    required this.data,
  });

  factory PrivacyOptionsResponse.fromJson(Map<String, dynamic> json) {
    return PrivacyOptionsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      statusCode: json['status_code'] ?? 200,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => PrivacyOption.fromJson(item))
          .toList() ?? [],
    );
  }
}

class PrivacyOption {
  final int id;
  final String name;
  final String description;

  PrivacyOption({
    required this.id,
    required this.name,
    required this.description,
  });

  factory PrivacyOption.fromJson(Map<String, dynamic> json) {
    return PrivacyOption(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}