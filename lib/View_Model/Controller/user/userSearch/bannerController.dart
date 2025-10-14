// View_Model/Controller/user/userSearch/bannerController.dart
import 'package:get/get.dart';
import 'package:nikosafe/models/User/userSearch/bannerModel.dart';
import 'package:nikosafe/Repositry/user_repo/userSearch/banner_repo.dart';

class BannerController extends GetxController {
  final _repository = BannerRepository();

  // Observable lists
  final RxList<Data> events = <Data>[].obs; // All banners for BannerPromotionsView
  final RxList<Data> recentEvents = <Data>[].obs; // Last 5 for BannerCarousel
  final RxInt currentPage = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllBanners();
    loadRecentBanners();
  }

  // Load all banners (for BannerPromotionsView)
  Future<void> loadAllBanners() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _repository.fetchBanners(requireAuth: true);
      events.value = data;

    } catch (e) {
      errorMessage.value = 'Failed to load banners: $e';
      print('Error in controller: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Load last 5 banners (for BannerCarousel)
  Future<void> loadRecentBanners() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _repository.fetchRecentBanners(requireAuth: true);
      recentEvents.value = data;

    } catch (e) {
      errorMessage.value = 'Failed to load recent banners: $e';
      print('Error in controller: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh all banners
  Future<void> refreshBanners() async {
    await loadAllBanners();
    await loadRecentBanners();
  }

  // Get banner by ID
  Data? getBannerById(int id) {
    try {
      return events.firstWhere((banner) => banner.id == id);
    } catch (e) {
      return null;
    }
  }
}