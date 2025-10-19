class PrivacyTrmsAbout {
  final bool success;
  final String message;
  final PrivacyTrmsAboutData? data;

  PrivacyTrmsAbout({
    required this.success,
    required this.message,
    this.data,
  });

  factory PrivacyTrmsAbout.fromJson(Map<String, dynamic> json) {
    return PrivacyTrmsAbout(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? PrivacyTrmsAboutData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class PrivacyTrmsAboutData {
  final int id;
  final String settingType;
  final String content;
  final String lastUpdated;

  PrivacyTrmsAboutData({
    required this.id,
    required this.settingType,
    required this.content,
    required this.lastUpdated,
  });

  factory PrivacyTrmsAboutData.fromJson(Map<String, dynamic> json) {
    return PrivacyTrmsAboutData(
      id: json['id'] ?? 0,
      settingType: json['setting_type'] ?? '',
      content: json['content'] ?? '',
      lastUpdated: json['last_updated'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'setting_type': settingType,
      'content': content,
      'last_updated': lastUpdated,
    };
  }
}