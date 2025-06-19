import 'package:nikosafe/models/Provider/providerProfileModel/ScreenModel/withdraw_complete_model.dart';
class WithdrawCompleteRepository {
  Future<List<WithdrawCompleteModel>> fetchWithdraws() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(10, (index) {
      return WithdrawCompleteModel(
        date: "02-24-2024",
        amount: "\$200",
        status: "Completed",
      );
    });
  }

  Future<double> fetchBalance() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 1000.00;
  }
}
