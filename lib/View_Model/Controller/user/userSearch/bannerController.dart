// controllers/event_controller.dart
import 'package:get/get.dart';
import '../../../../Repositry/userSearch/banner_repo.dart';
import '../../../../models/userSearch/bannerModel.dart';


class BannerController extends GetxController {
  final RxList<BannerModel> events = <BannerModel>[].obs;
  final RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  void loadEvents() {
    final repo = BannerRepository();
    events.value = repo.fetchEvents();
  }
}

