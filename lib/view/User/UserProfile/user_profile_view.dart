import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/authentication/login_authentication_controller.dart';
import 'package:nikosafe/View_Model/Controller/user/MyProfile/my_profile_details_controller/my_profile_detailsController.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/User/UserProfile/ViewProfileDetails/my_profile_details_view.dart';

class MyProfileView extends StatelessWidget {
  final controller = Get.put(MyProfileDetailsController());
  final controller_logout = Get.put(LoginAuthController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Profile", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            // Refresh Button
            Obx(() => IconButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.refreshProfile(),
              icon: controller.isLoading.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.refresh, color: Colors.white),
            )),
            // Settings Button
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  Get.toNamed(RouteName.userSettingsView);
                },
                icon: const Icon(Icons.settings, color: Colors.white),
              ),
            ),
          ],
        ),
        body: Obx(() {
          // Loading State
          if (controller.isLoading.value && controller.profile.value == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyan),
            );
          }

          // Error State
          if (controller.errorMessage.value.isNotEmpty &&
              controller.profile.value == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.loadProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final user = controller.profile.value;

          if (user == null) {
            return const Center(
              child: Text(
                'No profile data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // Main Content with RefreshIndicator
          return RefreshIndicator(
            onRefresh: () => controller.refreshProfile(),
            color: Colors.cyan,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Profile Picture
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[800],
                    child: user.displayImage != null
                        ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: user.displayImage!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                        const CircularProgressIndicator(
                          color: Colors.cyan,
                          strokeWidth: 2,
                        ),
                        errorWidget: (context, url, error) {
                          print('❌ Profile image error: $error');
                          return Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey[600],
                          );
                        },
                      ),
                    )
                        : Icon(Icons.person, size: 40, color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 12),

                  // User Name
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Email
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),

                  // View Profile Button
                  TextButton(
                    onPressed: () {
                      Get.to(() => MyProfileDetailsView());
                    },
                    child: const Text(
                      "View Profile",
                      style: TextStyle(color: Colors.cyan),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Menu Items
                  _buildTile(Icons.edit, "Edit Profile Details", () {
                    Get.toNamed(RouteName.userEditProfileView);
                  }),
                  _buildTile(Icons.history, "History", () {
                    Get.toNamed(RouteName.userHistory);
                  }),
                  _buildTile(Icons.star_border_purple500_sharp, "Favorites", () {
                    Get.toNamed(RouteName.favoritesScreenView);
                  }),
                  _buildTile(Icons.add, "Following", () {
                    Get.toNamed(RouteName.followingView);
                  }),
                  _buildTile(Icons.contacts, "Alert Contacts", () {
                    Get.toNamed(RouteName.userEmergencyContactsView);
                  }),
                  _buildTile(Icons.support_agent, "Support", () {
                    Get.toNamed(RouteName.userSupport);
                  }),
                  _buildTile(Icons.question_mark, "FAQ", () {
                    Get.toNamed(RouteName.faqView);
                  }),
                  _buildTile(Icons.privacy_tip, "Privacy Policy", () {
                    Get.toNamed(RouteName.userPrivacyPolicy);
                  }),
                  _buildTile(Icons.description, "Terms & Conditions", () {
                    Get.toNamed(RouteName.userTearmsConditions);
                  }),
                  _buildTile(Icons.info_outline, "About Us", () {
                    Get.toNamed(RouteName.userAboutUs);
                  }),

                  const SizedBox(height: 16),

                  // Logout Button
                  TextButton.icon(
                    onPressed: () {
                      controller_logout.logout();
                    },
                    style: TextButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.iconColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.cyan),
            title: Text(title, style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}