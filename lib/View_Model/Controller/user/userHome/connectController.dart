import 'package:get/get.dart';

import '../../../../Repositry/userHome_repo/connect_provider_repo.dart';
import '../../../../Repositry/userHome_repo/connect_user_repo.dart';
import '../../../../resource/App_routes/routes_name.dart';
import '../../../../utils/utils.dart';


class ConnectController extends GetxController {
  var selectedType = 'User'.obs;

  final userRepo = ConnectUserRepo();
  final providerRepo = ConnectProviderRepo();

  RxList<dynamic> filteredConnections = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadConnections();
    selectedType.listen((_) => loadConnections());
  }

  void loadConnections() {
    if (selectedType.value == 'User') {
      filteredConnections.value = userRepo.getUsers();
    } else {
      filteredConnections.value = providerRepo.getProviders();
    }
  }

  void sendFriendRequest(String name) {
    Utils.snackBar('Thank You', 'We send friend request $name');
  }

  void goToProfile( connection) {
    print("Going to profile of ${connection.name}");
    Get.toNamed(RouteName.profileDetailsPage, arguments: connection);
  }

}
