import '../../../models/Provider/providerHomeModel/notification_model.dart';


class NotificationRepository {
  Future<List<NotificationModel>> fetchNotifications() async {
    return [
      NotificationModel(
        title: "New Order",
        message: "You received a new moving task.",
        time: "5 min ago",
      ),NotificationModel(
        title: "New Order",
        message: "You received a new moving task.",
        time: "5 min ago",
      ),NotificationModel(
        title: "New Order",
        message: "You received a new moving task.",
        time: "5 min ago",
      ),NotificationModel(
        title: "New Order",
        message: "You received a new moving task.",
        time: "5 min ago",
      ),NotificationModel(
        title: "New Order",
        message: "You received a new moving task.",
        time: "5 min ago",
      ),
      // More dummy notifications...
    ];
  }
}
