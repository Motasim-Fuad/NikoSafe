// View/user/MyProfile/user_edit_profile_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import '../../../../View_Model/Controller/user/MyProfile/user_edit_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserEditProfileView extends StatelessWidget {
  final controller = Get.put(UserEditProfileController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(color: Colors.white),
          title: const Text(
            "Edit Profile Details",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          // Show loading indicator while fetching profile
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyan),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Image Section
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() {
                      final imagePath = controller.imagePath.value;

                      return CircleAvatar(
                        radius: 45,
                        backgroundImage: imagePath.isNotEmpty
                            ? (imagePath.startsWith('http')
                        // Network image from API
                            ? CachedNetworkImageProvider(imagePath) as ImageProvider
                        // Local file image
                            : FileImage(controller.getImageFile()!))
                            : const AssetImage(ImageAssets.userHome_userProfile),
                      );
                    }),
                    GestureDetector(
                      onTap: controller.pickImage,
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.cyan,
                        child: Icon(Icons.add, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // First Name
                _buildField(
                  controller.nameController,
                  "First Name",
                  focusNode: controller.nameFocus,
                  onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.mobileFocus),
                ),

                // Last Name
                _buildField(
                  controller.lastNameController,
                  "Last Name",
                  focusNode: FocusNode(),
                  onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.mobileFocus),
                ),

                // Email (Read-only)
                _buildField(
                  controller.emailController,
                  "Email",
                  readOnly: true,
                  suffixIcon: const Icon(Icons.lock_outline, color: Colors.white54, size: 18),
                ),

                // Mobile Number
                _buildField(
                  controller.mobileController,
                  "Mobile Number",
                  keyboard: TextInputType.phone,
                  focusNode: controller.mobileFocus,
                  onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.ageFocus),
                ),

                // Age
                _buildField(
                  controller.ageController,
                  "Your Age",
                  keyboard: TextInputType.number,
                  focusNode: controller.ageFocus,
                  onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.weightFocus),
                ),

                // Weight
                _buildField(
                  controller.weightController,
                  "Your Weight (kg)",
                  keyboard: TextInputType.number,
                  focusNode: controller.weightFocus,
                  onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.sexFocus),
                ),

                // Sex
                _buildField(
                  controller.sexController,
                  "Your Sex (male/female/other)",
                  focusNode: controller.sexFocus,
                  onSubmitted: (_) => FocusScope.of(context).unfocus(),
                ),

                const SizedBox(height: 30),

                // Save Button
                Obx(() => RoundButton(
                  title: controller.isSaving.value ? "Saving..." : "Save",
                  width: double.infinity,
                  loading: controller.isSaving.value,
                  onPress: controller.isSaving.value ? () {} : controller.saveProfile,
                )),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildField(
      TextEditingController controller,
      String hint, {
        bool readOnly = false,
        TextInputType keyboard = TextInputType.text,
        FocusNode? focusNode,
        Function(String)? onSubmitted,
        Widget? suffixIcon,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboard,
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: Colors.white),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          suffixIcon: suffixIcon,
          fillColor: readOnly ? Colors.white.withOpacity(0.05) : Colors.transparent,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: readOnly ? Colors.white10 : Colors.white30,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.cyan),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}