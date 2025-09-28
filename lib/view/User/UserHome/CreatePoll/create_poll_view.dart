import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import '../../../../View_Model/Controller/user/userHome/post/poll/poll_controller.dart';
import '../../../../resource/compunents/customBackButton.dart';

class CreatePollView extends StatelessWidget {
  const CreatePollView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PollController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        title: Text(
          "Create Poll",
          style: TextStyle(color: AppColor.primaryTextColor),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: AppColor.backGroundColor,
            ),
          ),
          // Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                    () => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          32,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // Poll Title
                          TextField(
                            controller: controller.titleController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Poll Title",
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                            ),
                            maxLength: 200,
                          ),
                          const SizedBox(height: 16),

                          // Optional Description
                          TextField(
                            controller: controller.textController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Description (Optional)",
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: "Add context to your poll...",
                              hintStyle: TextStyle(color: Colors.grey.shade600),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                            ),
                            maxLines: 3,
                            maxLength: 500,
                          ),
                          const SizedBox(height: 16),

                          // Options Section
                          Row(
                            children: [
                              Text(
                                "Poll Options",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${controller.options.length}/6",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Dynamic Options List
                          ...List.generate(controller.options.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controller.options[index],
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: "Option ${index + 1}",
                                        hintStyle: const TextStyle(color: Colors.grey),
                                        prefixIcon: Icon(
                                          Icons.radio_button_unchecked,
                                          color: Colors.cyan,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.cyan),
                                        ),
                                      ),
                                      maxLength: 100,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: controller.options.length > 2
                                        ? () => controller.removeOption(index)
                                        : null,
                                    tooltip: controller.options.length > 2
                                        ? "Remove option"
                                        : "Minimum 2 options required",
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 8),

                          // Add Option Button
                          TextButton.icon(
                            onPressed: controller.options.length < 6
                                ? controller.addOption
                                : null,
                            icon: Icon(
                              Icons.add,
                              color: controller.options.length < 6
                                  ? Colors.cyan
                                  : Colors.grey,
                            ),
                            label: Text(
                              "Add Option",
                              style: TextStyle(
                                color: controller.options.length < 6
                                    ? Colors.cyan
                                    : Colors.grey,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Submit Button
                          RoundButton(
                            width: double.infinity,
                            loading: controller.isLoading.value,
                            title: "Create Poll",
                            onPress: controller.isLoading.value
                                ? () {}
                                : () async {
                              await controller.submitPoll();
                            },
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}