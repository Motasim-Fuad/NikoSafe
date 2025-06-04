import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import '../../../../View_Model/Controller/user/userHome/poll_controller.dart';
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
        iconTheme: const IconThemeData(color: Colors.white), // Back button color
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
                          TextField(
                            controller: controller.titleController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Poll Title",
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("Options", style: TextStyle(color: Colors.white)),
                          const SizedBox(height: 8),
                          ...List.generate(controller.options.length, (index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller.options[index],
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "Option ${index + 1}",
                                      hintStyle: const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => controller.removeOption(index),
                                ),
                              ],
                            );
                          }),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: controller.addOption,
                            icon: const Icon(Icons.add, color: Colors.cyan),
                            label: const Text("Add Option", style: TextStyle(color: Colors.cyan)),
                          ),

                          Obx((){
                            return   RoundButton(
                              width: double.infinity,
                              loading: controller.isLoading.value,
                              title: "Submit Poll",
                              onPress: () {
                                controller.submitPoll();
                              },
                            );
                          }),

                          const SizedBox(height: 5),
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
