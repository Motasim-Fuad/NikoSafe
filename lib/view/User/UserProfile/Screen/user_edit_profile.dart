import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
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
              _buildField(
                controller.nameController,
                "Full Name",
                focusNode: controller.nameFocus,
                onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.mobileFocus),
              ),
              _buildField(
                controller.mobileController,
                "Mobile Number",
                keyboard: TextInputType.phone,
                focusNode: controller.mobileFocus,
                onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.ageFocus),
              ),
              _buildField(
                controller.ageController,
                "Your Age",
                keyboard: TextInputType.number,
                focusNode: controller.ageFocus,
                onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.weightFocus),
              ),
              _buildField(
                controller.weightController,
                "Your Weight",
                keyboard: TextInputType.number,
                focusNode: controller.weightFocus,
                onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.sexFocus),
              ),
              _buildField(
                controller.sexController,
                "Your Sex",
                focusNode: controller.sexFocus,
                onSubmitted: (_) => FocusScope.of(context).requestFocus(controller.locationFocus),
              ),
              _buildField(
                controller.locationController,
                "Location",
                focusNode: controller.locationFocus,
              ),
              const SizedBox(height: 30),

              RoundButton(title: "Save", width: double.infinity,onPress: (){
                controller.saveProfile();
              })

            ],
          ),
        ),
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
