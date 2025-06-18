import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../Repositry/Provider/providerProfileRepo/providerScreen/bank_details_repo.dart';
import '../../../../../../models/Provider/providerProfileModel/ScreenModel/bank_details_model.dart';


class BankViewModel extends GetxController {
  final BankRepository _repo = BankRepository();

  var isLoading = false.obs;
  var bankDetails = Rxn<BankDetailModel>();

  final formKey = GlobalKey<FormState>();

  final accountNumber = ''.obs;
  final routingNumber = ''.obs;
  final bankName = ''.obs;
  final bankHolderName = ''.obs;
  final bankAddress = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    isLoading.value = true;
    final result = await _repo.fetchBankDetails();
    bankDetails.value = result;
    accountNumber.value = result.accountNumber;
    routingNumber.value = result.routingNumber;
    bankName.value = result.bankName;
    bankHolderName.value = result.bankHolderName;
    bankAddress.value = result.bankAddress;
    isLoading.value = false;
  }

  void updateData() async {
    if (formKey.currentState!.validate()) {
      final newData = BankDetailModel(
        accountNumber: accountNumber.value,
        routingNumber: routingNumber.value,
        bankName: bankName.value,
        bankHolderName: bankHolderName.value,
        bankAddress: bankAddress.value,
      );
      await _repo.updateBankDetails(newData);
      bankDetails.value = newData;
      Get.back(); // Navigate back to details screen
    }
  }
}
