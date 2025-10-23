import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../../../../Repositry/Provider/providerProfileRepo/providerScreen/bank_details_repo.dart';
import '../../../../../../models/Provider/providerProfileModel/ScreenModel/bank_details_model.dart';

class BankViewModel extends GetxController {
  final BankRepository _repo = BankRepository();

  var isLoading = false.obs;
  var isUpdating = false.obs;
  var bankDetails = Rxn<BankDetailModel>();
  var errorMessage = ''.obs;

  final formKey = GlobalKey<FormState>();

  final accountNumberController = TextEditingController();
  final routingNumberController = TextEditingController();
  final bankNameController = TextEditingController();
  final bankHolderNameController = TextEditingController();
  final bankAddressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchBankDetails();
  }

  @override
  void onClose() {
    accountNumberController.dispose();
    routingNumberController.dispose();
    bankNameController.dispose();
    bankHolderNameController.dispose();
    bankAddressController.dispose();
    super.onClose();
  }

  void fetchBankDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await _repo.fetchBankDetails();
      bankDetails.value = result;

      // Update controllers with fetched data
      accountNumberController.text = result.accountNumber;
      routingNumberController.text = result.routingNumber;
      bankNameController.text = result.bankName;
      bankHolderNameController.text = result.bankHolderName;
      bankAddressController.text = result.bankAddress;
    } catch (e) {
      errorMessage.value = e.toString();
      Utils.errorSnackBar("Error", "Failed to fetch bank details: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBankDetails() async {
    if (formKey.currentState!.validate()) {
      try {
        isUpdating.value = true;
        errorMessage.value = '';

        final updatedData = BankDetailModel(
          id: bankDetails.value?.id,
          accountNumber: accountNumberController.text.trim(),
          routingNumber: routingNumberController.text.trim(),
          bankName: bankNameController.text.trim(),
          bankHolderName: bankHolderNameController.text.trim(),
          bankAddress: bankAddressController.text.trim(),
        );

        final result = await _repo.updateBankDetails(updatedData);
        bankDetails.value = result;

        // Navigate back after successful update
        Get.back();
      } catch (e) {
        errorMessage.value = e.toString();
        Utils.errorSnackBar("Error", "Failed to update bank details: ${e.toString()}");
      } finally {
        isUpdating.value = false;
      }
    }
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  // Check if form has changes
  bool get hasChanges {
    final current = bankDetails.value;
    if (current == null) return false;

    return accountNumberController.text != current.accountNumber ||
        routingNumberController.text != current.routingNumber ||
        bankNameController.text != current.bankName ||
        bankHolderNameController.text != current.bankHolderName ||
        bankAddressController.text != current.bankAddress;
  }
}