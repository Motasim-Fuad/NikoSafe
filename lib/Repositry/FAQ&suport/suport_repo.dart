
import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/models/FAQ&Suport/suport_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class SuportRepository {
  final _apiService = NetworkApiServices();

  Future<SuportModel> createTicket(SuportModel ticket) async {
    try {
      final response = await _apiService.postApi(
        ticket.toJson(),
        AppUrl.createTicketEndpoint,
        requireAuth: true, // Tickets need authentication
      );

      return SuportModel.fromJson(response);
    } catch (e) {
      print('Error creating Suport: $e');
      rethrow;
    }
  }
}