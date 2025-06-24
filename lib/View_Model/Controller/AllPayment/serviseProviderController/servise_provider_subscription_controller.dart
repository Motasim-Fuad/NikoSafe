import 'package:get/get.dart';
import 'package:nikosafe/models/AllPaymentModel/serviseProvider/servise_provider_subscription_model.dart';



class ServiseProviderSubscriptionController extends GetxController {
  var selectedPlanId = ''.obs;
  var plans = <ServiseProviderSubscriptionModel>[
    ServiseProviderSubscriptionModel(
      id: '1',
      title: 'Monthly Subscription',
      description: 'First 7 days free - Then \$10.99/Month',
      price: 10.99,
      isMonthly: true,
    ),
    ServiseProviderSubscriptionModel(
      id: '2',
      title: 'Annual Subscription',
      description: 'First 7 days free - Then \$90.99/Year',
      price: 90.99,
      isAnnual: true,
    ),
    ServiseProviderSubscriptionModel(
      id: '3',
      title: 'Quarterly Subscription',
      description: 'First 7 days free - Then \$300.99/Quarter',
      price: 300.99,
      isQuarterly: true,
    ),
  ].obs;


  void selectPlan(String planId) {
    selectedPlanId.value = planId;
  }
}