import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';


class ServiseProviderVerificationView extends StatelessWidget {
  const ServiseProviderVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(" provider Verification",style:TextStyle(color: AppColor.primaryTextColor),),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CircleAvatar(
                child: Icon(Icons.arrow_back_ios_new,size: 15,color: Colors.white,),backgroundColor: AppColor.iconColor,),
            ),onTap: (){
            Get.toNamed(RouteName.authView);
          },),
        ),

        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(ImageAssets.reviewVerificationImage),
                SizedBox(height: 30,),
                Text("Your application is under review",style: TextStyle(color: AppColor.limeColor,fontSize: 20,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                Text("We will notify you as soon as your account has been approved",style: TextStyle(color: AppColor.primaryTextColor),textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
