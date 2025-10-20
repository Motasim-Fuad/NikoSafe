import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userSearch/userServiceProviderController/task_request_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class TaskRequestBottomSheetView extends StatelessWidget {
  final int providerId;

  TaskRequestBottomSheetView({super.key, required this.providerId});

  final controller = Get.put(TaskRequestController());

  @override
  Widget build(BuildContext context) {
    controller.providerId = providerId;

    // ✅ FIX: Wrap with Scaffold to provide Material context
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFF1B2A3C) ,
        leading: CustomBackButton(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Task",style: TextStyle(color: AppColor.primaryTextColor),),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1B2A3C),
          // borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Task Title *"),
              CustomTextField(controller: controller.taskTitle),

              const SizedBox(height: 16),
              _buildLabel("Task Description *"),
              CustomTextField(
                controller: controller.taskDescription,
                hintText: "Describe the work needed",
                minLines: 3,
                maxLines: 5,
              ),

              const SizedBox(height: 16),
              _buildLabel("Location"),
              CustomTextField(controller: controller.locationController),

              const SizedBox(height: 16),
              _buildLabel("Estimated Hours *"),
              CustomTextField(
                controller: controller.estimateTime,
                keyboardType: TextInputType.number,
                onChanged: (_) => controller.calculateTotalAmount(),
              ),

              const SizedBox(height: 16),
              _buildLabel("Hourly Rate *"),
              CustomTextField(
                controller: controller.hourlyRateController,
                keyboardType: TextInputType.number,
                onChanged: (_) => controller.calculateTotalAmount(),
              ),

              const SizedBox(height: 16),
              _buildLabel("Total Amount"),
              Obx(() => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3E50),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.lime),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      "৳ ${controller.totalAmount.value.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.lime,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),

              const SizedBox(height: 16),
              _buildLabel("Preferred Time"),
              GestureDetector(
                onTap: () => controller.selectTime(context),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: controller.preferredTime,
                    hintText: "Select time",
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _buildLabel("Upload Photos (Optional)"),
              const SizedBox(height: 12),

              Obx(() {
                return Column(
                  children: [
                    if (controller.pickedImages.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.pickedImages.asMap().entries.map((entry) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  entry.value,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => controller.removeImage(entry.key),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, size: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C3E50),
                          border: Border.all(color: Colors.white30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 40, color: Colors.white54),
                              SizedBox(height: 8),
                              Text("Add Images", style: TextStyle(color: Colors.white54)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 24),
              Obx(() => RoundButton(
                width: double.infinity,
                title: "Send Request",
                onPress: controller.submitTask,
                loading: controller.loading.value,
              )),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(color: Colors.white),
  );
}