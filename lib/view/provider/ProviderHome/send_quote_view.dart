import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../View_Model/Controller/provider/providerHomeController/task_controller.dart';

class ProviderSendQuoteView extends StatelessWidget {
  ProviderSendQuoteView({super.key});

  final TextEditingController messageController = TextEditingController();
  final TextEditingController hourlyRateController = TextEditingController();
  final TextEditingController estimatedHoursController = TextEditingController();

  final messageFocus = FocusNode();
  final hourlyRateFocus = FocusNode();
  final estimatedHoursFocus = FocusNode();

  final taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    final bookingId = Get.arguments as int?;
    if (bookingId == null) {
      return const Scaffold(
        body: Center(child: Text("No booking ID provided")),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(gradient: AppColor.backGroundColor),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: const CustomBackButton(),
            centerTitle: true,
            title: const Text(
              "Send Quote",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: messageController,
                    hintText: "Write a message to your client...",
                    minLines: 4,
                    maxLines: 5,
                    focusNode: messageFocus,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(hourlyRateFocus),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: hourlyRateController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    hintText: "Enter hourly rate (\$)",
                    focusNode: hourlyRateFocus,
                    onChanged: (value) => taskController.calculateTotalPrice(
                      value,
                      estimatedHoursController.text,
                    ),
                    onSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(estimatedHoursFocus),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: estimatedHoursController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    hintText: "Enter estimated hours",
                    focusNode: estimatedHoursFocus,
                    onChanged: (value) => taskController.calculateTotalPrice(
                      hourlyRateController.text,
                      value,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Reactive Total Price Display
                  Obx(
                        () => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_money_rounded,
                              color: Colors.green, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            taskController.totalPrice.value <= 0
                                ? "Will be calculated automatically"
                                : "\$${taskController.totalPrice.value.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: taskController.totalPrice.value <= 0
                                  ? Colors.grey.shade600
                                  : Colors.black87,
                              fontWeight: taskController.totalPrice.value <= 0
                                  ? FontWeight.w400
                                  : FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ✅ Send button with loading state
                  Obx(
                        () => RoundButton(
                      width: double.infinity,
                      title: taskController.isSendingQuote.value
                          ? "Sending..."
                          : "Send Quote",
                      loading: taskController.isSendingQuote.value,
                      showLoader: taskController.isSendingQuote.value,
                      onPress: () => _sendQuote(bookingId),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendQuote(int bookingId) async {
    if (_validateForm()) {
      try {
        await taskController.sendQuote(
          bookingId: bookingId,
          message: messageController.text.trim(),
          hourlyRate: double.parse(hourlyRateController.text),
          estimatedHours: double.parse(estimatedHoursController.text),
          totalPrice: taskController.totalPrice.value,
        );

        Utils.successSnackBar("Quote", "Quote Sent Successfully");
        Get.back();
      } catch (e) {
        Utils.errorSnackBar("Error", "Failed to send quote: $e");
      }
    }
  }

  bool _validateForm() {
    if (messageController.text.isEmpty) {
      Utils.errorSnackBar("Error", "Please enter a message");
      return false;
    }
    if (hourlyRateController.text.isEmpty) {
      Utils.errorSnackBar("Error", "Please enter hourly rate");
      return false;
    }
    if (estimatedHoursController.text.isEmpty) {
      Utils.errorSnackBar("Error", "Please enter estimated hours");
      return false;
    }

    final hourlyRate = double.tryParse(hourlyRateController.text);
    final estimatedHours = double.tryParse(estimatedHoursController.text);

    if (hourlyRate == null || hourlyRate <= 0) {
      Utils.errorSnackBar("Error", "Please enter a valid hourly rate");
      return false;
    }
    if (estimatedHours == null || estimatedHours <= 0) {
      Utils.errorSnackBar("Error", "Please enter valid estimated hours");
      return false;
    }
    return true;
  }
}
