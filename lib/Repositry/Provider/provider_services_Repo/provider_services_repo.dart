
import 'package:nikosafe/resource/App_Url/app_url.dart';
import '../../../data/Network/network_api_services.dart' show NetworkApiServices;
import '../../../models/Provider/providerTaskModel/provider_task_model.dart';

class ProviderServicesRepo {
  final _apiService = NetworkApiServices();

  Future<List<ProviderServicesModel>> fetchBookings() async {
    try {
      final response = await _apiService.getApi(
        AppUrl.providerBookingsUrl,
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> bookingsJson = response['data'];
        return bookingsJson
            .map((json) => ProviderServicesModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching bookings: $e');
      rethrow;
    }
  }

  Future<bool> completeBooking(int bookingId) async {
    try {
      final response = await _apiService.postApi(
        {'status': 'completed'},
        "${AppUrl.base_url}/api/provider/bookings/$bookingId/complete/",
        requireAuth: true,
      );
      return response['success'] == true;
    } catch (e) {
      print('Error completing booking: $e');
      rethrow;
    }
  }

  Future<bool> cancelBooking(int bookingId) async {
    try {
      final response = await _apiService.postApi(
        {},
        '${AppUrl.base_url}/api/basicuser/bookings/$bookingId/cancel/',
        requireAuth: true,
      );
      return response['success'] == true;
    } catch (e) {
      print('Error cancelling booking: $e');
      rethrow;
    }
  }
}