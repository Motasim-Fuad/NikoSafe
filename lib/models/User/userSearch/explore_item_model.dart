// Path: models/User/userSearch/explore_item_model.dart
// COMPLETE FILE - Replace entire file

class ExploreItemModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String location;
  final String date;
  final String time;
  final double rating;
  final String category;
  final String phoneNumber;
  final String email;
  final String happyHour;
  final String happyHourTime;
  final String safeEntryInfo;
  final String healthDeptCertified;
  final String cateringInfo;
  final int totalRatings;
  final int totalReviews;
  final List<ReviewModel> reviews;

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

  // FIXED: Proper image URL handling - API returns full URLs
  factory ExploreItemModel.fromApiResponse({
    required dynamic venueData,
    required String category,
    List<ReviewModel>? reviews,
    double? averageRating,
    int? totalReviews,
  }) {
    // Get image URL from API (already includes full URL like http://...)
    String imageUrl = venueData['profile_picture'] ?? '';

    // No need to prepend base URL - API returns complete URLs

    return ExploreItemModel(
      id: venueData['id'].toString(),
      title: venueData['venue_name'] ?? 'Unknown Venue',
      subtitle: _getSubtitleFromCategory(category),
      imageUrl: imageUrl, // Use the corrected URL
      location: venueData['location'] ?? 'Location not available',
      date: 'Open Daily',
      time: venueData['hours_of_operation'] ?? 'Hours not specified',
      rating: averageRating ?? 0.0,
      category: category,
      phoneNumber: venueData['mobile_number'] ?? 'N/A',
      email: venueData['user']?['email'] ?? 'N/A',
      happyHour: 'Check with venue for happy hour details',
      happyHourTime: venueData['hours_of_operation'] ?? 'N/A',
      safeEntryInfo: 'NikoSafe Verified Venue',
      healthDeptCertified: 'Certified Venue',
      cateringInfo: 'Capacity: ${venueData['capacity'] ?? 'N/A'}',
      totalRatings: totalReviews ?? 0,
      totalReviews: totalReviews ?? 0,
      reviews: reviews ?? [],
    );
  }

  static String _getSubtitleFromCategory(String category) {
    switch (category) {
      case 'restaurant':
        return 'Fine Dining Experience';
      case 'bar':
        return 'Drinks & Entertainment';
      case 'club_event':
        return 'Live Events & Entertainment';
      default:
        return 'Hospitality Venue';
    }
  }
}

class ReviewModel {
  final String reviewerName;
  final double rating;
  final String reviewText;
  final String reviewDate;
  final String? venueReply;

  ReviewModel({
    required this.reviewerName,
    required this.rating,
    required this.reviewText,
    required this.reviewDate,
    this.venueReply,
  });

  factory ReviewModel.fromApiResponse(dynamic reviewData) {
    String reviewerName = 'Anonymous';
    if (reviewData['user']?['name'] != null &&
        reviewData['user']['name'].toString().isNotEmpty) {
      reviewerName = reviewData['user']['name'];
    } else if (reviewData['user']?['email'] != null) {
      final email = reviewData['user']['email'] as String;
      reviewerName = email.split('@')[0]
          .replaceAll(RegExp(r'[0-9]'), '')
          .replaceAll('.', ' ')
          .trim();
      if (reviewerName.isEmpty) reviewerName = 'Anonymous';
    }

    return ReviewModel(
      reviewerName: reviewerName,
      rating: (reviewData['rate']?['rate'] ?? 0).toDouble(),
      reviewText: reviewData['text'] ?? 'No review text',
      reviewDate: _formatDate(reviewData['created_at']),
      venueReply: reviewData['venue_reply'],
    );
  }

  static String _formatDate(String? dateString) {
    if (dateString == null) return 'Date not available';
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return '${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'Date not available';
    }
  }
}