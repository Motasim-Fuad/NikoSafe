import '../../../../models/Provider/providerProfileModel/ScreenModel/bank_details_model.dart';


class BankRepository {
  Future<BankDetailModel> fetchBankDetails() async {
    // Mocked data or fetch from API
    await Future.delayed(const Duration(seconds: 1));
    return BankDetailModel(
      accountNumber: "1234567890",
      routingNumber: "021000021",
      bankName: "Atlantic Federal Bank",
      bankHolderName: "John D. Harper",
      bankAddress: "101 Main Street, New York, NY 10001, USA",
    );
  }

  Future<void> updateBankDetails(BankDetailModel data) async {
    // API Call to save bank details
    await Future.delayed(const Duration(seconds: 1));
  }
}
