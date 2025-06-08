class UserHistoryBookingModel {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String time;
  final String day;
  final double amount;
  final BookingAction action;

  UserHistoryBookingModel({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.day,
    required this.amount,
    required this.action,
  });
}

enum BookingAction {
  cancel,
  rebook,
  rebookAndReview,
}
