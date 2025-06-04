import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';

class EmailView extends StatelessWidget {

  const EmailView({super.key , });

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    String userRole = args["role"];

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor, // LinearGradient should be defined in AppColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make Scaffold see-through
        appBar: AppBar(
          title: Text("Verify your email",style: TextStyle(color: AppColor.primaryTextColor),),
          centerTitle: true,
          backgroundColor: Colors.transparent, // Optional: make AppBar transparent
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            icon: CircleAvatar(child: Icon(Icons.arrow_back_ios_new,color: AppColor.primaryTextColor,size: 15,),backgroundColor: Color(0xff525f67),),
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
                 Text("Check Email ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color:AppColor.primaryTextColor ),),
                Text("Please check your email to verify your account.",style: TextStyle(color: AppColor.primaryTextColor),),
                SizedBox(height: 20,),
                RoundButton(title: "Confirm Now ",shadowColor: AppColor.buttonShadeColor,width: double.infinity, onPress: () {
                  print("selected role: $userRole");
                  Get.toNamed(
                    RouteName.oTPView,
                    arguments: {'role': userRole}, // 👈 pass role here
                  );
                },),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
