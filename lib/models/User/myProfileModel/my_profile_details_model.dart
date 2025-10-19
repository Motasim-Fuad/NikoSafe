// models/User/myProfileModel/my_profile_details_model.dart

class MyProfileDetailsModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String? profilePicture;
  final int friendsCount;
  final int postsCount;
  final List<PostModel> posts;

  MyProfileDetailsModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    this.profilePicture,
    required this.friendsCount,
    required this.postsCount,
    required this.posts,
  });

  factory MyProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    return MyProfileDetailsModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      profilePicture: json['profile_picture'],
      friendsCount: json['friends_count'] ?? 0,
      postsCount: json['posts_count'] ?? 0,
      posts: (json['posts'] as List?)
          ?.map((post) => PostModel.fromJson(post))
          .toList() ?? [],
    );
  }

  // Get full name or email username if name is empty
  String get fullName {
    if (firstName.isEmpty && lastName.isEmpty) {
      return email.split('@')[0];
    }
    return '$firstName $lastName'.trim();
  }

  // Get profile image URL with base URL
  String get displayImage {
    if (profilePicture != null && profilePicture!.isNotEmpty) {
      return 'https://luke-stat-forming-kinase.trycloudflare.com$profilePicture';
    }
    return 'assets/images/default_profile.png'; // Your default image path
  }

  // Get all gallery images from posts
  List<String> get galleryImages {
    List<String> images = [];
    for (var post in posts) {
      for (var image in post.images) {
        images.add('https://luke-stat-forming-kinase.trycloudflare.com${image.image}');
      }
    }
    return images;
  }
}

class PostModel {
  final int id;
  final String postType;
  final String privacy;
  final String title;
  final String text;
  final String createdAt;
  final String updatedAt;
  final int totalReactions;
  final int totalComments;
  final List<PostImageModel> images;
  final CheckInModel? checkIn;
  final String? pollTitle;
  final int? totalPollVotes;
  final List<PollOptionModel>? pollOptions;

  PostModel({
    required this.id,
    required this.postType,
    required this.privacy,
    required this.title,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.totalReactions,
    required this.totalComments,
    required this.images,
    this.checkIn,
    this.pollTitle,
    this.totalPollVotes,
    this.pollOptions,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      postType: json['post_type'] ?? '',
      privacy: json['privacy'] ?? '',
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      totalReactions: json['total_reactions'] ?? 0,
      totalComments: json['total_comments'] ?? 0,
      images: (json['images'] as List?)
          ?.map((img) => PostImageModel.fromJson(img))
          .toList() ?? [],
      checkIn: json['check_in'] != null
          ? CheckInModel.fromJson(json['check_in'])
          : null,
      pollTitle: json['poll_title'],
      totalPollVotes: json['total_poll_votes'],
      pollOptions: (json['poll_options'] as List?)
          ?.map((opt) => PollOptionModel.fromJson(opt))
          .toList(),
    );
  }
}

class PostImageModel {
  final int id;
  final String image;

  PostImageModel({
    required this.id,
    required this.image,
  });

  factory PostImageModel.fromJson(Map<String, dynamic> json) {
    return PostImageModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  String get fullImageUrl {
    return 'https://luke-stat-forming-kinase.trycloudflare.com$image';
  }
}

class CheckInModel {
  final String locationName;
  final String? latitude;
  final String? longitude;
  final String address;

  CheckInModel({
    required this.locationName,
    this.latitude,
    this.longitude,
    required this.address,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) {
    return CheckInModel(
      locationName: json['location_name'] ?? '',
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'] ?? '',
    );
  }
}

class PollOptionModel {
  final int id;
  final String option;
  final int voteCount;
  final int votePercentage;

  PollOptionModel({
    required this.id,
    required this.option,
    required this.voteCount,
    required this.votePercentage,
  });

  factory PollOptionModel.fromJson(Map<String, dynamic> json) {
    return PollOptionModel(
      id: json['id'] ?? 0,
      option: json['option'] ?? '',
      voteCount: json['vote_count'] ?? 0,
      votePercentage: json['vote_percentage'] ?? 0,
    );
  }
}