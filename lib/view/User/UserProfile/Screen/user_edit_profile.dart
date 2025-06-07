import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import '../../../../View_Model/Controller/user/MyProfile/user_edit_profile.dart';


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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() => CircleAvatar(
                    radius: 45,
                    backgroundImage: controller.imagePath.value.isNotEmpty
                        ? FileImage(controller.getImageFile())
                        : const AssetImage(ImageAssets.userHome_userProfile) as ImageProvider,
                  )),
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
              _buildField(controller.nameController, "Full Name"),
              _buildField(controller.mobileController, "Mobile Number", keyboard: TextInputType.phone),
              _buildField(controller.ageController, "Your Age", keyboard: TextInputType.number),
              _buildField(controller.weightController, "Your Weight", keyboard: TextInputType.number),
              _buildField(controller.sexController, "Your Sex"),
              _buildField(controller.emailController, "Email address", readOnly: true),
              _buildField(controller.locationController, "Location"),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Save", style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint,
      {bool readOnly = false, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          fillColor: Colors.transparent,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white30),
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
