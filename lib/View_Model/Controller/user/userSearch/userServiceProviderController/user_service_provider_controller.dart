import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userSearch/UserServiceProviderRepo/user_services_provider_repo.dart';
import 'package:nikosafe/models/User/userSearch/userServiceProviderModel/user_services_provider.dart';
import 'package:nikosafe/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class UserServiceProviderController extends GetxController {
  final UserServiceProviderRepository repository = UserServiceProviderRepository();

  var providers = <UserServiceProvider>[].obs;
  var filteredProviders = <UserServiceProvider>[].obs;
  var favoriteProviders = <UserServiceProvider>[].obs;

  // Use a reactive map to track favorites
  var favoriteStatus = <String, bool>{}.obs;

  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedService = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProviders();

  }

  Future<void> fetchProviders() async {
    isLoading.value = true;
    try {
      final data = await repository.fetchProviders();
      providers.assignAll(data);
      filteredProviders.assignAll(data);

      // Initialize favorite status
      for (var provider in data) {
        favoriteStatus[provider.id] = provider.isFavorite;
      }

      // ✅ Now load favorites AFTER data is available
      await loadFavorites();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch providers');
    } finally {
      isLoading.value = false;
    }
  }


  void updateSearch(String query) {
    searchQuery.value = query;
    filterProviders();
  }

  void updateService(String service) {
    selectedService.value = service;
    filterProviders();
  }

  void filterProviders() {
    final query = searchQuery.value.toLowerCase();
    final service = selectedService.value.toLowerCase();

    filteredProviders.value = providers.where((provider) {
      final matchesName = provider.name.toLowerCase().contains(query);
      final matchesService = service.isEmpty || provider.service.toLowerCase() == service;
      return matchesName && matchesService;
    }).toList();
  }

  // Fixed favorite functionality using reactive map
  void toggleFavorite(UserServiceProvider provider) {
    final currentStatus = favoriteStatus[provider.id] ?? false;
    favoriteStatus[provider.id] = !currentStatus;

    // Also update the provider's isFavorite property
    final index = providers.indexWhere((p) => p.id == provider.id);
    if (index != -1) {
      providers[index].isFavorite = !currentStatus;
    }

    if (!currentStatus) {
      // Adding to favorites
      if (!favoriteProviders.any((p) => p.id == provider.id)) {
        favoriteProviders.add(provider);
      }
      Utils.successSnackBar(
        'Added to Favorites',
        '${provider.name} has been added to your favorites',

      );
    } else {
      // Removing from favorites
      favoriteProviders.value = getFavoriteProviders();
      Utils.successSnackBar('Removed from Favorites',
          '${provider.name} has been removed from your favorites');
    }

    // Update filtered list
    filterProviders();
    saveFavorites();
  }

  bool isFavorite(String providerId) {
    return favoriteStatus[providerId] ?? false;
  }

  void saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = favoriteProviders.map((e) => e.id).toList();
    prefs.setString('favorite_providers', jsonEncode(favoriteIds));
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('favorite_providers');

    if (jsonString != null) {
      final List<String> favoriteIds = List<String>.from(jsonDecode(jsonString));
      favoriteStatus.clear();
      favoriteProviders.clear();

      for (var provider in providers) {
        final isFav = favoriteIds.contains(provider.id);
        favoriteStatus[provider.id] = isFav;
        if (isFav) {
          favoriteProviders.add(provider);
        }
      }
    }
  }



  List<UserServiceProvider> getFavoriteProviders() {
    return providers.where((p) => favoriteStatus[p.id] == true).toList();
  }
}