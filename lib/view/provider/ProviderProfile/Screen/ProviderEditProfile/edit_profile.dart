import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/provider/ProviderProfile/Screen/ProviderEditProfile/widgets/edit_profile_form.dart';
import '../../../../../View_Model/Controller/provider/providerProfileController/provider_edit_profile_controller.dart';

class ProviderEditProfileView extends StatelessWidget {
  const ProviderEditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProviderEditProfileController());

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(

        appBar: AppBar(
          title:  Text("Edit Profile",style: TextStyle(color: AppColor.primaryTextColor),),
          centerTitle: true,
          leading: CustomBackButton(),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body:  ProviderEditProfileForm(),
      ),
    );
  }
}
