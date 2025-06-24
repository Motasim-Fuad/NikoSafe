
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/models/AllPaymentModel/user/userCardModel.dart';

import '../../../../view/AllPayment/User/payment_confirmation_view.dart';

class UserCardController extends GetxController {
  var cards = <UserCardModel>[].obs;
  var selectedCardIndex = (-1).obs;
  var isLoading = false.obs;

  final nameController = TextEditingController();
  final idController = TextEditingController();

  void addCard(String cardType, String bankName, String last4Digits) {
    cards.add(UserCardModel(
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
    isLoading.value = true;
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      Get.to(() => UserPaymentConfirmationView());
    });
  }
}