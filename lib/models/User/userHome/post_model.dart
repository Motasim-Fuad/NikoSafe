class PostModel {
  PostModel({
    required this.success,
    required this.message,
    required this.timestamp,
    required this.statusCode,
    required this.data,
  });

  final bool? success;
  final String? message;
  final DateTime? timestamp;
  final int? statusCode;
  final Data? data;

  factory PostModel.fromJson(Map<String, dynamic> json){
    return PostModel(
      success: json["success"],
      message: json["message"],
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
      statusCode: json["status_code"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.user,
    required this.postType,
    required this.privacy,
    required this.title,
    required this.text,
    required this.pollTitle,
    required this.images,
    required this.pollOptions,
    required this.checkIn,
    required this.comments,
    required this.reactions,
    required this.totalReactions,
    required this.totalComments,
    required this.totalPollVotes,
    required this.isPoll,
    required this.userReaction,
    required this.userPollVote,
    required this.isHidden,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final User? user;
  final PostType? postType;
  final Privacy? privacy;
  final String? title;
  final String? text;
  final String? pollTitle;
  final List<dynamic> images;
  final List<dynamic> pollOptions;
  final CheckIn? checkIn;
  final List<dynamic> comments;
  final List<Reaction> reactions;
  final int? totalReactions;
  final int? totalComments;
  final int? totalPollVotes;
  final bool? isPoll;
  final dynamic userReaction;
  final dynamic userPollVote;
  final bool? isHidden;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      postType: json["post_type"] == null ? null : PostType.fromJson(json["post_type"]),
      privacy: json["privacy"] == null ? null : Privacy.fromJson(json["privacy"]),
      title: json["title"],
      text: json["text"],
      pollTitle: json["poll_title"],
      images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
      pollOptions: json["poll_options"] == null ? [] : List<dynamic>.from(json["poll_options"]!.map((x) => x)),
      checkIn: json["check_in"] == null ? null : CheckIn.fromJson(json["check_in"]),
      comments: json["comments"] == null ? [] : List<dynamic>.from(json["comments"]!.map((x) => x)),
      reactions: json["reactions"] == null ? [] : List<Reaction>.from(json["reactions"]!.map((x) => Reaction.fromJson(x))),
      totalReactions: json["total_reactions"],
      totalComments: json["total_comments"],
      totalPollVotes: json["total_poll_votes"],
      isPoll: json["is_poll"],
      userReaction: json["user_reaction"],
      userPollVote: json["user_poll_vote"],
      isHidden: json["is_hidden"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}

class CheckIn {
  CheckIn({
    required this.id,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final int? id;
  final String? locationName;
  final String? latitude;
  final String? longitude;
  final String? address;

  factory CheckIn.fromJson(Map<String, dynamic> json){
    return CheckIn(
      id: json["id"],
      locationName: json["location_name"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      address: json["address"],
    );
  }

}

class PostType {
  PostType({
    required this.id,
    required this.name,
    required this.slug,
  });

  final int? id;
  final String? name;
  final String? slug;

  factory PostType.fromJson(Map<String, dynamic> json){
    return PostType(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
    );
  }

}

class Privacy {
  Privacy({
    required this.id,
    required this.name,
    required this.description,
  });

  final int? id;
  final String? name;
  final String? description;

  factory Privacy.fromJson(Map<String, dynamic> json){
    return Privacy(
      id: json["id"],
      name: json["name"],
      description: json["description"],
    );
  }

}

class Reaction {
  Reaction({
    required this.id,
    required this.user,
    required this.type,
    required this.createdAt,
  });

  final int? id;
  final User? user;
  final String? type;
  final DateTime? createdAt;

  factory Reaction.fromJson(Map<String, dynamic> json){
    return Reaction(
      id: json["id"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      type: json["type"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

}

class User {
  User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  final int? id;
  final String? email;
  final dynamic username;
  final String? firstName;
  final String? lastName;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      email: json["email"],
      username: json["username"],
      firstName: json["first_name"],
      lastName: json["last_name"],
    );
  }

}
