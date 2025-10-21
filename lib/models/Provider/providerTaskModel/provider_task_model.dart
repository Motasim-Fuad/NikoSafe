class ProviderServicesModel {
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
  final List<BookingImage> bookingImages;
  final bool isPaid;
  final String createdAt;

  ProviderServicesModel({
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
    required this.bookingImages,
    required this.isPaid,
    required this.createdAt,
  });

  factory ProviderServicesModel.fromJson(Map<String, dynamic> json) {
    return ProviderServicesModel(
      id: json['id'],
      customerName: json['customer_name'] ?? 'N/A',
      providerName: json['provider_name'] ?? 'N/A',
      bookingDate: json['booking_date'],
      bookingTime: json['booking_time'],
      taskTitle: json['task_title'],
      taskDescription: json['task_description'],
      location: json['location'],
      hourlyRate: json['hourly_rate'] ?? '0.00',
      estimatedHours: json['estimated_hours'] ?? '0.00',
      totalAmount: json['total_amount'] ?? '0.00',
      status: json['status'] ?? 'pending',
      bookingImages: (json['booking_images'] as List?)
          ?.map((img) => BookingImage.fromJson(img))
          .toList() ??
          [],
      isPaid: json['is_paid'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }

  String get displayDate => bookingDate ?? 'N/A';
  String get displayTime => bookingTime ?? 'N/A';
  String get displayTask => taskTitle ?? 'No title';
}

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
      id: json['id'],
      image: json['image'],
      name: json['name'],
      createdAt: json['created_at'],
    );
  }
}