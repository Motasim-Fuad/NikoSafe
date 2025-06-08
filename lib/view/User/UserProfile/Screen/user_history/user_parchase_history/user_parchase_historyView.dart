import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/view/User/UserProfile/Screen/user_history/user_parchase_history/widgets/userHistory_parchase_card_widgets.dart';

import '../../../../../../View_Model/Controller/user/MyProfile/user_purchase_history_controller/user_purchase_history_controller.dart';


class UserParchaseHistoryview extends StatelessWidget {
  final controller = Get.put(UserPurchaseHistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: controller.purchases.length,
      itemBuilder: (context, index) {
        return UserhistoryParchaseCardWidgets(purchase: controller.purchases[index]);
      },
    ));
  }
}
