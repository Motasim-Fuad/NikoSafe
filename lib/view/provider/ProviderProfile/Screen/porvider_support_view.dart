import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/FAQ&Suport/suport_controller.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import '../../../../resource/Colors/app_colors.dart';
import '../../../../resource/compunents/coustomTextField.dart';
import '../../../../resource/compunents/customBackButton.dart';

class ProviderSupportView extends StatelessWidget {
  ProviderSupportView({super.key});

  final SuportController controller = Get.put(SuportController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Support",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
        ),
        body: Obx(
              () => AbsorbPointer(
            absorbing: controller.isLoading.value,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      label: "Issue Title",
                      fillColor: AppColor.topLinear,
                      controller: controller.titleController,
                      focusNode: controller.titleFocus,
                      onSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(controller.descriptionFocus);
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      fillColor: AppColor.topLinear,
                      label: "Issue Description",
                      focusNode: controller.descriptionFocus,
                      controller: controller.descriptionController,
                      maxLines: 6,
                      minLines: 5,
                    ),
                    SizedBox(height: 50),
                    controller.isLoading.value
                        ? CircularProgressIndicator(
                      color: AppColor.limeColor,
                    )
                        : RoundButton(
                      title: "Submit",
                      width: double.infinity,
                      onPress: () => controller.submitSuport(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}