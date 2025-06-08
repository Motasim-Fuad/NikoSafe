// lib/View/User/MyProfile/user_review/user_review_page_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // For SystemChrome
import 'package:nikosafe/resource/compunents/RoundButton.dart';

import '../../../../../../View_Model/Controller/user/MyProfile/user_review/user_review_controller.dart';

class UserReviewPageView extends StatelessWidget {
  final UserReviewController controller = Get.put(UserReviewController());

  @override
  Widget build(BuildContext context) {
    // Set status bar icons to light for better contrast on dark app bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFF1F2833), // Dark background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2833), // Dark app bar color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Write Review',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // <--- Wrap the entire body content with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reviews Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3E50), // Darker shade for the card
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reviews',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          controller.overallRating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < controller.overallRating.floor()
                                      ? Icons.star
                                      : (index < controller.overallRating ? Icons.star_half : Icons.star_border),
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${controller.totalRatings} Ratings & ${controller.totalReviews} Reviews',
                              style: const TextStyle(color: Colors.white54, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Star rating distribution bars
                    ...controller.starDistribution.entries.map((entry) {
                      final int stars = entry.key;
                      final double percentage = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Text('$stars★', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percentage,
                                backgroundColor: Colors.white12,
                                color: const Color(0xFF66FCF1), // Bright green/cyan color for the bar
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // User's Rating Stars
              Center(
                child: Obx(
                      () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          controller.setRating(index + 1.0);
                        },
                        child: Icon(
                          index < controller.rating.value ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 38,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Please share your opinion TextField
              const Text(
                'Please share your opinion',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => controller.setReviewText(value),
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Your review',
                  hintStyle: const TextStyle(color: Colors.white54),
                  fillColor: const Color(0xFF2C3E50),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              // Upload Photo Section
              GestureDetector(
                onTap: () => controller.pickImage(),
                child: Obx(
                      () => Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3E50),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: controller.pickedImagePath.value != null
                            ? const Color(0xFF66FCF1)
                            : Colors.grey.shade700,
                        width: 1.5,
                      ),
                    ),
                    child: controller.pickedImagePath.value != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        controller.pickedImagePath.value!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                        : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload, size: 48, color: Colors.white70),
                          SizedBox(height: 8),
                          Text(
                            'Upload Photo',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),



              // Submit Button
              RoundButton(title: "Submit",width: double.infinity, onPress: (){
                controller.submitReview();
              }),


            ],
          ),
        ),
      ),
    );
  }
}