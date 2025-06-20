import 'package:get/get.dart';

import '../../../../Repositry/userHome_repo/connect_user_repo.dart';
import '../../../../resource/App_routes/routes_name.dart' show RouteName;
import '../../../../utils/utils.dart';

class ConnectController extends GetxController {
  final userRepo = ConnectUserRepo();

  RxList<dynamic> allConnections = <dynamic>[].obs;
  RxList<dynamic> filteredConnections = <dynamic>[].obs;
  RxString searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadConnections();
    searchText.listen((_) => applySearchFilter());
  }

  void loadConnections() {
    allConnections.value = userRepo.getUsers();
    applySearchFilter();
  }

  void updateSearch(String text) {
    searchText.value = text;
  }

  void applySearchFilter() {
    final query = searchText.value.toLowerCase();
    filteredConnections.value = allConnections.where((conn) {
      return conn.name.toLowerCase().contains(query);
    }).toList();
  }

  void sendFriendRequest(String name) {
    Utils.infoSnackBar('Thank You', 'We sent a friend request to $name');
  }

  void goToProfile(connection) {
    Get.toNamed(RouteName.profileDetailsPage, arguments: connection);
  }
}
