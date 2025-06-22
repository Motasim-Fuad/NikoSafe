import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/Authentication/widgets/common_widget.dart';
import '../../View_Model/Controller/authentication/authentication_view_model.dart';

class SignupUserView extends StatelessWidget {
  final AuthViewModel controller;
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
                controller.userNameController, // Use user-specific controller
                "Full Name",
                errorText: controller.userNameError, // Use user-specific error
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
              ),
              buildInput(
                controller.userPhoneController, // Use user-specific controller
                "Mobile Number",
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                errorText: controller.userPhoneError, // Use user-specific error
              ),
              buildInput(
                controller.userAgeController, // Use user-specific controller
                "Your Age",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                errorText: controller.userAgeError, // Use user-specific error
              ),
              buildInput(
                controller.userWeightController, // Use user-specific controller
                "Your Weight",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                errorText: controller.userWeightError, // Use user-specific error
              ),
              buildDropdown(
                "Your Gender",

                controller.userSelectedSex, // Use user-specific RxString
                controller.sexOptions,
                errorText: controller.userSexError, // Use user-specific error
              ),
              buildInput(
                controller.userEmailController, // Use user-specific controller
                "Email",
                keyboardType: TextInputType.emailAddress,
                errorText: controller.userEmailError, // Use user-specific error
              ),
              buildInput(
                controller.userPasswordController, // Use user-specific controller
                "Password",
                isPassword: true,
                isPasswordVisible: controller.isPasswordVisible,
                errorText: controller.userPasswordError, // Use user-specific error
              ),

              const SizedBox(height: 10),
              buildTermsCheck(controller),
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