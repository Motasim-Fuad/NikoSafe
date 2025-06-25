import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class UserSettingsView extends StatelessWidget {
  const UserSettingsView({super.key});

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
          title: Text("Settings",style: TextStyle(color: AppColor.primaryTextColor,fontWeight: FontWeight.bold,),),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Get.toNamed(RouteName.userChangePasswordView);
                },
                child: Card(
                  color: Color(0x4dffffff),
                  child: ListTile(
                    leading: Icon(Icons.lock_outline,color: AppColor.primaryTextColor,),
                    title: Text("Change Password",style: TextStyle(color: AppColor.primaryTextColor),),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.toNamed(RouteName.userDeleteAccauuntview);
                },
                child: Card(
                  color: Color(0x4dffffff),
                  child: ListTile(
                    leading: Icon(Icons.delete_outline,color: Colors.red,),
                    title: Text("Delete account",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
