import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userHome_repo/user_location_repo.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/user_location/user_location_contoller.dart';


class UserLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserLocationRepository>(() => UserLocationRepository());
    Get.lazyPut<UserLocationContoller>(
          () => UserLocationContoller(userLocationRepository: Get.find()),
    );
  }
}
