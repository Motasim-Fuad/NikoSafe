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
                controller.firstNameController,
                "First Name",
                errorText: controller.firstnameError,
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
              ),
              buildInput(
                controller.lastNameController,
                "Last Name",
                errorText: controller.lastnameError,
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
                errorText: controller.ageError,
              ),
              buildInput(
                controller.weightController,
                "Your Weight",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                errorText: controller.weightError,
              ),
              buildDropdown(
                "Your Gender",
                dropdownBackgroundColor: AppColor.topLinear,
                fillColor: AppColor.iconColor,

                controller.selectedSex,
                controller.sexOptions,
                errorText: controller.sexError,
              ),
              buildInput(
                controller.emailController,
                "Email",
                keyboardType: TextInputType.emailAddress,
                errorText: controller.emailError,
              ),
              buildInput(
                controller.passwordController,
                "Password",
                isPassword: true,
                isPasswordVisible: controller.isPasswordVisible,
                errorText: controller.passwordError,
              ),

              const SizedBox(height: 10),
              buildTermsCheckForUser(controller),
              const SizedBox(height: 20),
              Obx(()=>
                RoundButton(
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
        ),
      ),
    );
  }
}