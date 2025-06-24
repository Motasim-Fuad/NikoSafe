import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/AllPayment/userController/user_subscription_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/utils/utils.dart';
import 'package:nikosafe/view/AllPayment/User/payment_view.dart';
import '../widgets/subscriptionCard.dart';

class UserSubscriptionSelectionView extends StatelessWidget {
  const UserSubscriptionSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserSubscriptionController());

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),

        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Select a Subscription That Fits You',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow
                ),
              ),
              const SizedBox(height: 16),
              SvgPicture.asset(ImageAssets.subscriptionPlanImage,height: 250,),
              const SizedBox(height: 24),
              // Subscription list - only needs Obx if plans can change reactively
              _buildSubscriptionList(controller),
              const SizedBox(height: 24),
              // Get Now button - only needs Obx if it depends on reactive state
              _buildGetNowButton(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionList(UserSubscriptionController controller) {
    // Only use Obx if plans is an observable list that might change
    // If it's static data, you don't need Obx here
    return Column(
      children: controller.plans.map((plan) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Obx(() => SubscriptionCard(
          title: plan.title,
          description: plan.description,
          isSelected: controller.selectedPlanId.value == plan.id,
          onTap: () => controller.selectPlan(plan.id),
        )),
      )).toList(),
    );
  }

  Widget _buildGetNowButton(UserSubscriptionController controller) {
    // No need for Obx here since we're not observing any changes
    // The button state is determined when pressed
    return RoundButton(
      width: double.infinity,
      title: 'Get Now',
      onPress: () {
        if (controller.selectedPlanId.isEmpty) {
          Utils.errorSnackBar("Validation", "Please Select any Package");
        } else {
          Get.to(const UserPaymentView());
        }
      },
    );
  }
}