// lib/View_Model/Controller/user/MyProfile/user_review/user_review_controller.dart
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserReviewController extends GetxController {
  var rating = 0.0.obs; // This will hold the user's selected rating (0-5 stars)
  var reviewText = ''.obs;
  var pickedImagePath = Rxn<File>(); // Observable to hold the picked image file

  // For the display of review statistics (4.8 rating, 1002 Ratings, 922 Reviews)
  // These are static values from your image, you might fetch them dynamically in a real app.
  final double overallRating = 4.8;
  final int totalRatings = 1002;
  final int totalReviews = 922;

  // Distribution of star ratings (example values to mimic the UI bars)
  final Map<int, double> starDistribution = {
    5: 0.8, // 80%
    4: 0.6, // 60%
    3: 0.4, // 40%
    2: 0.2, // 20%
    1: 0.1, // 10%
  };

  void setRating(double value) {
    rating.value = value;
  }

  void setReviewText(String value) {
    reviewText.value = value;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImagePath.value = File(image.path);
    }
  }

  void submitReview() {
    if (rating.value == 0.0) {
      Get.snackbar('Error', 'Please provide a rating.');
      return;
    }
    if (reviewText.value.isEmpty) {
      Get.snackbar('Error', 'Please write your review.');
      return;
    }

    // Here you would typically send this data to an API
    print('Submitting Review:');
    print('Rating: ${rating.value}');
    print('Review Text: ${reviewText.value}');
    print('Image Path: ${pickedImagePath.value?.path ?? 'No image selected'}');

    Get.snackbar('Success', 'Review submitted successfully!');
    // Optionally, clear the form after submission
    rating.value = 0.0;
    reviewText.value = '';
    pickedImagePath.value = null;
  }
}