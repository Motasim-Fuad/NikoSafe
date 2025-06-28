import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/View_Model/Controller/provider/providerProfileController/provider_edit_profile_controller.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';

import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';

class ProviderEditProfileForm extends StatelessWidget {
  final controller = Get.put(ProviderEditProfileController());
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      controller.setProfileImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: controller.profileImage.value != null
                      ? FileImage(controller.profileImage.value!)
                      : const AssetImage(ImageAssets.userHome_peopleProfile4) as ImageProvider,
                ),
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Availability Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text("Availability", style: TextStyle(color: Colors.white)),
                    value: controller.profile.value.isAvailable,
                    onChanged: controller.toggleAvailability,
                    activeColor: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: "From (Date)",
                          controller: controller.availFromDateController,
                          readOnly: true,
                          onTap: () => controller.pickDate(controller.availFromDateController),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          label: "To (Date)",
                          controller: controller.availToDateController,
                          readOnly: true,
                          onTap: () => controller.pickDate(controller.availToDateController),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: "From (Time)",
                          controller: controller.availFromTimeController,
                          readOnly: true,
                          onTap: () => controller.pickTime(controller.availFromTimeController),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          label: "To (Time)",
                          controller: controller.availToTimeController,
                          readOnly: true,
                          onTap: () => controller.pickTime(controller.availToTimeController),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            CustomTextField(
              label: "Full Name",
              controller: controller.fullNameController,
              focusNode: controller.fullNameFocus,
            ),
            const SizedBox(height: 10),
            CustomTextField(label: "Job Title", controller: controller.jobTitleController, focusNode: controller.jobTitleFocus),
            const SizedBox(height: 10),
            CustomTextField(label: "Email", controller: controller.emailController, focusNode: controller.emailFocus),
            const SizedBox(height: 10),
            CustomTextField(label: "Mobile Number", controller: controller.phoneController, focusNode: controller.phoneFocus),
            const SizedBox(height: 10),
            CustomTextField(label: "Desired Pay Rate", controller: controller.payRateController, focusNode: controller.payRateFocus),
            const SizedBox(height: 10),
            CustomTextField(label: "Location", controller: controller.locationController, focusNode: controller.locationFocus),
            const SizedBox(height: 10),
            CustomTextField(label: "Service Radius", controller: controller.radiusController, focusNode: controller.radiusFocus),
            const SizedBox(height: 10),
            CustomTextField(label: "About Me", controller: controller.aboutController, minLines: 4, maxLines: 5, focusNode: controller.aboutFocus),
            const SizedBox(height: 10),
            CustomTextField(label: "Certifications", controller: controller.cirtificationsController, minLines: 3, maxLines: 5, focusNode: controller.certificationsFocus),
            const SizedBox(height: 10),
            CustomTextField(label: "Years of Experience", controller: controller.expriencesController, focusNode: controller.experienceFocus),


            const SizedBox(height: 20),
            RoundButton(title: "Save", width: double.infinity, onPress: controller.saveProfile),
          ],
        ),
      );
    });
  }
}
