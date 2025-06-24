import 'package:get/get.dart';
import 'package:nikosafe/models/AllPaymentModel/user/user_subscription_model.dart';
import 'package:nikosafe/models/AllPaymentModel/vendor/vendor_subscription_model.dart';


class VendorSubscriptionController extends GetxController {
  var selectedPlanId = ''.obs;
  var plans = <VendorSubscriptionModel>[
    VendorSubscriptionModel(
      id: '1',
      title: 'Monthly Subscription',
      description: 'First 7 days free - Then \$67.99/Month',
      price: 67.99,
      isMonthly: true,
    ),
    VendorSubscriptionModel(
      id: '2',
      title: 'Annual Subscription',
      description: 'First 7 days free - Then \$104.99/Year',
      price: 104.99,
      isAnnual: true,
    ),
    VendorSubscriptionModel(
      id: '3',
      title: 'Quarterly Subscription',
      description: 'First 7 days free - Then \$508.99/Quarter',
      price: 508.99,
      isQuarterly: true,
    ),
  ].obs;


  void selectPlan(String planId) {
    selectedPlanId.value = planId;
  }
}