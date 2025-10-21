class ProviderEarningDataModel {
  final int id;
  final String amount;
  final String transactionType;
  final String status;
  final String createdAt;
  final BookingDetails? bookingDetails;

  ProviderEarningDataModel({
    required this.id,
    required this.amount,
    required this.transactionType,
    required this.status,
    required this.createdAt,
    this.bookingDetails,
  });

  factory ProviderEarningDataModel.fromJson(Map<String, dynamic> json) {
    return ProviderEarningDataModel(
      id: json['id'] ?? 0,
      amount: json['amount']?.toString() ?? '0.00',
      transactionType: json['transaction_type'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      bookingDetails: json['booking_details'] != null
          ? BookingDetails.fromJson(json['booking_details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'transaction_type': transactionType,
      'status': status,
      'created_at': createdAt,
      'booking_details': bookingDetails?.toJson(),
    };
  }

  String get formattedAmount => '\$$amount';

  String get formattedDate {
    try {
      final date = DateTime.parse(createdAt);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return createdAt;
    }
  }

  String get customerName => bookingDetails?.customerName ?? 'N/A';
  String get taskTitle => bookingDetails?.taskTitle ?? 'N/A';
}

class BookingDetails {
  final String? taskTitle;
  final String? customerName;
  final String? date;

  BookingDetails({
    this.taskTitle,
    this.customerName,
    this.date,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      taskTitle: json['task_title'],
      customerName: json['customer_name'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_title': taskTitle,
      'customer_name': customerName,
      'date': date,
    };
  }
}

class EarningsResponseModel {
  final bool success;
  final String message;
  final int statusCode;
  final EarningsData data;

  EarningsResponseModel({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory EarningsResponseModel.fromJson(Map<String, dynamic> json) {
    return EarningsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
      data: EarningsData.fromJson(json['data'] ?? {}),
    );
  }
}

class EarningsData {
  final double balance;
  final double totalEarnings;
  final double totalWithdrawals;
  final List<ProviderEarningDataModel> earnings;

  EarningsData({
    required this.balance,
    required this.totalEarnings,
    required this.totalWithdrawals,
    required this.earnings,
  });

  factory EarningsData.fromJson(Map<String, dynamic> json) {
    return EarningsData(
      balance: (json['balance'] ?? 0).toDouble(),
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
      totalWithdrawals: (json['total_withdrawals'] ?? 0).toDouble(),
      earnings: (json['earnings'] as List<dynamic>?)
          ?.map((e) => ProviderEarningDataModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class WithdrawalModel {
  final int id;
  final String amount;
  final String region;
  final String status;
  final String createdAt;

  WithdrawalModel({
    required this.id,
    required this.amount,
    required this.region,
    required this.status,
    required this.createdAt,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalModel(
      id: json['id'] ?? 0,
      amount: json['amount']?.toString() ?? '0.00',
      region: json['region'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'region': region,
      'status': status,
      'created_at': createdAt,
    };
  }

  String get formattedAmount => '\$$amount';

  String get formattedDate {
    try {
      final date = DateTime.parse(createdAt);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return createdAt;
    }
  }
}

class WithdrawalsResponseModel {
  final bool success;
  final String message;
  final int statusCode;
  final List<WithdrawalModel> data;

  WithdrawalsResponseModel({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory WithdrawalsResponseModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => WithdrawalModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}