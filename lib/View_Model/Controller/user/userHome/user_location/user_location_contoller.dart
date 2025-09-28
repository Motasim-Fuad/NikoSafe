import 'package:get/get.dart';
import 'package:nikosafe/Repositry/userHome_repo/user_location_repo.dart';
import '../../../../../models/userCreatePost/UserLocation/user_location_model.dart';


class UserLocationContoller extends GetxController {
  final UserLocationRepository userLocationRepository;

  UserLocationContoller({required this.userLocationRepository});

  // Observable list of locations to display
  final RxList<UserLocationModel> locations = <UserLocationModel>[].obs;
  // Observable for the search query
  final RxString searchQuery = ''.obs;
  // Observable for loading state
  final RxBool isLoading = true.obs;
  // Observable for selected location
  final Rx<UserLocationModel?> selectedLocation = Rx<UserLocationModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _fetchLocations();
    // Debounce the search query to avoid too many API calls
    debounce(searchQuery, (_) => _searchLocations(), time: const Duration(milliseconds: 500));
  }

  Future<void> _fetchLocations() async {
    isLoading.value = true;
    try {
      final fetchedLocations = await userLocationRepository.getRecentPlaces();
      locations.assignAll(fetchedLocations);
    } catch (e) {
      print('Error fetching locations: $e');
      // Handle error, e.g., show a snackbar
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _searchLocations() async {
    isLoading.value = true;
    try {
      final fetchedLocations = await userLocationRepository.searchLocations(searchQuery.value);
      locations.assignAll(fetchedLocations);
    } catch (e) {
      print('Error searching locations: $e');
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void selectLocation(UserLocationModel location) {
    selectedLocation.value = location;
    // Navigate back to the previous screen (CreatePostView) with the selected location
    Get.back(result: location);
  }
}