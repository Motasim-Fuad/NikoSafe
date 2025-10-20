import 'package:nikosafe/models/User/QrCodeScanner/menu_item_model.dart';

class OrderResponse {
  final bool success;
  final String message;
  final int statusCode;
  final OrderData data;

  OrderResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
      data: OrderData.fromJson(json['data'] ?? {}),
    );
  }
}

class OrderData {
  final int id;
  final String orderId;
  final String tableNumber;
  final String status;
  final String totalAmount;

  OrderData({
    required this.id,
    required this.orderId,
    required this.tableNumber,
    required this.status,
    required this.totalAmount,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? '',
      tableNumber: json['table_number'] ?? '',
      status: json['status'] ?? '',
      totalAmount: json['total_amount'] ?? '0.00',
    );
  }
}

class CartItem {
  final MenuItem menuItem;
  int quantity;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
  });

  double get totalPrice => menuItem.discountedPrice * quantity;
}