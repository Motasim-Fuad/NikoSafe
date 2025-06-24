import 'package:get/get.dart';
import 'package:nikosafe/models/AllPaymentModel/user/user_subscription_model.dart';


class UserSubscriptionController extends GetxController {
  var selectedPlanId = ''.obs;
  var plans = <UserSubscriptionModel>[
    UserSubscriptionModel(
      id: '1',
      title: 'Monthly Subscription',
      description: 'First 7 days free - Then \$1.99/Month',
      price: 1.99,
      isMonthly: true,
    ),
    UserSubscriptionModel(
      id: '2',
      title: 'Annual Subscription',
      description: 'First 7 days free - Then \$9.99/Year',
      price: 9.99,
      isAnnual: true,
    ),
    UserSubscriptionModel(
      id: '3',
      title: 'Quarterly Subscription',
      description: 'First 7 days free - Then \$3.99/Quarter',
      price: 3.99,
      isQuarterly: true,
    ),
  ].obs;


  void selectPlan(String planId) {
    selectedPlanId.value = planId;
  }
}