import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';

class EmailView extends StatelessWidget {
  const EmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    String userEmail = args?["email"] ?? "";

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Verify your email",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: CircleAvatar(
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColor.primaryTextColor,
                size: 15,
              ),
              backgroundColor: Color(0xff525f67),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(ImageAssets.emailIcon),
                SizedBox(height: 20),
                Text(
                  "Check Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: AppColor.primaryTextColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "We've sent a 4-digit verification code to:",
                  style: TextStyle(color: AppColor.primaryTextColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: AppColor.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  "Please check your email and enter the code below.",
                  style: TextStyle(color: AppColor.primaryTextColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                RoundButton(
                  title: "Enter Code",
                  shadowColor: AppColor.buttonShadeColor,
                  width: double.infinity,
                  onPress: () {
                    Get.toNamed(
                      RouteName.oTPView,
                      arguments: {'email': userEmail},
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}