class UsernotificationModel {
  final String title;
  final String message;
  final String time;
  final String? tag; // e.g. "Downtown LA", "Plumber"
  final String? action1;
  final String? action2;
  final String? action3;

  UsernotificationModel({
    required this.title,
    required this.message,
    required this.time,
    this.tag,
    this.action1,
    this.action2,
    this.action3,
  });
}

