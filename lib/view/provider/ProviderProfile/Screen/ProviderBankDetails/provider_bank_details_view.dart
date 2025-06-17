import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class ProviderBankDetailsView extends StatelessWidget {
  const ProviderBankDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Bank Details",style: TextStyle(color: AppColor.primaryTextColor),),
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: (){
                Get.toNamed(RouteName.providerBankDetailsEditView);
              },
              child: CircleAvatar(
                backgroundColor: AppColor.iconColor,
                child: SvgPicture.asset(ImageAssets.profile_edit,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
