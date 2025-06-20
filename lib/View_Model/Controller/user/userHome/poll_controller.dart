import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../../Repositry/userHome_repo/poll_repositry.dart';
import '../../../../models/userHome/poll/create_poll_model.dart';

class PollController extends GetxController {
  final titleController = TextEditingController();
  final options = <TextEditingController>[TextEditingController()].obs;
  final isLoading = false.obs;

  final PollRepository _pollRepo = PollRepository();

  void addOption() {
    options.add(TextEditingController());
  }

  void removeOption(int index) {
    if (options.length > 1) {
      options.removeAt(index);
    }
  }

  Future<void> submitPoll() async {
    if (titleController.text.isEmpty || options.any((c) => c.text.isEmpty)) {
      Get.snackbar("Validation", "Please fill all fields");
      return;
    }

    isLoading.value = true;

    final poll = PollModel(
      title: titleController.text,
      options: options.map((c) => c.text).toList(),
    );

    await _pollRepo.createPoll(poll);
    isLoading.value = false;

    // ✅ Dismiss keyboard
    FocusScope.of(Get.context!).unfocus();

    // 🧹 Clear fields
    titleController.clear();
    for (var c in options) {
      c.dispose();
    }
    options.clear();
    options.add(TextEditingController());

    if (kDebugMode) {
      print("Poll created successfully");
    }

    Utils.successSnackBar("Success", "Poll created successfully");
    Utils.tostMassage("success");

    Future.delayed(Duration(milliseconds: 1500), () {
      Get.back();
    });
  }



  @override
  void onClose() {
    titleController.dispose();
    options.forEach((c) => c.dispose());
    super.onClose();
  }
}
