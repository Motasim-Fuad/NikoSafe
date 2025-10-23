import 'package:nikosafe/data/network/network_api_services.dart';
import 'package:nikosafe/models/Provider/providerProfileModel/ScreenModel/bank_details_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import 'package:nikosafe/utils/utils.dart';

class BankRepository {
  final _apiService = NetworkApiServices();

  Future<BankDetailModel> fetchBankDetails() async {
    try {
      dynamic response = await _apiService.getApi(
        AppUrl.base_url + '/api/provider/bank-details/',
        requireAuth: true,
      );

      if (response['success'] == true) {
        return BankDetailModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch bank details');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<BankDetailModel> updateBankDetails(BankDetailModel data) async {
    try {
      dynamic response = await _apiService.putApi(
        data.toJson(),
        AppUrl.base_url + '/api/provider/bank-details/',
        requireAuth: true,
      );

      if (response['success'] == true) {
        Utils.successSnackBar("Bank Details", response['message'] ?? "Bank details updated successfully");
        return BankDetailModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to update bank details');
      }
    } catch (e) {
      rethrow;
    }
  }
}