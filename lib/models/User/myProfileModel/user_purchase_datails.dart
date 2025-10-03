import 'package:nikosafe/resource/asseets/image_assets.dart';

enum OrderStatus { delivered, pending, cancelled }

class ReceiptItem {
  final String name;
  final int quantity;
  final double price;

  ReceiptItem({required this.name, required this.quantity, required this.price});
}

class UserPurchaseDetailsReceiptModel {
  final String merchantName;
  final String merchantImageUrl;
  final DateTime date;
  final String time;
  final String location;
  final String orderId;
  final String orderedVia;
  final double totalPayment;
  final OrderStatus status;
  final List<ReceiptItem> items;

  UserPurchaseDetailsReceiptModel({
    required this.merchantName,
    required this.merchantImageUrl,
    required this.date,
    required this.time,
    required this.location,
    required this.orderId,
    required this.orderedVia,
    required this.totalPayment,
    required this.status,
    required this.items,
  });

  factory UserPurchaseDetailsReceiptModel.dummy() {
    return UserPurchaseDetailsReceiptModel(
      merchantName: 'SuperMart',
      merchantImageUrl: ImageAssets.bar3,
      date: DateTime.now(),
      time: '3:45 PM',
      location: '123 Market Street, New York',
      orderId: 'ORD20250608',
      orderedVia: 'Mobile App',
      totalPayment: 79.99,
      status: OrderStatus.delivered,
      items: [
        ReceiptItem(name: 'Apple', quantity: 3, price: 6.99),
        ReceiptItem(name: 'Bread', quantity: 1, price: 2.49),
        ReceiptItem(name: 'Milk', quantity: 2, price: 4.50),
      ],
    );
  }
}
