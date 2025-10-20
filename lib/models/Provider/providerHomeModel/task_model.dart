class BookingImage {
  final int id;
  final String image;
  final String? name;
  final String createdAt;

  BookingImage({
    required this.id,
    required this.image,
    this.name,
    required this.createdAt,
  });

  factory BookingImage.fromJson(Map<String, dynamic> json) {
    return BookingImage(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      name: json['name'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'created_at': createdAt,
    };
  }
}
class TaskModel {
  final int id;
  final String customerName;
  final String providerName;
  final String? bookingDate;
  final String? bookingTime;
  final String? taskTitle;
  final String? taskDescription;
  final String? location;
  final String hourlyRate;
  final String estimatedHours;
  final String totalAmount;
  final String status;
  final bool isPaid;
  final String createdAt;
  final List<BookingImage>? bookingImages; // এই লাইন যোগ করুন

  TaskModel({
    required this.id,
    required this.customerName,
    required this.providerName,
    this.bookingDate,
    this.bookingTime,
    this.taskTitle,
    this.taskDescription,
    this.location,
    required this.hourlyRate,
    required this.estimatedHours,
    required this.totalAmount,
    required this.status,
    required this.isPaid,
    required this.createdAt,
    this.bookingImages, // এই লাইন যোগ করুন
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      customerName: json['customer_name'] ?? '',
      providerName: json['provider_name'] ?? '',
      bookingDate: json['booking_date'],
      bookingTime: json['booking_time'],
      taskTitle: json['task_title'],
      taskDescription: json['task_description'],
      location: json['location'],
      hourlyRate: json['hourly_rate'] ?? '0.00',
      estimatedHours: json['estimated_hours'] ?? '0.00',
      totalAmount: json['total_amount'] ?? '0.00',
      status: json['status'] ?? 'pending',
      isPaid: json['is_paid'] ?? false,
      createdAt: json['created_at'] ?? '',
      bookingImages: json['booking_images'] != null
          ? (json['booking_images'] as List)
          .map((imageJson) => BookingImage.fromJson(imageJson))
          .toList()
          : null, // এই লাইন যোগ করুন
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'provider_name': providerName,
      'booking_date': bookingDate,
      'booking_time': bookingTime,
      'task_title': taskTitle,
      'task_description': taskDescription,
      'location': location,
      'hourly_rate': hourlyRate,
      'estimated_hours': estimatedHours,
      'total_amount': totalAmount,
      'status': status,
      'is_paid': isPaid,
      'created_at': createdAt,
      'booking_images': bookingImages?.map((image) => image.toJson()).toList(),
    };
  }
}
