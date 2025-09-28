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
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Name
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

                // Last Name
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

                // Mobile Number
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

                // Age
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

                // Weight
                buildInput(
                  controller.weightController,
                  "Your Weight (kg)",
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

                // Gender Dropdown
                buildDropdown(
                  "Your Gender",
                  dropdownBackgroundColor: AppColor.topLinear,
                  fillColor: AppColor.iconColor,
                  controller.selectedSex,
                  controller.sexOptions,
                  errorText: controller.sexError,
                ),

                // Email
                buildInput(
                  controller.emailController,
                  "Email",
                  focusNode: controller.emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  errorText: controller.emailError,
                ),

                const SizedBox(height: 10),

                // Terms & Conditions
                buildTermsCheckForUser(controller),

                const SizedBox(height: 20),

                // Register Button
                Obx(() =>
                    RoundButton(
                      title: controller.loading.value ?"Registering.....":"Register",
                      loading: controller.loading.value,
                      showLoader: true,
                      width: double.infinity,
                      shadowColor: AppColor.buttonShadeColor,

                      onPress: controller.loading.value
                          ? () {} // Empty callback instead of null
                          : () {
                        controller.signup();
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