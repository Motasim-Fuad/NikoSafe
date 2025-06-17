import 'package:get/get.dart';
import 'package:nikosafe/utils/utils.dart';
import 'package:nikosafe/view/provider/ProviderData/ProviderEarningDetails/provider_erning_details_view.dart';
import '../../../../Repositry/Provider/providerEarningDataRepo/provider_earning_data_repo.dart';
import '../../../../models/Provider/providerEarningData/providerEarningData.dart';

class ProviderEarningDataController extends GetxController {
  final ProviderEarningDataRepo _repo = ProviderEarningDataRepo();

  var earnings = <ProviderEarningDataModel>[].obs;
  var isLoading = true.obs;
  var currentBalance = '\$1000'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEarnings();
  }

  void fetchEarnings() async {
    try {
      isLoading(true);
      var data = await _repo.getEarnings();
      earnings.assignAll(data);
    } finally {
      isLoading(false);
    }
  }

  void withdraw() {
   Utils.snackBar('Withdraw',
     'Withdrawal functionality coming soon!',);
  }

  void showEarningDetails(ProviderEarningDataModel earning) {
    Get.to(ProviderEarningDataDetailsView(),arguments: earning);
  }
}
