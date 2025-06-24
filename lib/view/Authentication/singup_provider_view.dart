import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../View_Model/Controller/authentication/servise_providerAuthenticationController.dart';
import '../../resource/Colors/app_colors.dart';
import '../../resource/compunents/RoundButton.dart';
import 'widgets/common_widget.dart'; // Ensure this is imported

class SignupProviderView extends StatelessWidget {
  final ServiceProviderAuthController controller;

   SignupProviderView({required this.controller,});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildInput(
            controller.nameController, // Use provider-specific controller
            "Full Name",
            errorText: controller.nameError, // Use provider-specific error
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
          ),
          buildInput(
            controller.emailController, // Use provider-specific controller
            "Email",
            errorText: controller.emailError, // Use provider-specific error
            keyboardType: TextInputType.emailAddress,
          ),

          buildDropdown(
            "Your Designation",
            controller.selectedJob, // Use provider-specific RxString
            controller.jobList,
            errorText: controller.jobError, // Use provider-specific error
          ),
          buildInput(
            controller.phoneController, // Use provider-specific controller
            "Mobile Number",
            errorText: controller.phoneError, // Use provider-specific error
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
          ),
          buildInput(
            controller.passwordController, // Use provider-specific controller
            "Password",
            isPassword: true,
            isPasswordVisible: controller.isPasswordVisible,
            errorText: controller.passwordError, // Use provider-specific error
          ),

          buildInput(
            controller.locationController, // Use provider-specific controller
            "Location",
            errorText: controller.locationError, // Use provider-specific error
            keyboardType: TextInputType.streetAddress,
          ),
          buildUploadBoxForProvider(controller), // Assuming image upload is common
          const SizedBox(height: 10),
          buildTermsCheckForSearviesProvider(controller), // Assuming terms check is common
          const SizedBox(height: 20),
          Obx(
                () =>  RoundButton(
              title: "Verify Email",
               loading: controller.loading.value,
               showLoader: true,
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