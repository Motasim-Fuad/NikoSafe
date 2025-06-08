import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

import '../../../../../../../View_Model/Controller/user/MyProfile/settings/UserSttingController/user_setting_controller.dart';
 // import the controller above

class PasswordField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  final UserSettingPasswordController _passwordController = Get.put(UserSettingPasswordController());

  PasswordField({
    Key? key,
    required this.controller,
    this.label = 'Password',
    this.hint = 'Enter your password',
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
      controller: controller,
      obscureText: _passwordController.isObscure.value,
      validator: validator,
      style: TextStyle(color: AppColor.primaryTextColor),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: AppColor.primaryTextColor),
        hintStyle: TextStyle(color: AppColor.primaryTextColor),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordController.isObscure.value
                ? Icons.visibility_off
                : Icons.visibility,
            color: AppColor.primaryTextColor,
          ),
          onPressed: _passwordController.toggleObscure,
        ),
        border: OutlineInputBorder(),
      ),
    ));
  }
}
