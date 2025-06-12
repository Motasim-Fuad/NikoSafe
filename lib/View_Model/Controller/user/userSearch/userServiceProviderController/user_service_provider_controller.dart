import 'package:get/get.dart';
import '../../../../../Repositry/userSearch/UserServiceProviderRepo/user_services_provider_repo.dart';
import '../../../../../models/userSearch/userServiceProviderModel/user_services_provider.dart';

class UserServiceProviderController extends GetxController {
  final UserServiceProviderRepository _repository = UserServiceProviderRepository();

  var providers = <UserServiceProvider>[].obs;
  var filteredProviders = <UserServiceProvider>[].obs;

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
      final data = await _repository.fetchProviders();
      providers.assignAll(data);
      filteredProviders.assignAll(data);
    } catch (e) {
      // handle error here
      Get.snackbar('Error', 'Failed to fetch providers');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    _filterProviders();
  }

  void updateService(String service) {
    selectedService.value = service;
    _filterProviders();
  }

  void _filterProviders() {
    final query = searchQuery.value.toLowerCase();
    final service = selectedService.value.toLowerCase();

    filteredProviders.value = providers.where((provider) {
      final matchesName = provider.name.toLowerCase().contains(query);
      final matchesService = service.isEmpty || provider.service.toLowerCase() == service;
      return matchesName && matchesService;
    }).toList();
  }
}
