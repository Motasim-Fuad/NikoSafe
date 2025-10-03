class PollModel {
  final String title;
  final List<String> options;
  final String? text;
  final String postType;

  PollModel({
    required this.title,
    required this.options,
    this.text,
    this.postType = '2', // Assuming poll type is 2
  });

  factory PollModel.fromJson(Map<String, dynamic> json) {
    return PollModel(
      title: json['poll_title'] ?? '',
      options: json['poll_options'] != null
          ? List<String>.from(json['poll_options'])
          : [],
      text: json['text'],
      postType: json['post_type']?.toString() ?? '2',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_type': postType,
      'poll_title': title,
      'poll_options': options,
      'text': text ?? 'Choose wisely!',
    };
  }

  @override
  String toString() {
    return 'PollModel(title: $title, options: $options, postType: $postType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PollModel &&
        other.title == title &&
        other.postType == postType;
  }

  @override
  int get hashCode => title.hashCode ^ postType.hashCode;
}

// Poll option model for API response
class PollOption {
  final int id;
  final String option;
  final int voteCount;
  final int votePercentage;

  PollOption({
    required this.id,
    required this.option,
    required this.voteCount,
    required this.votePercentage,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'] ?? 0,
      option: json['option'] ?? '',
      voteCount: json['vote_count'] ?? 0,
      votePercentage: json['vote_percentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'option': option,
      'vote_count': voteCount,
      'vote_percentage': votePercentage,
    };
  }
}

// Response model for poll creation
class CreatePollResponse {
  final bool success;
  final String message;
  final String timestamp;
  final int statusCode;
  final PollData? data;

  CreatePollResponse({
    required this.success,
    required this.message,
    required this.timestamp,
    required this.statusCode,
    this.data,
  });

  factory CreatePollResponse.fromJson(Map<String, dynamic> json) {
    return CreatePollResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      statusCode: json['status_code'] ?? 200,
      data: json['data'] != null
          ? PollData.fromJson(json['data'])
          : null,
    );
  }
}

class PollData {
  final int id;
  final String pollTitle;
  final String text;
  final List<PollOption> pollOptions; // Fixed: Use PollOption objects
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalPollVotes;
  final bool isPoll;

  PollData({
    required this.id,
    required this.pollTitle,
    required this.text,
    required this.pollOptions,
    required this.createdAt,
    required this.updatedAt,
    required this.totalPollVotes,
    required this.isPoll,
  });

  factory PollData.fromJson(Map<String, dynamic> json) {
    return PollData(
      id: json['id'] ?? 0,
      pollTitle: json['poll_title'] ?? '',
      text: json['text'] ?? '',
      // Fixed: Parse poll_options as objects, not strings
      pollOptions: json['poll_options'] != null
          ? (json['poll_options'] as List)
          .map((option) => PollOption.fromJson(option))
          .toList()
          : [],
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      totalPollVotes: json['total_poll_votes'] ?? 0,
      isPoll: json['is_poll'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poll_title': pollTitle,
      'text': text,
      'poll_options': pollOptions.map((option) => option.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'total_poll_votes': totalPollVotes,
      'is_poll': isPoll,
    };
  }
}