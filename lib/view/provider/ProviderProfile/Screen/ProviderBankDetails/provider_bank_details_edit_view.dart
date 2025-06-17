import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../resource/Colors/app_colors.dart';
import '../../../../../resource/asseets/image_assets.dart';
import '../../../../../resource/compunents/customBackButton.dart';

class ProviderBankDetailsEditView extends StatelessWidget {
  const ProviderBankDetailsEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
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
            CircleAvatar(
              backgroundColor: AppColor.iconColor,
              child: SvgPicture.asset(ImageAssets.profile_edit,),
            )
          ],
        ),
      ),
    );
  }
}
