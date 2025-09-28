import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../resource/Colors/app_colors.dart';

class Utils {
  /// Changes focus from one field to another
  static void fieldFocusChange(BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  /// Basic toast message
  static void toastMessage(String massage) {
    Fluttertoast.showToast(
      msg: massage,
      backgroundColor: AppColor.iconColor,
      gravity: ToastGravity.CENTER,
    );
  }

  /// Generic info snackbar (default style)
  static void infoSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColor.iconColor,
      colorText: AppColor.primaryTextColor,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  /// Success-style snackbar
  static void successSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF4CAF50), // Green
      colorText:  AppColor.primaryTextColor,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  /// Error-style snackbar
  static void errorSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFF44336), // Red
      colorText:  AppColor.primaryTextColor,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }
}
