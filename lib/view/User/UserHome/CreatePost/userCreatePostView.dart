import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/User/UserHome/CreatePost/widgets/privacy_puppup.dart';

import '../../../../View_Model/Controller/user/userHome/createPost/user_create_post_controller.dart';
import '../../../../resource/compunents/customBackButton.dart';


class UserCreatePostView extends GetView<UserCreatePostController> {
  const UserCreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor, // ✅ Your custom gradient
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // ✅ Make Scaffold transparent
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent, // ✅ Transparent AppBar
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          title:  Text('Create Post',style: TextStyle(color: AppColor.primaryTextColor),),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              // Public/Private Toggle (Placeholder)
              PrivacyPuppup(),
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
                decoration:  InputDecoration(
                  filled: true,
                  fillColor: AppColor.iconColor,
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(color: Colors.white70),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder( borderSide: BorderSide(width: 1,color: Colors.white)),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Add Tags Input
              const Text(
                'Add Tags',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.tagsController,
                decoration:  InputDecoration(
                  filled: true,
                  fillColor: AppColor.iconColor,
                  border: OutlineInputBorder(),
                  hintText: "e.g., food, travel, nature (comma separated)",
                  hintStyle: TextStyle(color: Colors.white70)
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Add Photo Section
              const Text(
                'Add Photo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: controller.addPhoto,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.iconColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade700, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cloud_upload, size: 60, color: Colors.grey),
                      Text(
                        'Upload',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                    () => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ...controller.photoUrls.map((url) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () => controller.photoUrls.remove(url),
                          child: const Icon(Icons.cancel, color: Colors.red, size: 20),
                        ),
                      ),
                    )),
                    // Add more photo buttons
                    if (controller.photoUrls.length < 3) // Limit to 3 photos for demonstration
                      GestureDetector(
                        onTap: controller.addPhoto,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color:AppColor.iconColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade700, style: BorderStyle.solid),
                          ),
                          child: const Icon(Icons.add, size: 30, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),





              // Add Location Button
              Obx((){
                return GestureDetector(
                  onTap: (){
                    controller.navigateToAddLocation();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(controller.selectedLocation.value != null
                        ? ' Location: ${controller.selectedLocation.value!.name}'
                        : 'Add Location',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                );
              }),
SizedBox(height: 20,),
              // Post Button

              Obx((){
                return RoundButton(
                  width: double.infinity,
                  loading:controller.isPosting.value,
                    title: "Post",
                    onPress: (){
                  controller.isPosting.value ? null : controller.createPost();
                });
              }),

            ],
          ),
        ),
      ),
    );
  }
}