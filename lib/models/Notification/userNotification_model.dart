class UsernotificationModel {
  final String title;
  final String message;
  final String time;
  final String? tag; // e.g. "Downtown LA", "Plumber"
  final String? action1;
  final String? action2;
  final String? action3;

  // Service Provider Details
  final ServiceProvider? serviceProvider;
  final QuoteDetails? quote;
  final NotificationType type;

  UsernotificationModel({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.tag,
    this.action1,
    this.action2,
    this.action3,
    this.serviceProvider,
    this.quote,
  });
}

class ServiceProvider {
  final String name;
  final String profession; // "Plumber", "Electrician", "Therapist", "Trainer"
  final String email;
  final String phoneNumber;
  final String location;
  final double rating;
  final String? profileImageUrl;
  final DateTime? appointmentDate;
  final String? appointmentTime;

  ServiceProvider({
    required this.name,
    required this.profession,
    required this.email,
    required this.phoneNumber,
    required this.location,
    required this.rating,
    this.profileImageUrl,
    this.appointmentDate,
    this.appointmentTime,
  });
}

class QuoteDetails {
  final String taskTitle;
  final String taskDescription;
  final double hourlyRate;
  final double totalAmount;
  final String currency;
  final DateTime? validUntil;
  final QuoteStatus status;

  QuoteDetails({
    required this.taskTitle,
    required this.taskDescription,
    required this.hourlyRate,
    required this.totalAmount,
    this.currency = "USD",
    this.validUntil,
    this.status = QuoteStatus.pending,
  });
}

enum NotificationType {
  general,
  connection,
  quote,
  promotion,
  alert,
  appointment,
}

enum QuoteStatus {
  pending,
  accepted,
  declined,
  expired,
}