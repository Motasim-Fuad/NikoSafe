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
        child: GestureDetector(
          onTap:()=> FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInput(
                  controller.firstNameController,
                  "First Name",
                  focusNode: controller.firstNameFocus,
                  nextFocusNode: controller.lastNameFocus,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                  errorText: controller.firstnameError,
                ),
                buildInput(
                  controller.lastNameController,
                  "Last Name",
                  focusNode: controller.lastNameFocus,
                  nextFocusNode: controller.phoneFocus,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                  errorText: controller.lastnameError,
                ),
                buildInput(
                  controller.phoneController,
                  "Mobile Number",
                  focusNode: controller.phoneFocus,
                  nextFocusNode: controller.ageFocus,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                  errorText: controller.phoneError,
                ),
                buildInput(
                  controller.ageController,
                  "Your Age",
                  focusNode: controller.ageFocus,
                  nextFocusNode: controller.weightFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  errorText: controller.ageError,
                ),
                buildInput(
                  controller.weightController,
                  "Your Weight",
                  focusNode: controller.weightFocus,
                  nextFocusNode: controller.emailFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
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
                  focusNode: controller.emailFocus,
                  nextFocusNode: controller.passwordFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  errorText: controller.emailError,
                ),
                buildInput(
                  controller.passwordController,
                  "Password",
                  isPassword: true,
                  isPasswordVisible: controller.isPasswordVisible,
                  focusNode: controller.passwordFocus,
                  textInputAction: TextInputAction.done,
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
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}