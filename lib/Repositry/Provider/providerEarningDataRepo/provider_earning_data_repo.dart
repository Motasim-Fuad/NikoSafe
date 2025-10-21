
import 'package:nikosafe/models/Provider/providerEarningData/providerEarningData.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import '../../../data/Network/network_api_services.dart' show NetworkApiServices;

class ProviderEarningDataRepo {
  final _apiService = NetworkApiServices();

  // Get Earnings
  Future<EarningsData> getEarnings() async {
    try {
      dynamic response = await _apiService.getApi(
        AppUrl.providerEarningsUrl,
        requireAuth: true,
      );

      if (response['success'] == true) {
        final earningsResponse = EarningsResponseModel.fromJson(response);
        return earningsResponse.data;
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch earnings');
      }
    } catch (e) {
      throw Exception('Error fetching earnings: $e');
    }
  }

  // Get Withdrawals
  Future<List<WithdrawalModel>> getWithdrawals() async {
    try {
      dynamic response = await _apiService.getApi(
        AppUrl.providerWithdrawalsUrl,
        requireAuth: true,
      );

      if (response['success'] == true) {
        final withdrawalsResponse = WithdrawalsResponseModel.fromJson(response);
        return withdrawalsResponse.data;
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch withdrawals');
      }
    } catch (e) {
      throw Exception('Error fetching withdrawals: $e');
    }
  }

  // Create Withdrawal Request
  Future<void> createWithdrawalRequest({
    required double amount,
    required String region,
  }) async {
    try {
      final data = {
        'amount': amount,
        'region': region,
      };

      dynamic response = await _apiService.postApi(
        data,
        AppUrl.createWithdrawalRequestUrl,
        requireAuth: true,
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to create withdrawal request');
      }
    } catch (e) {
      throw Exception('Error creating withdrawal request: $e');
    }
  }
}
