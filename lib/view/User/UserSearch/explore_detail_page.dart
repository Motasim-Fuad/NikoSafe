// Path: view/User/UserSearch/explore_detail_page.dart
// COMPLETE FILE - Replace entire file

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/models/User/userSearch/explore_item_model.dart';
import 'package:nikosafe/models/vendor/chat/vendor_chat_model.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../View_Model/Controller/user/userSearch/explore_controller.dart';
import '../../../resource/Colors/app_colors.dart';
import '../../../resource/compunents/customBackButton.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';

class ExploreDetailPage extends StatefulWidget {
  final ExploreItemModel item;
  const ExploreDetailPage({required this.item});

  @override
  State<ExploreDetailPage> createState() => _ExploreDetailPageState();
}

class _ExploreDetailPageState extends State<ExploreDetailPage> {
  final ExploreController controller = Get.find<ExploreController>();
  late ExploreItemModel currentItem;

  @override
  void initState() {
    super.initState();
    currentItem = widget.item;
  }

  // FIXED: Refresh current item data
  Future<void> _refreshItemData() async {
    await controller.loadItems();

    // Find updated item
    final updatedItem = controller.allItems.firstWhereOrNull(
          (item) => item.id == currentItem.id,
    );

    if (updatedItem != null) {
      setState(() {
        currentItem = updatedItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: _refreshItemData,
          color: AppColor.limeColor,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image and Back Button Section
                Stack(
                  children: [
                    // FIXED: Show icon when image is null or empty
                    currentItem.imageUrl.isNotEmpty
                        ? Image.network(
                      currentItem.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 250,
                          width: double.infinity,
                          color: Colors.grey[800],
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.limeColor,
                            ),
                          ),
                        );
                      },
                    )
                        : _buildPlaceholderImage(),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: CustomBackButton(
                          backgroundColor: Color(0x99718285)),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text(
                            currentItem.rating.toStringAsFixed(1),
                            style: TextStyle(
                                color: AppColor.primaryTextColor,
                                fontSize: 16),
                          ),
                          SizedBox(width: 8),
                          Text(
                            currentItem.location,
                            style: TextStyle(
                                color: AppColor.primaryTextColor
                                    .withOpacity(0.8),
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              currentItem.title,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryTextColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          currentItem.category == "club_event"
                              ? IconButton(
                            onPressed: () {
                              controller.toggleFavorite(currentItem);
                            },
                            icon: Obx(() {
                              bool isFav = controller
                                  .isFavorite(currentItem.id);
                              return Icon(
                                isFav
                                    ? Icons.star
                                    : Icons
                                    .star_border_purple500_sharp,
                                color: isFav
                                    ? Colors.amber
                                    : Colors.white,
                              );
                            }),
                          )
                              : Obx(() {
                            bool isFollowing = controller
                                .isFollowing(currentItem.id);
                            return RoundButton(
                              width: 150,
                              height: 40,
                              title: isFollowing
                                  ? "Following"
                                  : "Follow",
                              onPress: () {
                                controller.toggleFollow(currentItem);
                                Utils.successSnackBar(
                                    isFollowing
                                        ? "Unfollowed"
                                        : "Followed",
                                    "${currentItem.title} ${isFollowing ? 'removed from' : 'added to'} following list");
                              },
                            );
                          })
                        ],
                      ),
                      SizedBox(height: 16),
                      // Contact Info
                      _buildInfoRow(
                        Icons.phone,
                        currentItem.phoneNumber,
                        AppColor.primaryTextColor,
                      ),
                      SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.email,
                        currentItem.email,
                        AppColor.primaryTextColor,
                      ),
                      SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Mon-Sun',
                        AppColor.primaryTextColor,
                        suffixWidget: Text(
                          currentItem.time,
                          style:
                          TextStyle(color: AppColor.primaryTextColor),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Happy Hour & Other Info
                      Text(
                        '• ${currentItem.happyHour}',
                        style:
                        TextStyle(color: AppColor.primaryTextColor),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• ${currentItem.safeEntryInfo}',
                        style:
                        TextStyle(color: AppColor.primaryTextColor),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• ${currentItem.cateringInfo}',
                        style:
                        TextStyle(color: AppColor.primaryTextColor),
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
                      _buildOverallRatingSection(currentItem),
                      SizedBox(height: 24),
                      // Individual Reviews
                      currentItem.reviews.isEmpty
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'No reviews yet',
                            style: TextStyle(
                              color: AppColor.primaryTextColor
                                  .withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: currentItem.reviews.length,
                        itemBuilder: (context, index) {
                          return _buildReviewCard(
                              currentItem.reviews[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),


        bottomNavigationBar: currentItem.category == "club_event"
            ? Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
          child: RoundButton(
              title: "Book Reservation",
              onPress: () {
                Get.toNamed(RouteName.userBookReservationView,
                    arguments: [currentItem]);
              }),
        )
            : Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
          child: Row(
            children: [
              Expanded(
                child: RoundButton(
                    title: "Call",
                    icon: Icons.call,
                    onPress: () {}),
              ),
              SizedBox(width: 16),
              Expanded(
                child: RoundButton(
                  title: "Chat",
                  icon: Icons.chat,
                  onPress: () {
                    // ✅ NEW - Navigate to vendor chat
                    final vendorModel = VendorChatModel(
                      id: currentItem.userId,
                      name: currentItem.title,
                      email: currentItem.email,
                      profilePicture: currentItem.imageUrl.isNotEmpty
                          ? currentItem.imageUrl
                          : null,
                    );

                    Get.toNamed(
                      RouteName.vendorChatDetailView,
                      arguments: vendorModel,
                    );
                  },
                ),
              ),
            ],
          ),
        ),


      ),
    );
  }

  // FIXED: Placeholder image widget
  Widget _buildPlaceholderImage() {
    return Container(
      height: 250,
      width: double.infinity,
      color: Colors.grey[800],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business,
            size: 80,
            color: Colors.grey[600],
          ),
          SizedBox(height: 8),
          Text(
            'No image available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color textColor,
      {Widget? suffixWidget}) {
    return Row(
      children: [
        Icon(icon, color: textColor.withOpacity(0.7), size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ),
        if (suffixWidget != null) suffixWidget,
      ],
    );
  }

  Widget _buildOverallRatingSection(ExploreItemModel item) {
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
                  _buildClickableStarRating(item),
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
          _buildRatingBar(5, _calculateRatingPercentage(item.reviews, 5)),
          _buildRatingBar(4, _calculateRatingPercentage(item.reviews, 4)),
          _buildRatingBar(3, _calculateRatingPercentage(item.reviews, 3)),
          _buildRatingBar(2, _calculateRatingPercentage(item.reviews, 2)),
          _buildRatingBar(1, _calculateRatingPercentage(item.reviews, 1)),
        ],
      ),
    );
  }

  // FIXED: Refresh page after rating
  Widget _buildClickableStarRating(ExploreItemModel item) {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () async {
            final rating = index + 1;
            final confirm = await Get.dialog<bool>(
              AlertDialog(
                backgroundColor: Colors.grey[900],
                title: Text(
                  'Rate this venue',
                  style: TextStyle(color: AppColor.primaryTextColor),
                ),
                content: Text(
                  'Give $rating star${rating > 1 ? 's' : ''} to ${item.title}?',
                  style: TextStyle(color: AppColor.primaryTextColor),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: Text('Submit',
                        style: TextStyle(color: AppColor.limeColor)),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              final success = await controller.createReviewFromStar(
                item: item,
                rating: rating,
              );

              // FIXED: Refresh this page after successful review
              if (success) {
                await _refreshItemData();
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Icon(
              index < item.rating.floor()
                  ? Icons.star
                  : (index < item.rating
                  ? Icons.star_half
                  : Icons.star_border),
              color: Colors.amber,
              size: 18,
            ),
          ),
        );
      }),
    );
  }

  double _calculateRatingPercentage(List<ReviewModel> reviews, int star) {
    if (reviews.isEmpty) return 0.0;
    final count = reviews.where((r) => r.rating.round() == star).length;
    return count / reviews.length;
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
            style: TextStyle(
                color: AppColor.primaryTextColor.withOpacity(0.8)),
          ),
          SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor:
              AppColor.primaryTextColor.withOpacity(0.3),
              valueColor:
              AlwaysStoppedAnimation<Color>(AppColor.limeColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(
              color: AppColor.primaryTextColor.withOpacity(0.7),
              fontSize: 12,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStarRating(review.rating),
              Text(
                review.reviewDate,
                style: TextStyle(
                    color: AppColor.primaryTextColor.withOpacity(0.6),
                    fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            review.reviewText,
            style: TextStyle(
                color: AppColor.primaryTextColor, fontSize: 16),
          ),
          SizedBox(height: 8),
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
          if (review.venueReply != null) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.limeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColor.limeColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16,
                        color: AppColor.limeColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Venue Reply:',
                        style: TextStyle(
                          color: AppColor.limeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    review.venueReply!,
                    style: TextStyle(
                      color: AppColor.primaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}