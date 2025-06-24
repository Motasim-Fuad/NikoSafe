import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/Authentication/widgets/common_widget.dart';
import '../../View_Model/Controller/authentication/userAuthenticationController.dart';

class SignupUserView extends StatelessWidget {
  final UserAuthController controller;
  const SignupUserView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInput(
                controller.nameController, // Use user-specific controller
                "Full Name",
                errorText: controller.nameError, // Use user-specific error
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
              ),
              buildInput(
                controller.phoneController, // Use user-specific controller
                "Mobile Number",
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                errorText: controller.phoneError, // Use user-specific error
              ),
              buildInput(
                controller.ageController, // Use user-specific controller
                "Your Age",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                errorText: controller.ageError, // Use user-specific error
              ),
              buildInput(
                controller.weightController, // Use user-specific controller
                "Your Weight",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                errorText: controller.weightError, // Use user-specific error
              ),
              buildDropdown(
                "Your Gender",

                controller.selectedSex, // Use user-specific RxString
                controller.sexOptions,
                errorText: controller.sexError, // Use user-specific error
              ),
              buildInput(
                controller.emailController, // Use user-specific controller
                "Email",
                keyboardType: TextInputType.emailAddress,
                errorText: controller.emailError, // Use user-specific error
              ),
              buildInput(
                controller.passwordController, // Use user-specific controller
                "Password",
                isPassword: true,
                isPasswordVisible: controller.isPasswordVisible,
                errorText: controller.passwordError, // Use user-specific error
              ),

              const SizedBox(height: 10),
              buildTermsCheckForUser(controller),
              const SizedBox(height: 20),
              Obx(
                    () => controller.loading.value
                    ? const Center(child: CircularProgressIndicator())
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
        ),
      ),
    );
  }
}