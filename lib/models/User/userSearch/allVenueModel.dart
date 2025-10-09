// Path: models/User/userSearch/venue_response_model.dart
// NEW FILE - Create this file

class AllVenueResponseModel {
  int count;
  String? next;
  dynamic previous;
  List<VenueResult> results;

  AllVenueResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory AllVenueResponseModel.fromJson(Map<String, dynamic> json) => AllVenueResponseModel(
    count: json["count"] ?? 0,
    next: json["next"],
    previous: json["previous"],
    results: json["results"] != null
        ? List<VenueResult>.from(json["results"].map((x) => VenueResult.fromJson(x)))
        : [],
  );
}

class VenueResult {
  int id;
  List<HospitalityVenueType> hospitalityVenueType;
  VenueUser user;
  String venueName;
  String mobileNumber;
  String location;
  String hoursOfOperation;
  String capacity;
  String? profilePicture;
  String? resume;
  dynamic qrCode;
  DateTime createdAt;
  DateTime updatedAt;

  VenueResult({
    required this.id,
    required this.hospitalityVenueType,
    required this.user,
    required this.venueName,
    required this.mobileNumber,
    required this.location,
    required this.hoursOfOperation,
    required this.capacity,
    this.profilePicture,
    this.resume,
    this.qrCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VenueResult.fromJson(Map<String, dynamic> json) => VenueResult(
    id: json["id"] ?? 0,
    hospitalityVenueType: json["hospitality_venue_type"] != null
        ? List<HospitalityVenueType>.from(
        json["hospitality_venue_type"].map((x) => HospitalityVenueType.fromJson(x)))
        : [],
    user: VenueUser.fromJson(json["user"] ?? {}),
    venueName: json["venue_name"] ?? "",
    mobileNumber: json["mobile_number"] ?? "",
    location: json["location"] ?? "",
    hoursOfOperation: json["hours_of_operation"] ?? "",
    capacity: json["capacity"] ?? "",
    profilePicture: json["profile_picture"],
    resume: json["resume"],
    qrCode: json["qr_code"],
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : DateTime.now(),
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : DateTime.now(),
  );
}

class HospitalityVenueType {
  int? id;
  String? name;
  String? slug;
  DateTime? createdAt;
  DateTime? updatedAt;

  HospitalityVenueType({
    this.id,
    this.name,
    this.slug,
    this.createdAt,
    this.updatedAt,
  });

  factory HospitalityVenueType.fromJson(Map<String, dynamic> json) => HospitalityVenueType(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
  );
}

class VenueUser {
  int id;
  String name;
  String email;

  VenueUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory VenueUser.fromJson(Map<String, dynamic> json) => VenueUser(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    email: json["email"] ?? "",
  );
}

// ====== REVIEW RESPONSE MODEL ======

class VenueReviewsResponseModel {
  int count;
  String? next;
  dynamic previous;
  List<ReviewResult> results;
  ReviewStatistics statistics;

  VenueReviewsResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    required this.statistics,
  });

  factory VenueReviewsResponseModel.fromJson(Map<String, dynamic> json) => VenueReviewsResponseModel(
    count: json["count"] ?? 0,
    next: json["next"],
    previous: json["previous"],
    results: json["results"] != null
        ? List<ReviewResult>.from(json["results"].map((x) => ReviewResult.fromJson(x)))
        : [],
    statistics: ReviewStatistics.fromJson(json["statistics"] ?? {}),
  );
}

class ReviewResult {
  int id;
  String text;
  RateData rate;
  ReviewVenueData hospitalityVenue;
  ReviewUserData user;
  String? venueReply;
  String? venueRepliedAt;
  DateTime createdAt;
  DateTime updatedAt;

  ReviewResult({
    required this.id,
    required this.text,
    required this.rate,
    required this.hospitalityVenue,
    required this.user,
    this.venueReply,
    this.venueRepliedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewResult.fromJson(Map<String, dynamic> json) => ReviewResult(
    id: json["id"] ?? 0,
    text: json["text"] ?? "",
    rate: RateData.fromJson(json["rate"] ?? {}),
    hospitalityVenue: ReviewVenueData.fromJson(json["hospitality_venue"] ?? {}),
    user: ReviewUserData.fromJson(json["user"] ?? {}),
    venueReply: json["venue_reply"],
    venueRepliedAt: json["venue_replied_at"],
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : DateTime.now(),
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : DateTime.now(),
  );
}

class RateData {
  int id;
  int rate;
  DateTime createdAt;
  DateTime updatedAt;

  RateData({
    required this.id,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RateData.fromJson(Map<String, dynamic> json) => RateData(
    id: json["id"] ?? 0,
    rate: json["rate"] ?? 0,
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : DateTime.now(),
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : DateTime.now(),
  );
}

class ReviewVenueData {
  int id;
  String venueName;

  ReviewVenueData({
    required this.id,
    required this.venueName,
  });

  factory ReviewVenueData.fromJson(Map<String, dynamic> json) => ReviewVenueData(
    id: json["id"] ?? 0,
    venueName: json["venue_name"] ?? "",
  );
}

class ReviewUserData {
  int id;
  String name;
  String email;

  ReviewUserData({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ReviewUserData.fromJson(Map<String, dynamic> json) => ReviewUserData(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    email: json["email"] ?? "",
  );
}

class ReviewStatistics {
  int totalReviews;
  double averageRating;

  ReviewStatistics({
    required this.totalReviews,
    required this.averageRating,
  });

  factory ReviewStatistics.fromJson(Map<String, dynamic> json) => ReviewStatistics(
    totalReviews: json["total_reviews"] ?? 0,
    averageRating: (json["average_rating"] ?? 0).toDouble(),
  );
}