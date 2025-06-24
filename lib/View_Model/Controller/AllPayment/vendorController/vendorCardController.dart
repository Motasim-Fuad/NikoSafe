
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/models/AllPaymentModel/vendor/vendorCardModel.dart';
import '../../../../view/AllPayment/vendor/payment_confirm_view.dart';

class Vendorcardcontroller extends GetxController {
  var cards = <VendorCardModel>[].obs;
  var selectedCardIndex = (-1).obs;

  final nameController = TextEditingController();
  final idController = TextEditingController();

  void addCard(String cardType, String bankName, String last4Digits) {
    cards.add(VendorCardModel(
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
    Future.delayed(Duration(seconds: 2), () {
       Get.to(() => VendorPaymentConfirmationView());
    });
  }
}