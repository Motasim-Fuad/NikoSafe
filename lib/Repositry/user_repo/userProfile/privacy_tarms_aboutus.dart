
import 'package:nikosafe/data/network/network_api_services.dart';
import 'package:nikosafe/models/FAQ&Suport/privacy_trms_about.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class PrivacyTarmsAboutusRepo {
  final _apiServices = NetworkApiServices();

  // Get Privacy Policy
  Future<PrivacyTrmsAbout> getPrivacyPolicyApi() async {
    try {
      dynamic response = await _apiServices.getApi(
        AppUrl.privacyPolicyUrl,
        requireAuth: false,
      );
      return PrivacyTrmsAbout.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get Terms and Conditions
  Future<PrivacyTrmsAbout> getTermsConditionsApi() async {
    try {
      dynamic response = await _apiServices.getApi(
        AppUrl.termsConditionsUrl,
        requireAuth: false,
      );
      return PrivacyTrmsAbout.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get About Us
  Future<PrivacyTrmsAbout> getAboutUsApi() async {
    try {
      dynamic response = await _apiServices.getApi(
        AppUrl.aboutUsUrl,
        requireAuth: false,
      );
      return PrivacyTrmsAbout.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}