import 'package:flutter/material.dart';
import '../../../models/userSearch/explore_item_model.dart';
import '../../../resource/Colors/app_colors.dart';
import '../../../resource/compunents/customBackButton.dart';

class ExploreDetailPage extends StatelessWidget {
  final ExploreItemModel item;
  ExploreDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView( // Use SingleChildScrollView for scrollable content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and Back Button Section
              Stack(
                children: [
                  // Placeholder for the image. In a real app, this would be an Image.network or similar.
                  Image.asset(
                    item.imageUrl, // Assuming item.imageUrl now points to the main image
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: CustomBackButton(backgroundColor: Color(0x99718285)),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 4),
                        Text(
                          item.rating.toString(),
                          style: TextStyle(
                              color: AppColor.primaryTextColor, fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        Text(
                          item.location,
                          style: TextStyle(
                              color: AppColor.primaryTextColor.withOpacity(0.8),
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryTextColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Contact Info
                    _buildInfoRow(
                      Icons.phone,
                      item.phoneNumber,
                      AppColor.primaryTextColor,
                    ),
                    SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.email,
                      item.email,
                      AppColor.primaryTextColor,
                    ),
                    SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Mon-Sun',
                      AppColor.primaryTextColor,
                      suffixWidget: Text(
                        '8:00 PM - 1:00 AM',
                        style: TextStyle(color: AppColor.primaryTextColor),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Happy Hour & Other Info
                    Text(
                      '• ${item.happyHour}',
                      style: TextStyle(color: AppColor.primaryTextColor),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• ${item.safeEntryInfo}',
                      style: TextStyle(color: AppColor.primaryTextColor),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• ${item.cateringInfo}',
                      style: TextStyle(color: AppColor.primaryTextColor),
                    ),
                    SizedBox(height: 24),
                    // Reviews Section
                    Text(
                      'Reviews',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryTextColor),
                    ),
                    SizedBox(height: 16),
                    _buildOverallRatingSection(item),
                    SizedBox(height: 24),
                    // Individual Reviews
                    ListView.builder(
                      shrinkWrap: true, // Important for nested ListView in SingleChildScrollView
                      physics: NeverScrollableScrollPhysics(), // Disable scrolling of inner ListView
                      itemCount: item.reviews.length,
                      itemBuilder: (context, index) {
                        return _buildReviewCard(item.reviews[index]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Reserve a Table
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.buttonColor, // Use your accent color
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Reserve a Table',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Join Tavern Chat
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.buttonColor, // Use your accent color
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Join Tavern Chat',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color textColor,
      {Widget? suffixWidget}) {
    return Row(
      children: [
        Icon(icon, color: textColor.withOpacity(0.7), size: 20),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        if (suffixWidget != null) ...[
          Spacer(),
          suffixWidget,
        ],
      ],
    );
  }

  Widget _buildOverallRatingSection(ExploreItemModel item) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2), // A subtle background for the section
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.rating.toStringAsFixed(1), // Format to one decimal place
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryTextColor,
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStarRating(item.rating),
                  SizedBox(height: 4),
                  Text(
                    '${item.totalRatings} Ratings & ${item.totalReviews} Reviews',
                    style: TextStyle(
                        color: AppColor.primaryTextColor.withOpacity(0.7),
                        fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          // Rating distribution bars
          _buildRatingBar(5, 0.8), // Example values, replace with actual data
          _buildRatingBar(4, 0.6),
          _buildRatingBar(3, 0.4),
          _buildRatingBar(2, 0.2),
          _buildRatingBar(1, 0.1),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    double halfStar = rating - fullStars;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.amber, size: 18));
    }
    if (halfStar > 0) {
      stars.add(Icon(Icons.star_half, color: Colors.amber, size: 18));
    }
    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: Colors.amber, size: 18));
    }
    return Row(children: stars);
  }

  Widget _buildRatingBar(int star, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$star*',
            style: TextStyle(color: AppColor.primaryTextColor.withOpacity(0.8)),
          ),
          SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColor.primaryTextColor.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.limeColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStarRating(review.rating),
          SizedBox(height: 8),
          Text(
            review.reviewText,
            style: TextStyle(color: AppColor.primaryTextColor, fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey, // Placeholder for avatar
                    child: Icon(Icons.person, size: 16, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Text(
                    review.reviewerName,
                    style: TextStyle(
                        color: AppColor.primaryTextColor.withOpacity(0.8),
                        fontSize: 14),
                  ),
                ],
              ),
              Text(
                review.reviewDate,
                style: TextStyle(
                    color: AppColor.primaryTextColor.withOpacity(0.6),
                    fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}