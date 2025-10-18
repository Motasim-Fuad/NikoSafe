// View_Model/Controller/user/userSearch/userServiceProviderController/service_provider_controller.dart

import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userSearch/UserServiceProviderRepo/user_services_provider_repo.dart';
import 'package:nikosafe/models/User/userSearch/userServiceProviderModel/user_services_provider.dart';
import 'package:nikosafe/utils/utils.dart';

class ServiceProviderController extends GetxController {
  final ServiceProviderRepository _repository = ServiceProviderRepository();

  // Observable lists
  var designations = <DesignationModel>[].obs;
  var allProviders = <ServiceProviderModel>[].obs;
  var filteredProviders = <ServiceProviderModel>[].obs;
  var savedProviders = <ServiceProviderModel>[].obs;

  // Loading states
  var isLoading = false.obs;
  var isDesignationsLoading = false.obs;

  // Search and filter
  var searchQuery = ''.obs;
  var selectedDesignation = ''.obs; // Empty string = "All"

  // Provider detail
  var providerDetail = Rxn<ServiceProviderDetailModel>();
  var isDetailLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDesignations();
    loadAllProviders();
    loadSavedProviders();
  }

  // Load all designations (categories)
  Future<void> loadDesignations() async {
    try {
      isDesignationsLoading.value = true;
      final result = await _repository.getDesignations();
      designations.assignAll(result);
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isDesignationsLoading.value = false;
    }
  }

  // Load all providers
  Future<void> loadAllProviders() async {
    try {
      isLoading.value = true;
      final result = await _repository.getAllProviders();
      allProviders.assignAll(result);
      filteredProviders.assignAll(result);

      if (result.isEmpty) {
        Utils.errorSnackBar('Info', 'No service providers found');
      }
    } catch (e) {
      print('Error loading providers: $e');
      Utils.errorSnackBar('Error', 'Failed to load providers. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Load provider details
  Future<void> loadProviderDetails(int providerId) async {
    try {
      isDetailLoading.value = true;
      final result = await _repository.getProviderDetails(providerId);
      providerDetail.value = result;
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    } finally {
      isDetailLoading.value = false;
    }
  }

  // Load saved providers
  Future<void> loadSavedProviders() async {
    try {
      final result = await _repository.getSavedProviders();
      savedProviders.assignAll(result);
    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // Toggle save/unsave provider
  Future<void> toggleSaveProvider(ServiceProviderModel provider) async {
    try {
      final isSaved = await _repository.toggleSaveProvider(provider.id);

      // Update provider in all lists
      final index = allProviders.indexWhere((p) => p.id == provider.id);
      if (index != -1) {
        allProviders[index].isSaved = isSaved;
      }

      // Update filtered list
      final filteredIndex = filteredProviders.indexWhere((p) => p.id == provider.id);
      if (filteredIndex != -1) {
        filteredProviders[filteredIndex].isSaved = isSaved;
      }

      // Update saved providers list
      if (isSaved) {
        if (!savedProviders.any((p) => p.id == provider.id)) {
          savedProviders.add(provider);
        }
        Utils.successSnackBar(
          'Added to Favorites',
          '${provider.fullName} has been added to your favorites',
        );
      } else {
        savedProviders.removeWhere((p) => p.id == provider.id);
        Utils.successSnackBar(
          'Removed from Favorites',
          '${provider.fullName} has been removed from your favorites',
        );
      }

      // Update detail if loaded
      if (providerDetail.value != null && providerDetail.value!.id == provider.id) {
        providerDetail.value!.isSaved = isSaved;
        providerDetail.refresh();
      }

    } catch (e) {
      Utils.errorSnackBar('Error', e.toString());
    }
  }

  // Check if provider is saved
  bool isSaved(int providerId) {
    return savedProviders.any((p) => p.id == providerId) ||
        allProviders.firstWhereOrNull((p) => p.id == providerId)?.isSaved == true;
  }

  // Update search query
  void updateSearch(String query) {
    searchQuery.value = query;
    filterProviders();
  }

  // Update selected designation (category)
  void updateDesignation(String designation) {
    selectedDesignation.value = designation;
    filterProviders();
  }

  // Filter providers based on search and designation
  void filterProviders() {
    final query = searchQuery.value.toLowerCase().trim();
    final designation = selectedDesignation.value.toLowerCase().trim();

    filteredProviders.value = allProviders.where((provider) {
      // Search filter (name, email, designation)
      final matchesSearch = query.isEmpty ||
          provider.fullName.toLowerCase().contains(query) ||
          provider.designation.toLowerCase().contains(query);

      // Designation filter
      final matchesDesignation = designation.isEmpty ||
          designation == 'all' ||
          provider.designation.toLowerCase() == designation;

      return matchesSearch && matchesDesignation;
    }).toList();
  }

  // Refresh all data
  Future<void> refreshData() async {
    await Future.wait([
      loadAllProviders(),
      loadSavedProviders(),
    ]);
  }

  // Get providers by designation
  List<ServiceProviderModel> getProvidersByDesignation(String designation) {
    if (designation.toLowerCase() == 'all' || designation.isEmpty) {
      return allProviders;
    }
    return allProviders
        .where((p) => p.designation.toLowerCase() == designation.toLowerCase())
        .toList();
  }
}