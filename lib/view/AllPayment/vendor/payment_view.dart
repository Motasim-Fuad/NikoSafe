import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/AllPayment/vendorController/vendorCardController.dart';
import 'package:nikosafe/View_Model/Controller/AllPayment/vendorController/vendor_subscription_controller.dart';
import 'package:nikosafe/models/AllPaymentModel/vendor/vendor_subscription_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

import '../../../utils/utils.dart';

class VendorPaymentView extends StatelessWidget {
  const VendorPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final subscriptionController = Get.put(VendorSubscriptionController());
    final cardController = Get.put(Vendorcardcontroller());


    final selectedPlan = subscriptionController.plans.firstWhere(
          (p) => p.id == subscriptionController.selectedPlanId.value,
      orElse: () => VendorSubscriptionModel(
        id: '',
        title: 'No Plan',
        description: '',
        price: 0.0,
        isMonthly: false,
        isAnnual: false,
        isQuarterly: false,
      ),
    );

    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Vendor Payment', style: TextStyle(color: AppColor.primaryTextColor)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Plan Info
              Container(
                width: double.infinity,
                child: Card(
                  color: AppColor.iconColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          selectedPlan.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${selectedPlan.price.toStringAsFixed(2)}"
                              " ${selectedPlan.isMonthly ? '/month' : selectedPlan.isQuarterly ? '/quarter' : '/year'}",
                          style: TextStyle(color: AppColor.primaryTextColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add Card',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Card list with Obx
              Expanded(
                child: Obx(() {
                  return ListView(
                    children: [
                      ...cardController.cards.asMap().entries.expand((entry) {
                        final index = entry.key;
                        final card = entry.value;

                        return [
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey),
                            ),
                            leading: Icon(
                              card.cardType == 'Mastercard'
                                  ? Icons.credit_card
                                  : Icons.credit_card_outlined,
                              color: Colors.yellow,
                            ),
                            title: Text(
                              '${card.bankName} **** **** **** ${card.last4Digits}',
                              style: TextStyle(color: AppColor.primaryTextColor),
                            ),
                            trailing: Radio<int>(
                              value: index,
                              groupValue: cardController.selectedCardIndex.value,
                              onChanged: (value) {
                                cardController.selectCard(index);
                              },
                            ),
                          ),
                          // 👇 Only add spacing after the first card
                          const SizedBox(height: 10),

                        ];
                      }),

                      // Add Card Button
                      ListTile(
                        leading: Icon(Icons.add_circle_outline, color: AppColor.primaryTextColor),
                        title: Text("Add New Card", style: TextStyle(color: AppColor.primaryTextColor)),
                        onTap: () {
                          showModalBottomSheet(
                            context: Get.context!,
                            isScrollControlled: true,
                            backgroundColor: AppColor.topLinear,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (_) => Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 16,
                                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    style: TextStyle(
                                        color:AppColor.primaryTextColor
                                    ),
                                    controller: cardController.nameController,
                                    decoration: InputDecoration(labelText: 'Bank Name',labelStyle: TextStyle(color: AppColor.secondaryTextColor)),
                                  ),
                                  TextField(
                                    style: TextStyle(
                                        color:AppColor.primaryTextColor
                                    ),
                                    controller: cardController.idController,
                                    decoration: InputDecoration(labelText: 'Last 4 digits',labelStyle: TextStyle(color: AppColor.secondaryTextColor)),
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                  ),
                                  const SizedBox(height: 12),
                                  RoundButton(
                                    onPress: () {
                                      final name = cardController.nameController.text.trim();
                                      final id = cardController.idController.text.trim();

                                      if (name.isNotEmpty && id.length == 4) {
                                        cardController.addCard("Visa", name, id);
                                        cardController.clearForm();
                                        Get.back();
                                      } else {
                                        Get.snackbar(
                                          "Error",
                                          "Please enter valid card info",
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    },
                                    title: "Add Card",
                                    width: double.infinity,
                                    shadowColor: Colors.transparent,
                                    buttonColor: AppColor.iconColor,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
              ),


              // Proceed Button
              Obx(() =>     RoundButton(
                width: double.infinity,
                title: 'Proceed to Pay',
                loading: cardController.isLoading.value,
                showLoader: false,
                showLoadingText: true,
                loadingText: 'Proceed to Pay....',
                onPress: () {
                  if (cardController.selectedCardIndex.value == -1) {
                    Utils.infoSnackBar("Required", "Please select a card");
                  } else {
                    cardController.processPayment();
                  }
                },
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
