
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/post/createPost/user_create_post_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/User/UserHome/CreatePost/widgets/privacy_puppup.dart';


class UserCreatePostView extends GetView<UserCreatePostController> {
  const UserCreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          title: Text('Create Post', style: TextStyle(color: AppColor.primaryTextColor)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Privacy Options
              PrivacyPopup(),
              const SizedBox(height: 20),

              // Description Input
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.iconColor,
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(color: Colors.white70),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.white)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Add Tags Input
              const Text(
                'Add Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.iconColor,
                  border: OutlineInputBorder(),
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Add Photo Section
              const Text(
                'Add Photos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),

              // Image picker options
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await controller.addSinglePhoto();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor.iconColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade700),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Gallery', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await controller.takePhoto();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor.iconColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade700),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Camera', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await controller.addPhoto();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor.iconColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade700),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library_outlined, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Multiple', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Selected Images Display
              Obx(() => controller.selectedImages.isEmpty
                  ? SizedBox.shrink()
                  : Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.selectedImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(controller.selectedImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () => controller.removeImage(index),
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),

              const SizedBox(height: 20),

              // Add Location Button
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    await controller.navigateToAddLocation();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      controller.selectedLocation.value != null
                          ? 'Location: ${controller.selectedLocation.value!.name}'
                          : 'Add Location',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
              SizedBox(height: 20),

              // Post Button
              Obx(() {
                return RoundButton(
                  width: double.infinity,
                  loading: controller.isPosting.value,
                  title: "Post",
                  onPress: controller.isPosting.value ? () {} : () async {
                    await controller.createPost();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}