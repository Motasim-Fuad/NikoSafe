// lib/view/User/BottomSheets/task_request_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';


import '../../../../../../View_Model/Controller/user/userSearch/userServiceProviderController/task_request_controller.dart';

class TaskRequestBottomSheet extends StatelessWidget {
  TaskRequestBottomSheet({super.key});

  final controller = Get.put(TaskRequestController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1B2A3C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Task Title"),
            CustomTextField(controller: controller.taskTitle),

            const SizedBox(height: 16),
            _buildLabel("Task Description"),
            CustomTextField(
              controller: controller.taskDescription,
              hintText: "Describe the work needed",
            ),

            const SizedBox(height: 16),
            _buildLabel("Estimated Time"),
            CustomTextField(controller: controller.estimateTime),

            const SizedBox(height: 16),
            _buildLabel("Preferred Time"),
            CustomTextField(controller: controller.preferredTime),

            const SizedBox(height: 16),
            _buildLabel("Upload a photo of the project"),
            const SizedBox(height: 12),

            GestureDetector(
              onTap: controller.pickImage,
              child: Obx(() {
                final image = controller.pickedImage.value;
                return Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E50),
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: image != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(image, fit: BoxFit.cover),
                  )
                      : const Center(
                    child: Icon(Icons.upload, size: 40, color: Colors.white54),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),
            RoundButton(
              width: double.infinity,
              title: "Send",
              onPress: controller.submitTask,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(color: Colors.white),
  );
}
