import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/View_Model/Controller/authentication/userAuthenticationController.dart';
import 'package:nikosafe/View_Model/Controller/authentication/vendorController.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

import '../../../View_Model/Controller/authentication/authTapView.dart';
import '../../../View_Model/Controller/authentication/login_authentication_controller.dart';
import '../../../View_Model/Controller/authentication/servise_providerAuthenticationController.dart';

// Updated common widgets that work with the new controllers
Widget buildInput(
    TextEditingController controller,
    String hint, {
      bool isPassword = false,
      RxBool? isPasswordVisible,
      TextInputType keyboardType = TextInputType.text,
      List<TextInputFormatter>? inputFormatters,
      Rxn<String>? errorText,
      FocusNode? focusNode,
      FocusNode? nextFocusNode, // <-- NEW PARAM
      TextInputAction textInputAction = TextInputAction.next, // <-- NEW PARAM
    }) {
  if (isPassword && isPasswordVisible == null) {
    throw Exception("isPasswordVisible RxBool must be provided for password fields.");
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: isPassword
        ? Obx(() => TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: !isPasswordVisible!.value,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(Get.context!).requestFocus(nextFocusNode);
        } else {
          FocusScope.of(Get.context!).unfocus();
        }
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColor.iconColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorText: errorText?.value,
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible.value
                ? Icons.visibility
                : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            isPasswordVisible.value = !isPasswordVisible.value;
          },
        ),
      ),
    ))
        : TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(Get.context!).requestFocus(nextFocusNode);
        } else {
          FocusScope.of(Get.context!).unfocus();
        }
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColor.iconColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorText: errorText?.value,
      ),
    ),
  );
}


Widget buildSubmitButton(String text, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00D1B7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}




// tarms and conditions  start
Widget buildTermsCheckForUser(UserAuthController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
              () => Checkbox(
            value: controller.agreeTerms.value,
            onChanged: (val) => controller.agreeTerms.value = val ?? false,
            checkColor: Colors.white,
            activeColor: const Color(0xFF00D1B7),
            side: BorderSide(color: Colors.white),
          ),
        ),
        Expanded(
          child: Text(
            " I agree to the Terms & Conditions and Privacy Policy ",
            style: TextStyle(color: AppColor.secondaryTextColor),
          ),
        ),
      ],
    ),
  );
}

Widget buildTermsCheckForSearviesProvider(ServiceProviderAuthController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
              () => Checkbox(
            value: controller.agreeTerms.value,
            onChanged: (val) => controller.agreeTerms.value = val ?? false,
            checkColor: Colors.white,
            activeColor: const Color(0xFF00D1B7),
            side: BorderSide(color: Colors.white),
          ),
        ),
        Expanded(
          child: Text(
            " I agree to the Terms & Conditions and Privacy Policy ",
            style: TextStyle(color: AppColor.secondaryTextColor),
          ),
        ),
      ],
    ),
  );
}
Widget buildTermsCheckForVendor(VendorAuthController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
              () => Checkbox(
            value: controller.agreeTerms.value,
            onChanged: (val) => controller.agreeTerms.value = val ?? false,
            checkColor: Colors.white,
            activeColor: const Color(0xFF00D1B7),
            side: BorderSide(color: Colors.white),
          ),
        ),
        Expanded(
          child: Text(
            " I agree to the Terms & Conditions and Privacy Policy ",
            style: TextStyle(color: AppColor.secondaryTextColor),
          ),
        ),
      ],
    ),
  );
}
Widget buildTermsCheck(LoginAuthController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
              () => Checkbox(
            value: controller.rememberMe.value,
            onChanged: (val) => controller.rememberMe.value = val ?? false,
            checkColor: Colors.white,
            activeColor: const Color(0xFF00D1B7),
          ),
        ),

        Text(" I agree to the Terms & Conditions and Privacy Policy "),

      ],
    ),
  );
}
// tarms and conditions  end

Widget buildRemember(LoginAuthController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
              () => Checkbox(
            value: controller.rememberMe.value,
            onChanged: (val) => controller.rememberMe.value = val ?? false,
            checkColor: Colors.white,
            activeColor: const Color(0xFF00D1B7),
            side: BorderSide(color: Colors.white),
          ),
        ),
        Text(
          "Remember Me",
          style: TextStyle(fontSize: 15, color: AppColor.primaryTextColor),
        ),
      ],
    ),
  );
}

Widget buildDropdown(
    String label,
    RxString selected,
    List<String> items, {
      Rxn<String>? errorText,
      Color? dropdownBackgroundColor,
      Color? itemTextColor,
      Color? fillColor,
      Color? borderColor,
      Color? labelColor,
      Color? iconColor,
      TextStyle? itemTextStyle,
      TextStyle? labelTextStyle,
    }) {
  return Obx(
        () => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: (selected.value.isEmpty || !items.contains(selected.value))
            ? null
            : selected.value,
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Container(
            // Background color for each item (optional)
            color: Colors.transparent,
            child: Text(
              e,
              style: itemTextStyle ??
                  TextStyle(
                    color: itemTextColor ?? AppColor.secondaryTextColor,
                  ),
            ),
          ),
        ))
            .toList(),
        onChanged: (val) {
          selected.value = val ?? "";
          if (errorText != null) errorText.value = null;
        },
        dropdownColor: dropdownBackgroundColor ?? const Color(0xFF2B3A42),
        iconEnabledColor: iconColor ?? Colors.white, // Dropdown arrow color
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? const Color(0xFF2B3A42),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: borderColor ?? Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: borderColor ?? Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: borderColor ?? Colors.white,
              width: 1.5,
            ),
          ),
          labelText: label,
          labelStyle: labelTextStyle ??
              TextStyle(
                color: labelColor ?? Colors.white54,
              ),
          errorText: errorText?.value,
        ),
        style: itemTextStyle ??
            TextStyle(
              color: itemTextColor ?? AppColor.secondaryTextColor,
            ),
      ),
    ),
  );
}


Widget buildUploadBoxForProvider(ServiceProviderAuthController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Upload Your Necessary Document",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColor.primaryTextColor,
        ),
      ),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: controller.pickImage,
        child: Obx(() {
          final image = controller.pickedImage.value;
          return Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(image, fit: BoxFit.cover),
            )
                : const Center(
              child: Icon(
                Icons.add_a_photo,
                size: 40,
                color: Colors.grey,
              ),
            ),
          );
        }),
      ),
    ],
  );
}


Widget buildUploadBoxForVendor(VendorAuthController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Upload Your License Card Here",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColor.primaryTextColor,
        ),
      ),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: controller.pickImage,
        child: Obx(() {
          final image = controller.pickedImage.value;
          return Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(image, fit: BoxFit.cover),
            )
                : const Center(
              child: Icon(
                Icons.add_a_photo,
                size: 40,
                color: Colors.grey,
              ),
            ),
          );
        }),
      ),
    ],
  );
}

