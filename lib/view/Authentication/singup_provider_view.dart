import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../View_Model/Controller/authentication/authentication_view_model.dart';
import '../../resource/Colors/app_colors.dart';
import '../../resource/compunents/RoundButton.dart';
import 'widgets/common_widget.dart'; // Ensure this is imported

class SignupProviderView extends StatelessWidget {
  final AuthViewModel controller;
  const SignupProviderView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildInput(
            controller.providerNameController, // Use provider-specific controller
            "Full Name",
            errorText: controller.providerNameError, // Use provider-specific error
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
          ),
          buildInput(
            controller.providerEmailController, // Use provider-specific controller
            "Email",
            errorText: controller.providerEmailError, // Use provider-specific error
            keyboardType: TextInputType.emailAddress,
          ),
          buildDropdown(
            "Job Title",
            controller.providerSelectedJob, // Use provider-specific RxString
            controller.jobList,
            errorText: controller.providerJobError, // Use provider-specific error
          ),
          buildInput(
            controller.providerPhoneController, // Use provider-specific controller
            "Mobile Number",
            errorText: controller.providerPhoneError, // Use provider-specific error
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
          ),
          buildInput(
            controller.providerPasswordController, // Use provider-specific controller
            "Password",
            isPassword: true,
            isPasswordVisible: controller.isPasswordVisible,
            errorText: controller.providerPasswordError, // Use provider-specific error
          ),
          buildInput(
            controller.providerBirthController, // Use provider-specific controller
            "Birth Date (DD/MM/YYYY)",
            errorText: controller.providerBirthDateError, // Use provider-specific error
            keyboardType: TextInputType.datetime,
            inputFormatters: [
              // Optionally add a date input formatter if needed for strict format
            ],
          ),
          buildInput(
            controller.providerLocationController, // Use provider-specific controller
            "Location",
            errorText: controller.providerLocationError, // Use provider-specific error
            keyboardType: TextInputType.streetAddress,
          ),
          buildUploadBox(controller), // Assuming image upload is common
          const SizedBox(height: 10),
          buildTermsCheck(controller), // Assuming terms check is common
          const SizedBox(height: 20),
          Obx(
                () => controller.loading.value
                ? const CircularProgressIndicator()
                : RoundButton(
              title: "Verify Email",
              width: double.infinity,
              shadowColor: AppColor.buttonShadeColor,
              onPress: () {
                controller.signup(); // Calls the central signup method
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}