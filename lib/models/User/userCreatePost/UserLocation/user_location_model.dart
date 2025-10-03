class UserLocationModel {
  final String id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;

  UserLocationModel({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
  });

  // Factory constructor to create a LocationModel from a map
  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // Convert LocationModel to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserLocationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}