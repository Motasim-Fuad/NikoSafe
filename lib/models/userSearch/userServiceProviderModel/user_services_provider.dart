class UserServiceProvider {
  final String name;
  final String service;
  final String experience;
  final String rate;
  final String imageUrl;
  final List<String> skills; // ✅ Add this field

  UserServiceProvider({
    required this.name,
    required this.service,
    required this.experience,
    required this.rate,
    required this.imageUrl,
    required this.skills, // ✅ Include in constructor
  });

  factory UserServiceProvider.fromJson(Map<String, dynamic> json) {
    return UserServiceProvider(
      name: json['name'] ?? '',
      service: json['service'] ?? '',
      experience: json['experience'] ?? '',
      rate: json['rate'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList() ?? [], // ✅ Deserialize
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'service': service,
      'experience': experience,
      'rate': rate,
      'imageUrl': imageUrl,
      'skills': skills, // ✅ Serialize
    };
  }
}
