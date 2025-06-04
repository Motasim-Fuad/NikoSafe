import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const CustomBackButton({
    Key? key,
    this.onTap,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap ?? () => Get.back(),
      icon: CircleAvatar(
        radius: 20,
        backgroundColor: backgroundColor ?? AppColor.iconColor,
        child: Icon(
          Icons.arrow_back_ios_new,
          color: AppColor.primaryTextColor,
          size: 15,
        ),
      ),
    );
  }
}
