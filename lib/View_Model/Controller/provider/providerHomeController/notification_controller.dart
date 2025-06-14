import 'package:get/get.dart';
import '../../../../Repositry/Provider/providerHomeRepo/notification_repo.dart';
import '../../../../models/Provider/providerHomeModel/notification_model.dart';

class NotificationController extends GetxController {
  final NotificationRepository _repo = NotificationRepository();

  var notifications = <NotificationModel>[].obs;           // All fetched
  var filteredNotifications = <NotificationModel>[].obs;   // Filtered list
  var searchText = ''.obs;

  void loadNotifications() async {
    final fetched = await _repo.fetchNotifications();
    notifications.value = fetched;
    filteredNotifications.value = fetched;
  }

  void onSearchChanged(String value) {
    searchText.value = value;

    if (value.isEmpty) {
      filteredNotifications.value = notifications;
    } else {
      filteredNotifications.value = notifications
          .where((item) =>
      item.title.toLowerCase().contains(value.toLowerCase()) ||
          item.message.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
  }
}
