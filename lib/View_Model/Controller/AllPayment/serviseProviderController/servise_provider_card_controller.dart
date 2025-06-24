
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/AllPaymentModel/serviseProvider/serviseProviderCardModel.dart';
import '../../../../view/AllPayment/ServiseProvider/payment_confirm_view.dart';


class ServiseProviderCardController extends GetxController {
  var cards = <ServiseProviderCardModel>[].obs;
  var selectedCardIndex = (-1).obs;
  var isLoading =false.obs;
  final nameController = TextEditingController();
  final idController = TextEditingController();

  void addCard(String cardType, String bankName, String last4Digits) {
    cards.add(ServiseProviderCardModel(
      cardType: cardType,
      bankName: bankName,
      last4Digits: last4Digits,
    ));
  }

  void selectCard(int index) {
    selectedCardIndex.value = index;
  }

  void clearForm() {
    nameController.clear();
    idController.clear();
  }

  void processPayment() {
    isLoading.value=true;
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value=false;
       Get.to(() => ServiseProviderPaymentConfirmationView());
    });
  }
}