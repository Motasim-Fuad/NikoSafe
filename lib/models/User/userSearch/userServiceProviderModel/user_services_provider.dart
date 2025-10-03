class ReviewModel {
  final String reviewerName;
  final double rating;
  final String reviewText;
  final String reviewDate;

  ReviewModel({
    required this.reviewerName,
    required this.rating,
    required this.reviewText,
    required this.reviewDate,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewerName: json['reviewerName'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewText: json['reviewText'] ?? '',
      reviewDate: json['reviewDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'reviewerName': reviewerName,
    'rating': rating,
    'reviewText': reviewText,
    'reviewDate': reviewDate,
  };
}

class UserServiceProvider {
  final String id; // Added unique ID
  final String name;
  final String service;
  final String experience;
  final String rate;
  final String imageUrl;
  final List<String> skills;
  final List<ReviewModel> reviews;
  final double rating;
  final int totalRatings;
  final int totalReviews;
  bool isFavorite; // Added favorite field

  UserServiceProvider({
    required this.id,
    required this.name,
    required this.service,
    required this.experience,
    required this.rate,
    required this.imageUrl,
    required this.skills,
    required this.reviews,
    required this.rating,
    required this.totalRatings,
    required this.totalReviews,
    this.isFavorite = false,
  });

  factory UserServiceProvider.fromJson(Map<String, dynamic> json) {
    return UserServiceProvider(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      service: json['service'] ?? '',
      experience: json['experience'] ?? '',
      rate: json['rate'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList() ?? [],
      reviews: (json['reviews'] as List?)
          ?.map((e) => ReviewModel.fromJson(e))
          .toList() ??
          [],
      rating: (json['rating'] ?? 0).toDouble(),
      totalRatings: json['totalRatings'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'service': service,
    'experience': experience,
    'rate': rate,
    'imageUrl': imageUrl,
    'skills': skills,
    'reviews': reviews.map((e) => e.toJson()).toList(),
    'rating': rating,
    'totalRatings': totalRatings,
    'totalReviews': totalReviews,
    'isFavorite': isFavorite,
  };
}