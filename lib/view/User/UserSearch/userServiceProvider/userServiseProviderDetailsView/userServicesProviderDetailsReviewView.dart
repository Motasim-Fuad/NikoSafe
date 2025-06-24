// Fixed UserServicesProviderDetailsReviewView
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/User/UserSearch/userServiceProvider/userServiseProviderDetailsView/booking_page_view.dart';
import 'package:nikosafe/view/User/UserSearch/userServiceProvider/userServiseProviderDetailsView/widgets/taskRequestbottomSheed.dart';
import '../../../../../resource/Colors/app_colors.dart';
import '../../../../../models/userSearch/userServiceProviderModel/user_services_provider.dart'; // Added missing import

class Userservicesproviderdetailsreviewview extends StatelessWidget {
  final UserServiceProvider item;
  const Userservicesproviderdetailsreviewview({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryTextColor)),
        SizedBox(height: 16),
        _buildOverallRatingSection(item),
        SizedBox(height: 24),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: item.reviews.length,
          itemBuilder: (context, index) {
            return _buildReviewCard(item.reviews[index]);
          },
        ),
        // Optional: Add booking button
        SizedBox(height: 20),


      ],
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

  Widget _buildOverallRatingSection(UserServiceProvider item) { // Fixed: changed from ExploreItemModel to UserServiceProvider
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.rating.toStringAsFixed(1),
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
          // Rating distribution bars (using example values)
          _buildRatingBar(5, 0.8),
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
                    backgroundColor: Colors.grey,
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









