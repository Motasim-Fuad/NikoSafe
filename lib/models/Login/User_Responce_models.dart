class UserModel {
  final String? token;
  final String? role;

  UserModel({this.token, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'role': role,
    };
  }
}
