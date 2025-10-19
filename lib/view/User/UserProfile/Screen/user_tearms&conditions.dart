import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/FAQ&Suport/terms_conditions_view_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class UserTearmsConditions extends StatelessWidget {
  const UserTearmsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(TermsConditionsController());

    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Terms & Conditions",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Obx(() {
            // Loading State
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryTextColor,
                ),
              );
            }

            // Error State
            if (controller.errorMessage.value.isNotEmpty) {
              return _buildErrorWidget(controller);
            }

            // Success State
            if (controller.termsConditions.value?.data != null) {
              return _buildContentWidget(
                controller.termsConditions.value!.data!.content,
              );
            }

            // Default empty state
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(color: AppColor.primaryTextColor),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildContentWidget(String content) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Terms & Conditions",
            style: TextStyle(
              color: AppColor.primaryTextColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            content,
            style: TextStyle(
              color: AppColor.primaryTextColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(TermsConditionsController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: AppColor.primaryTextColor.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            style: TextStyle(color: AppColor.primaryTextColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.retry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryTextColor,
              foregroundColor: Colors.white,
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}