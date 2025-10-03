import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/models/User/userSearch/explore_item_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import '../explore_detail_page.dart';

class ExploreCard extends StatelessWidget {
  final ExploreItemModel item;
  final double? width;
  final double? height;

  const ExploreCard({
    required this.item,
    this.width = 300,
    this.height = 240,
  });

  // Helper method for displaying stars
  Widget _buildStarRating(double rating, {double iconSize = 14}) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    double halfStar = rating - fullStars;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.amber, size: iconSize));
    }
    if (halfStar > 0) {
      stars.add(Icon(Icons.star_half, color: Colors.amber, size: iconSize));
    }
    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: Colors.amber, size: iconSize));
    }
    return Row(children: stars);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ExploreDetailPage(item: item)),
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with overlay
            Stack(
              children: [
                Container(
                  height: height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)),
                    image: DecorationImage(
                      image: AssetImage(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Rating badge (top-left) - Using numerical rating as per original design
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.yellow),
                        SizedBox(width: 4),
                        Text(
                          item.rating.toStringAsFixed(1), // Format double to 1 decimal place
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                // Time badge (top-right)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          item.time,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Text info below the image
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.iconColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColor.primaryTextColor),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: AppColor.secondaryTextColor),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.location,
                          style: TextStyle( color: AppColor.secondaryTextColor, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4), // Add spacing for the star rating
                  // New: Display visual star rating here
                  _buildStarRating(item.rating),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}