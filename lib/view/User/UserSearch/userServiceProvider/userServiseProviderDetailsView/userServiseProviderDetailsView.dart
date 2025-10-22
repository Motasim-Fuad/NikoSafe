// view/User/UserSearch/userServiceProvider/service_provider_detail_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userSearch/userServiceProviderController/user_service_provider_controller.dart';
import 'package:nikosafe/models/Provider/chat/provider_chat_model.dart';
import 'package:nikosafe/models/User/userSearch/userServiceProviderModel/user_services_provider.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/User/UserSearch/userServiceProvider/userServiseProviderDetailsView/widgets/taskRequestbottomSheed.dart';
import '../../../../../View_Model/toggle_tab_controller.dart';
import '../../../../../resource/App_routes/routes_name.dart';
import '../../../../../resource/compunents/toggle_tab_button.dart';

class UserServiceProviderDetailView extends StatelessWidget {
  final controller = Get.find<ServiceProviderController>();
  final toggleController = Get.put(ToggleTabController());

  UserServiceProviderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceProviderModel provider = Get.arguments;

    // Load provider details
    controller.loadProviderDetails(provider.id);

    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Service Provider Detail'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            Obx(() => IconButton(
              onPressed: () {
                controller.toggleSaveProvider(provider);
              },
              icon: Icon(
                controller.isSaved(provider.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: controller.isSaved(provider.id)
                    ? Colors.red
                    : Colors.white,
              ),
            )),
          ],
        ),
        body: Obx(() {
          if (controller.isDetailLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final detail = controller.providerDetail.value;
          if (detail == null) {
            return Center(
              child: Text(
                'Failed to load provider details',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Column(
            children: [
              // Top section
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: detail.profilePicture != null
                          ? NetworkImage(detail.profilePicture!)
                          : null,
                      backgroundColor: Colors.grey[300],
                      child: detail.profilePicture == null
                          ? Icon(Icons.person, size: 50, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      detail.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      detail.designation,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Experience: ${detail.yearsOfExperience} Years',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '${detail.averageRating} (${detail.totalReviews} reviews)',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      'Rate: \$${detail.desiredPayRate}/hour',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    RoundButton(
                      width: 200,
                      height: 40,
                      title: "Message",
                      onPress: () {
                        // ✅ NEW - Open service provider chat
                        final serviceChatModel = ServiceChatModel(
                          id: detail.userId,
                          name: detail.fullName,
                          email: detail.email ?? '',
                          profilePicture: detail.profilePicture,
                          designation: detail.designation,
                        );

                        Get.toNamed(
                          RouteName.serviceChatDetailView,
                          arguments: serviceChatModel,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: RoundedToggleTab(
                        tabs: ['About', 'Review'],
                        controller: toggleController,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom scrollable section
              Expanded(
                child: ClipPath(
                  clipper: TopRoundedClipper(),
                  child: Container(
                    color: Color(0xff264953),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            toggleController.selectedIndex.value == 0
                                ? _buildAboutSection(detail)
                                : _buildReviewSection(detail),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),

              // ✅ FIXED: Booking/Task Request Button
              Obx(() {
                final detail = controller.providerDetail.value;
                if (detail == null) return SizedBox.shrink();

                return detail.designation == "Trainer" || detail.designation == "Therapist"
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundButton(
                    width: double.infinity,
                    title: "Booking Request",
                    onPress: () {
                      // ✅ FIXED: Correct navigation with arguments
                      Get.toNamed(
                        RouteName.bookingPageView,
                        arguments: {
                          'providerId': detail.id,
                        },
                      );
                    },
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundButton(
                    title: "Task Request",
                    onPress: () {
                      Get.to(TaskRequestBottomSheetView(providerId: detail.id,));
                    },
                    width: double.infinity,
                  ),
                );
              }),
              SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAboutSection(ServiceProviderDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          detail.aboutMe.isNotEmpty
              ? detail.aboutMe
              : "No information available",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 20),
        Text(
          "Job Title",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          detail.jobTitle.isNotEmpty ? detail.jobTitle : "Not specified",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 20),
        Text(
          "Skills",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        detail.skills.isNotEmpty
            ? Wrap(
          spacing: 8,
          runSpacing: 8,
          children: detail.skills
              .map((skill) => Chip(
            label: Text(skill),
            backgroundColor: AppColor.blackTextColor,
            labelStyle: TextStyle(color: AppColor.limeColor),
          ))
              .toList(),
        )
            : Text(
          "No skills listed",
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 20),
        Text(
          "Certificates",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        detail.certificates.isNotEmpty
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: detail.certificates
              .map((cert) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Icon(Icons.verified,
                    color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cert,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ))
              .toList(),
        )
            : Text(
          "No certificates listed",
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 20),
        Text(
          "Location",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.red, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                detail.location,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "Service Radius: ${detail.serviceRadius} km",
          style: TextStyle(color: Colors.white70),
        ),
        if (detail.phoneNumber.isNotEmpty) ...[
          SizedBox(height: 20),
          Text(
            "Contact",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text(
                detail.phoneNumber,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildReviewSection(ServiceProviderDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Reviews (${detail.totalReviews})",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 24),
                SizedBox(width: 4),
                Text(
                  detail.averageRating,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        detail.recentReviews.isNotEmpty
            ? ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: detail.recentReviews.length,
          itemBuilder: (context, index) {
            final review = detail.recentReviews[index];
            return Card(
              color: AppColor.iconColor,
              margin: EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.reviewerName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              review.rating.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      review.reviewText,
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 8),
                    Text(
                      review.reviewDate,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
            : Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "No reviews yet",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}

class TopRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 30.0;

    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}