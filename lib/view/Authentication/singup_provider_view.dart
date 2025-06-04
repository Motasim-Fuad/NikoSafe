import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/view/Authentication/widgets/dropdowm/dropdown.dart';

import '../../View_Model/Controller/authentication/authentication_view_model.dart';
import '../../resource/Colors/app_colors.dart';
import '../../resource/compunents/RoundButton.dart';
import 'widgets/common_widget.dart';

class SignupProviderView extends StatelessWidget {
  final AuthViewModel controller;
  const SignupProviderView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInput(controller.nameController, "Full Name"),
        buildInput(controller.emailController, "Email"),
        buildDropdown("Job Title", controller.selectedJob, controller.jobList, controller),
        buildInput(controller.phoneController, "Mobile Number"),
        buildInput(
          controller.passwordController,
          "Password",
          isPassword: true,
          isPasswordVisible: controller.isPasswordVisible,
        ),
        buildInput(controller.birthController, "Birth Date"),
        buildInput(controller.locationController, "Location"),
        buildUploadBox(controller),
        const SizedBox(height: 10),
        buildTermsCheck(controller),
        const SizedBox(height: 20),
        Obx(() => controller.loading.value
            ? const CircularProgressIndicator()
            : RoundButton(title: "Verify Email", width: double.infinity,shadowColor: AppColor.buttonShadeColor,onPress: (){
    controller.signup();
    }),),
        const SizedBox(height: 20),
      ],
    );
  }
}
