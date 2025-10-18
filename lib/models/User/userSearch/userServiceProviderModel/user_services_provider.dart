// models/User/userSearch/userServiceProviderModel/service_provider_model.dart

class ServiceProviderModel {
  final int id;
  final String fullName;
  final String designation;
  final String? profilePicture;
  final String location;
  final int serviceRadius;
  final String averageRating;
  final int totalReviews;
  final String desiredPayRate;
  bool isSaved;

  ServiceProviderModel({
    required this.id,
    required this.fullName,
    required this.designation,
    this.profilePicture,
    required this.location,
    required this.serviceRadius,
    required this.averageRating,
    required this.totalReviews,
    required this.desiredPayRate,
    this.isSaved = false,
  });

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      designation: json['designation'] ?? '',
      profilePicture: json['profile_picture'],
      location: json['location'] ?? '',
      serviceRadius: json['service_radius'] ?? 0,
      averageRating: json['average_rating']?.toString() ?? '0.0',
      totalReviews: json['total_reviews'] ?? 0,
      desiredPayRate: json['desired_pay_rate']?.toString() ?? '0',
      isSaved: json['is_saved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'designation': designation,
      'profile_picture': profilePicture,
      'location': location,
      'service_radius': serviceRadius,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'desired_pay_rate': desiredPayRate,
      'is_saved': isSaved,
    };
  }
}

class ServiceProviderDetailModel {
  final int id;
  final String fullName;
  final String designation;
  final String? profilePicture;
  final String? email;
  final String phoneNumber;
  final String location;
  final int serviceRadius;
  final String jobTitle;
  final String aboutMe;
  final List<String> skills;
  final List<String> certificates;
  final int yearsOfExperience;
  final String desiredPayRate;
  final String averageRating;
  final int totalReviews;
  bool isSaved;
  final List<dynamic> availabilities;
  final List<ReviewModel> recentReviews;

  ServiceProviderDetailModel({
    required this.id,
    required this.fullName,
    required this.designation,
    this.profilePicture,
    this.email,
    required this.phoneNumber,
    required this.location,
    required this.serviceRadius,
    required this.jobTitle,
    required this.aboutMe,
    required this.skills,
    required this.certificates,
    required this.yearsOfExperience,
    required this.desiredPayRate,
    required this.averageRating,
    required this.totalReviews,
    this.isSaved = false,
    required this.availabilities,
    required this.recentReviews,
  });

  factory ServiceProviderDetailModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderDetailModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      designation: json['designation'] ?? '',
      profilePicture: json['profile_picture'],
      email: json['email'],
      phoneNumber: json['phone_number'] ?? '',
      location: json['location'] ?? '',
      serviceRadius: json['service_radius'] ?? 0,
      jobTitle: json['job_title'] ?? '',
      aboutMe: json['about_me'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      certificates: List<String>.from(json['certificates'] ?? []),
      yearsOfExperience: json['years_of_experience'] ?? 0,
      desiredPayRate: json['desired_pay_rate']?.toString() ?? '0',
      averageRating: json['average_rating']?.toString() ?? '0.0',
      totalReviews: json['total_reviews'] ?? 0,
      isSaved: json['is_saved'] ?? false,
      availabilities: json['availabilities'] ?? [],
      recentReviews: (json['recent_reviews'] as List?)
          ?.map((e) => ReviewModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

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
      reviewerName: json['reviewer_name'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewText: json['review_text'] ?? '',
      reviewDate: json['review_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'reviewer_name': reviewerName,
    'rating': rating,
    'review_text': reviewText,
    'review_date': reviewDate,
  };
}

class DesignationModel {
  final int id;
  final String name;
  final String slug;

  DesignationModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory DesignationModel.fromJson(Map<String, dynamic> json) {
    return DesignationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
  };
}