import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../View_Model/Controller/authentication/servise_providerAuthenticationController.dart';
import '../../resource/Colors/app_colors.dart';
import '../../resource/compunents/RoundButton.dart';
import 'widgets/common_widget.dart'; // Ensure this is imported

class SignupProviderView extends StatelessWidget {
  final ServiceProviderAuthController controller;
  SignupProviderView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildInput(
            controller.firstNameController,
            "First Name",
            focusNode: controller.firstNameFocus,
            nextFocusNode: controller.lastNameFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
            errorText: controller.firstNameError,
          ),
          buildInput(
            controller.lastNameController,
            "Last Name",
            focusNode: controller.lastNameFocus,
            nextFocusNode: controller.emailFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
            errorText: controller.lastNameError,
          ),
          buildInput(
            controller.emailController,
            "Email",
            focusNode: controller.emailFocus,
            nextFocusNode: controller.phoneFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            errorText: controller.emailError,
          ),
          buildDropdown(
            "Your Designation",
            controller.selectedJob,
            controller.jobList,
            errorText: controller.jobError,
            dropdownBackgroundColor: AppColor.topLinear,
            fillColor: AppColor.iconColor,
          ),
          buildInput(
            controller.phoneController,
            "Mobile Number",
            focusNode: controller.phoneFocus,
            nextFocusNode: controller.passwordFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
            errorText: controller.phoneError,
          ),
          buildInput(
            controller.passwordController,
            "Password",
            isPassword: true,
            isPasswordVisible: controller.isPasswordVisible,
            focusNode: controller.passwordFocus,
            nextFocusNode: controller.locationFocus,
            textInputAction: TextInputAction.next,
            errorText: controller.passwordError,
          ),
          buildInput(
            controller.locationController,
            "Location",
            focusNode: controller.locationFocus,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.streetAddress,
            errorText: controller.locationError,
          ),
          buildUploadBoxForProvider(controller),
          const SizedBox(height: 10),
          buildTermsCheckForSearviesProvider(controller),
          const SizedBox(height: 20),
          Obx(() => RoundButton(
            title: "Verify Email",
            loading: controller.loading.value,
            showLoader: true,
            width: double.infinity,
            shadowColor: AppColor.buttonShadeColor,
            onPress: () {
              controller.signup();
              FocusScope.of(context).unfocus();
            },
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
