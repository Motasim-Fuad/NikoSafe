import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/FAQ&Suport/faq_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'faq_tile.dart';

class FaqView extends StatelessWidget {
  final FaqController controller = Get.put(FaqController());

  FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "FAQs",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: CustomBackButton(),
          backgroundColor: Colors.transparent,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.limeColor,
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: AppColor.primaryTextColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.refreshFaqs(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.faqList.isEmpty) {
            return Center(
              child: Text(
                'No FAQs available',
                style: TextStyle(color: AppColor.primaryTextColor),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.refreshFaqs(),
            color: AppColor.limeColor,
            child: ListView.builder(
              itemCount: controller.faqList.length,
              itemBuilder: (context, index) {
                final faq = controller.faqList[index];
                return FaqTile(
                  faq: faq,
                  onTap: () => controller.toggleExpand(index),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}