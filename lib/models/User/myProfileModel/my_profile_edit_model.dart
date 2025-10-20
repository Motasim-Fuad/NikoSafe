// Model/user_profile_model.dart
class MyProfileEditModel {
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? mobileNumber;
  final int? age;
  final String? sex;
  final int? weight;
  final String? profilePicture;

  MyProfileEditModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.age,
    this.sex,
    this.weight,
    this.profilePicture,
  });

  factory MyProfileEditModel.fromJson(Map<String, dynamic> json) {
    return MyProfileEditModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      mobileNumber: json['mobile_number'],
      age: json['age'],
      sex: json['sex'],
      weight: json['weight'],
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (mobileNumber != null) 'mobile_number': mobileNumber,
      if (age != null) 'age': age,
      if (sex != null) 'sex': sex,
      if (weight != null) 'weight': weight,
    };
  }
}