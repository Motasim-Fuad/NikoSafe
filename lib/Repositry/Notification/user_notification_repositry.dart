
import '../../models/Notification/userNotification_model.dart';
class UserNotificationRepository {
  Future<List<UsernotificationModel>> fetchNotifications() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    return [
      UsernotificationModel(
        title: "You're Near the Limit! ...",
        message:
        "Based on your weight and drinks logged, your estimated BAC is 0.07%. The legal limit in your area is 0.08%.",
        time: "9:30",
      ),
      UsernotificationModel(
        title: "John wants to connect with you!",
        message:
        "Start sharing drink experiences, check-ins, and explore venues together.",
        time: "9:30",
        action1: "Accept",
        action2: "Ignore",
        action3: "View Profile",
      ),
      UsernotificationModel(
        title: "Quote Received from John (Plumber)",
        message:
        "John has reviewed your job request and sent a price quote. Tap to review & accept",
        time: "9:30",
        action1: "Review Now",
      ),
      UsernotificationModel(
        title: "Exclusive for Our Followers",
        message:
        "First 50 check-ins tonight get a free shot on the house!",
        time: "9:30",
        tag: "Downtown LA",
      ),
    ];
  }
}
