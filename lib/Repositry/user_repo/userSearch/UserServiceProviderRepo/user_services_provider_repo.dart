// Repository/user_repo/userSearch/UserServiceProviderRepo/service_provider_repository.dart

import 'package:nikosafe/data/network/network_api_services.dart';
import 'package:nikosafe/models/User/userSearch/userServiceProviderModel/user_services_provider.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class ServiceProviderRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // Get all designations (categories)
  Future<List<DesignationModel>> getDesignations() async {
    try {
      final response = await _apiServices.getApi(
        AppUrl.getDesignationsUrl,
        requireAuth: false,
      );

      if (response['success'] == true) {
        List<DesignationModel> designations = [];
        for (var item in response['data']) {
          designations.add(DesignationModel.fromJson(item));
        }
        return designations;
      } else {
        throw Exception(response['message'] ?? 'Failed to load designations');
      }
    } catch (e) {
      throw Exception('Error fetching designations: $e');
    }
  }

  // Get all service providers
  Future<List<ServiceProviderModel>> getAllProviders() async {
    try {
      final response = await _apiServices.getApi(
        "${AppUrl.base_url}/api/basicuser/providers/",
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        List<ServiceProviderModel> providers = [];

        // Check if data has 'providers' key (paginated) or is direct array
        var providersList = response['data']['providers'] ?? response['data'];

        if (providersList is List) {
          for (var item in providersList) {
            providers.add(ServiceProviderModel.fromJson(item));
          }
        }

        return providers;
      } else {
        throw Exception(response['message'] ?? 'Failed to load providers');
      }
    } catch (e) {
      throw Exception('Error fetching providers: $e');
    }
  }

  // Get provider details by ID
  Future<ServiceProviderDetailModel> getProviderDetails(int providerId) async {
    try {
      final response = await _apiServices.getApi(
        "${AppUrl.base_url}/api/basicuser/providers/$providerId/",
        requireAuth: true,
      );

      if (response['success'] == true) {
        return ServiceProviderDetailModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to load provider details');
      }
    } catch (e) {
      throw Exception('Error fetching provider details: $e');
    }
  }

  // Save/Unsave provider
  Future<bool> toggleSaveProvider(int providerId) async {
    try {
      final response = await _apiServices.postApi(
        {},
        "${AppUrl.base_url}/api/basicuser/providers/$providerId/save/",
        requireAuth: true,
      );

      if (response['success'] == true) {
        return response['data']['is_saved'] ?? false;
      } else {
        throw Exception(response['message'] ?? 'Failed to save provider');
      }
    } catch (e) {
      throw Exception('Error saving provider: $e');
    }
  }

  // Get all saved providers
  Future<List<ServiceProviderModel>> getSavedProviders() async {
    try {
      final response = await _apiServices.getApi(
        "${AppUrl.base_url}/api/basicuser/saved-providers/",
        requireAuth: true,
      );

      if (response['success'] == true) {
        List<ServiceProviderModel> savedProviders = [];
        for (var item in response['data']) {
          savedProviders.add(ServiceProviderModel.fromJson(item));
        }
        return savedProviders;
      } else {
        throw Exception(response['message'] ?? 'Failed to load saved providers');
      }
    } catch (e) {
      throw Exception('Error fetching saved providers: $e');
    }
  }
}