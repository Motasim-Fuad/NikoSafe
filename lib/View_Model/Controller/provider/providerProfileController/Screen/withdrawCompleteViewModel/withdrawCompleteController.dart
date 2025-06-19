import 'package:get/get.dart';
import 'package:nikosafe/Repositry/Provider/providerProfileRepo/providerScreen/withdrawCompleteRepo.dart';

import '../../../../../../models/Provider/providerProfileModel/ScreenModel/withdraw_complete_model.dart';


class WithdrawCompleteViewModel extends GetxController {
  final WithdrawCompleteRepository _repo = WithdrawCompleteRepository();

  var isLoading = false.obs;
  var withdrawList = <WithdrawCompleteModel>[].obs;
  var balance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadWithdrawData();
  }

  void loadWithdrawData() async {
    isLoading.value = true;
    withdrawList.value = await _repo.fetchWithdraws();
    balance.value = await _repo.fetchBalance();
    isLoading.value = false;
  }
}
