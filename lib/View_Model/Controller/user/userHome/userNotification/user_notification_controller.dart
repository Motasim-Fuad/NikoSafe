import 'package:get/get.dart';

import '../../../../../Repositry/Notification/user_notification_repositry.dart';
import '../../../../../models/Notification/userNotification_model.dart';

class UserNotificationController extends GetxController {
  final notifications = <UsernotificationModel>[].obs;
  final filteredNotifications = <UsernotificationModel>[].obs;
  final isLoading = false.obs;
  final searchText = ''.obs;

  final _repo = UserNotificationRepository();

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  void fetchNotifications() async {
    isLoading.value = true;
    final data = await _repo.fetchNotifications();
    notifications.value = data;
    filteredNotifications.value = data;
    isLoading.value = false;
  }

  void onSearchChanged(String text) {
    searchText.value = text;
    if (text.isEmpty) {
      filteredNotifications.value = notifications;
    } else {
      filteredNotifications.value = notifications
          .where((n) =>
      n.title.toLowerCase().contains(text.toLowerCase()) ||
          n.message.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
  }

}
