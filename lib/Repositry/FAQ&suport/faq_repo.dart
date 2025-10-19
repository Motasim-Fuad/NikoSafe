import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/models/FAQ&Suport/faq_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class FaqRepository {
  final _apiService = NetworkApiServices();

  Future<FaqResponse> fetchFaqList() async {
    try {
      final response = await _apiService.getApi(
        AppUrl.faqEndpoint,
        requireAuth: false, // FAQs don't need auth
      );

      return FaqResponse.fromJson(response);
    } catch (e) {
      print('Error fetching FAQs: $e');
      rethrow;
    }
  }
}