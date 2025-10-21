import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../../Repositry/Provider/providerEarningDataRepo/provider_earning_data_repo.dart';
import '../../../../models/Provider/providerEarningData/providerEarningData.dart';

class ProviderWithdrawalController extends GetxController {
  final ProviderEarningDataRepo _repo = ProviderEarningDataRepo();

  var withdrawals = <WithdrawalModel>[].obs;
  var isLoading = true.obs;

  final amountController = TextEditingController();
  final regionController = TextEditingController();
  final amountFocus = FocusNode();
  final regionFocus = FocusNode();

  var isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWithdrawals();
  }

  @override
  void onClose() {
    amountController.dispose();
    regionController.dispose();
    amountFocus.dispose();
    regionFocus.dispose();
    super.onClose();
  }

  void fetchWithdrawals() async {
    try {
      isLoading(true);
      var data = await _repo.getWithdrawals();
      withdrawals.assignAll(data);
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void submitWithdrawalRequest() async {
    if (amountController.text.isEmpty) {
      Utils.errorSnackBar('Error', 'Please enter amount');
      return;
    }

    if (regionController.text.isEmpty) {
      Utils.errorSnackBar('Error', 'Please enter region');
      return;
    }

    try {
      isSubmitting(true);

      final amount = double.tryParse(amountController.text);
      if (amount == null || amount <= 0) {
        Utils.errorSnackBar('Error', 'Please enter valid amount');
        return;
      }

      await _repo.createWithdrawalRequest(
        amount: amount,
        region: regionController.text,
      );

      Utils.successSnackBar(
        'Success',
        'Withdrawal request submitted successfully',
      );

      amountController.clear();
      regionController.clear();
      FocusScope.of(Get.context!).unfocus();

      Get.back();
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isSubmitting(false);
    }
  }
}

