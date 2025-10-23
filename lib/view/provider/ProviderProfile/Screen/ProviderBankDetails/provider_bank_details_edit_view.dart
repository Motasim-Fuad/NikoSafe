import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/providerProfileController/Screen/BankDetailsViewModel/provider_Bank_DetailsViewModel.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../../../resource/Colors/app_colors.dart';
import '../../../../../resource/compunents/customBackButton.dart';

class ProviderBankDetailsEditView extends StatelessWidget {
  ProviderBankDetailsEditView({super.key});
  final controller = Get.find<BankViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Edit Your Bank Details",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: controller.formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _inputField(
                  "Account Number",
                  controller.accountNumberController,
                  TextInputType.number,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return 'Account number is required';
                    }
                    if (value.length < 8) {
                      return 'Account number must be at least 8 digits';
                    }
                    return null;
                  },
                ),
                _inputField(
                  "Routing Number",
                  controller.routingNumberController,
                  TextInputType.number,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return 'Routing number is required';
                    }
                    if (value.length != 9) {
                      return 'Routing number must be 9 digits';
                    }
                    return null;
                  },
                ),
                _inputField(
                  "Bank Name",
                  controller.bankNameController,
                  TextInputType.text,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bank name is required';
                    }
                    return null;
                  },
                ),
                _inputField(
                  "Account Holder Name",
                  controller.bankHolderNameController,
                  TextInputType.text,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return 'Account holder name is required';
                    }
                    return null;
                  },
                ),
                _inputField(
                  "Bank Address",
                  controller.bankAddressController,
                  TextInputType.multiline,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bank address is required';
                    }
                    return null;
                  },
                  maxLines: 3,
                ),

                // Error message
                if (controller.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 32),
                Obx(() => RoundButton(
                  title: controller.isUpdating.value ? "Updating..." : "Save Changes",
                  onPress:  () {
                    controller.updateBankDetails();
                  },
                  width: double.infinity,
                )),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _inputField(
      String label,
      TextEditingController controller,
      TextInputType keyboardType,
      FormFieldValidator<String> validator, {
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          errorStyle: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}