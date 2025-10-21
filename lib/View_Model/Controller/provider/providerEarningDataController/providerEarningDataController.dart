import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../../Repositry/Provider/providerEarningDataRepo/provider_earning_data_repo.dart';
import '../../../../models/Provider/providerEarningData/providerEarningData.dart';

class ProviderEarningDataController extends GetxController {
  final ProviderEarningDataRepo _repo = ProviderEarningDataRepo();

  var earnings = <ProviderEarningDataModel>[].obs;
  var isLoading = true.obs;
  var balance = 0.0.obs;
  var totalEarnings = 0.0.obs;
  var totalWithdrawals = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEarnings();
  }

  void fetchEarnings() async {
    try {
      isLoading(true);
      var data = await _repo.getEarnings();

      balance.value = data.balance;
      totalEarnings.value = data.totalEarnings;
      totalWithdrawals.value = data.totalWithdrawals;
      earnings.assignAll(data.earnings);
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void withdraw() {
    Get.toNamed(RouteName.providerWithdrawRequestView);
  }

  void showEarningDetails(ProviderEarningDataModel earning) {
    Get.toNamed(
      RouteName.providerEarningDataDetailsView,
      arguments: earning,
    );
  }

  void navigateToWithdrawals() {
    Get.toNamed(RouteName.providerWithdrawalsView);
  }
}

