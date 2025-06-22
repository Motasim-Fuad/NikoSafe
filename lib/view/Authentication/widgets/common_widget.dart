import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/authentication/vendorController.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

import '../../../View_Model/Controller/authentication/authentication_view_model.dart';

Widget buildInput(
    TextEditingController controller,
    String hint, {
      bool isPassword = false,
      RxBool? isPasswordVisible,
      TextInputType keyboardType = TextInputType.text,
      List<TextInputFormatter>? inputFormatters,
      Rxn<String>? errorText,
    }) {
  if (isPassword && isPasswordVisible == null) {
    throw Exception("isPasswordVisible RxBool must be provided for password fields.");
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: isPassword
        ? Obx(() => TextField(
      controller: controller,
      obscureText: !isPasswordVisible!.value,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF2B3A42),
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
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF2B3A42),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}

Widget buildTermsCheck(AuthViewModel controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center, // center vertically
      children: [
        Obx(
              () => Checkbox(
            value: controller.agreeTerms.value,
            onChanged: (val) => controller.agreeTerms.value = val ?? false,
            checkColor: Colors.white,
            activeColor: const Color(0xFF00D1B7),
          ),
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              children: [
                const TextSpan(text: "I agree to the "),
                TextSpan(
                  text: "Terms & Conditions",
                  style: const TextStyle(color: Color(0xFF00D1B7)),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: const TextStyle(color: Color(0xFF00D1B7)),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildRemember(AuthViewModel controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center, // center vertically
      children: [
        Obx(
              () => Checkbox(
            value: controller.agreeTerms.value,
            onChanged: (val) => controller.agreeTerms.value = val ?? false,
            checkColor: Colors.white,
            activeColor: const Color(0xFF00D1B7),
          ),
        ),
        Text(
          "Remember Me ",
          style: TextStyle(fontSize: 15, color: AppColor.primaryTextColor),
        ),
      ],
    ),
  );
}

// Updated buildDropdown to include errorText
Widget buildDropdown(
    String label,
    RxString selected,
    List<String> items, {
      Rxn<String>? errorText,
    }) {
  return Obx(
        () => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: (selected.value.isEmpty || !items.contains(selected.value)) ? null : selected.value,
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(
            e,
            style: TextStyle(
              color: AppColor.secondaryTextColor, // Dropdown item text color
            ),
          ),
        ))
            .toList(),
        onChanged: (val) {
          selected.value = val ?? "";
          if (errorText != null) {
            errorText.value = null;
          }
        },
        dropdownColor: const Color(0xFF2B3A42),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF2B3A42),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white54, // <-- White label text color
          ),
          errorText: errorText?.value,
        ),
        style: TextStyle(
          color: AppColor.secondaryTextColor, // Selected item text color
        ),
      ),
    ),
  );
}

Widget buildUploadBox(AuthViewModel controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Upload your necessary documents.",
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
            width: 120,
            height: 120,
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



// vendor

Widget buildUploadBoxforvendor(VendorSignupViewModel controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Your necessary documents",
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
            width: 120,
            height: 120,
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

// Widget buildTermsCheckvendor(VendorSignupViewModel controller) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 12),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center, // center vertically
//       children: [
//         Obx(
//               () => Checkbox(
//             value: controller.agreeTerms.value,
//             onChanged: (val) => controller.agreeTerms.value = val ?? false,
//             checkColor: Colors.white,
//             activeColor: const Color(0xFF00D1B7),
//           ),
//         ),
//         Flexible(
//           child: RichText(
//             text: TextSpan(
//               style: const TextStyle(color: Colors.white, fontSize: 14),
//               children: [
//                 const TextSpan(text: "I agree to the "),
//                 TextSpan(
//                   text: "Terms & Conditions",
//                   style: const TextStyle(color: Color(0xFF00D1B7)),
//                 ),
//                 const TextSpan(text: " and "),
//                 TextSpan(
//                   text: "Privacy Policy",
//                   style: const TextStyle(color: Color(0xFF00D1B7)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }