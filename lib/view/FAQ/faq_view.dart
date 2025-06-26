import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/User/userNotification/user_my_payment_details.dart';
import '../../View_Model/Controller/FAQ/faq_controller.dart';
import 'faq_tile.dart';

class FaqView extends StatelessWidget {
  final FaqController controller = Get.put(FaqController());

  FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title:  Text("FAQs",style: TextStyle(color: AppColor.primaryTextColor),),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: CustomBackButton(),
          backgroundColor: Colors.transparent,
        ),
        body: Obx(() {
          if (controller.faqList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: controller.faqList.length,
            itemBuilder: (context, index) {
              final faq = controller.faqList[index];
              return FaqTile(
                faq: faq,
                onTap: () => controller.toggleExpand(index),
              );
            },
          );
        }),
      ),
    );
  }
}
