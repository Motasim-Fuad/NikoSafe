class AuthUserModel {
  final String? token;

  AuthUserModel({this.token});

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(token: json['token']);
  }

  Map<String, dynamic> toJson() => {
    'token': token,
  };
}