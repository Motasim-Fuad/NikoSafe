// models/post_type_model.dart
class PostType {
  final int id;
  final String name;
  final String slug;

  PostType({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory PostType.fromJson(Map<String, dynamic> json) {
    return PostType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class PostTypesResponse {
  final bool success;
  final String message;
  final List<PostType> data;

  PostTypesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PostTypesResponse.fromJson(Map<String, dynamic> json) {
    return PostTypesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<PostType>.from(json['data'].map((x) => PostType.fromJson(x)))
          : [],
    );
  }
}