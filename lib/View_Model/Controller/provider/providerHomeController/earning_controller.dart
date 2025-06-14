import 'package:get/get.dart';
import '../../../../Repositry/Provider/providerHomeRepo/earning_repo.dart';
import '../../../../models/Provider/providerHomeModel/earning_model.dart';

class EarningController extends GetxController {
  final EarningRepository _repo = EarningRepository();

  final List<String> months = [
    "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
    "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
  ];

  var selectedMonth = "JAN".obs;
  var earning = EarningModel(currentMonth: 0, previousMonth: 0).obs;

  @override
  void onInit() {
    super.onInit();
    fetchEarnings();
  }

  void fetchEarnings() async {
    earning.value = await _repo.fetchEarnings(selectedMonth.value);
  }

  void changeMonth(String month) {
    selectedMonth.value = month;
    fetchEarnings();
  }

  double get earningChangePercent {
    final prev = earning.value.previousMonth;
    final current = earning.value.currentMonth;
    if (prev == 0) return 0;
    return ((current - prev) / prev) * 100;
  }
}
