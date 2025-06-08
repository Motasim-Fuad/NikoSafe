// lib/View_Model/Model/user/MyProfile/user_review_model.dart
// This model is kept as you provided, though not directly used in the UI logic here,
// it's good practice to have for data structures.
class UserReviewModel {
  final double rating;
  final String review;
  final String? imagePath; // Changed to nullable as image might not be selected

  UserReviewModel({required this.rating, required this.review, this.imagePath});
}