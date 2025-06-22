class ExploreItemModel {
  final String id;
  final String title;
  final String subtitle; // Can be used for the descriptive text under the title
  final String imageUrl;
  final String location;
  final String date; // Not directly used in the new design, but keep if needed elsewhere
  final String time; // Not directly used in the new design, but keep if needed elsewhere
  final double rating;
  final String category; // restaurant | bar | club_event
  final String phoneNumber; // New
  final String email; // New
  final String happyHour; // New
  final String happyHourTime; // New
  final String safeEntryInfo; // New
  final String healthDeptCertified; // Ne
  final String cateringInfo; // New
  final int totalRatings; // New
  final int totalReviews; // New
  final List<ReviewModel> reviews; // New - a list of individual reviews

  ExploreItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.location,
    required this.date,
    required this.time,
    required this.rating,
    required this.category,
    required this.phoneNumber,
    required this.email,
    required this.happyHour,
    required this.happyHourTime,
    required this.safeEntryInfo,
    required this.healthDeptCertified,
    required this.cateringInfo,
    required this.totalRatings,
    required this.totalReviews,
    required this.reviews,
  });
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
}