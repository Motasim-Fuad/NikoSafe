// lib/View/Receipt/receipt_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:nikosafe/models/User/myProfileModel/user_purchase_datails.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';

import '../../../../../../View_Model/Controller/user/MyProfile/user_parchase_details_veiw_model/user_parchase_details_view_model.dart';


class UserParchaseReceiptDetailsPage extends StatelessWidget {
  final UserParchaseReceiptDetailsController controller = Get.put(UserParchaseReceiptDetailsController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Dark background color
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Transparent app bar
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            'Details',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF66FCF1), // Teal/Cyan color for spinner
              ),
            );
          }

          final receipt = controller.receipt.value;
          if (receipt == null) {
            return const Center(
              child: Text(
                'No receipt details found.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.iconColor, // Darker shade for the card
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Merchant Name and Image
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: AssetImage(receipt.merchantImageUrl),
                                backgroundColor: Colors.white12, // Placeholder background
                              ),
                              const SizedBox(height: 10),
                              Text(
                                receipt.merchantName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Details Section
                        _buildDetailRow(
                          icon: Icons.calendar_today,
                          label: 'Date',
                          value: DateFormat('dd MMMM yyyy').format(receipt.date),
                        ),
                        const SizedBox(height: 10),
                        _buildDetailRow(
                          icon: Icons.access_time,
                          label: 'Time',
                          value: receipt.time,
                        ),
                        const SizedBox(height: 10),
                        _buildDetailRow(
                          icon: Icons.location_on,
                          label: 'Location',
                          value: receipt.location,
                        ),
                        const SizedBox(height: 10),
                        _buildDetailRow(
                          icon: Icons.qr_code_sharp, // Using sharp variant for better visual match
                          label: 'Order ID',
                          value: receipt.orderId,
                        ),
                        const SizedBox(height: 10),
                        _buildDetailRow(
                          icon: Icons.receipt_long, // Using a more appropriate icon for receipt
                          label: 'Ordered via',
                          value: receipt.orderedVia,
                        ),
                        const SizedBox(height: 20),

                        // Price Details Section
                        const Text(
                          'Price Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(color: Colors.white30, height: 20),
                        ...receipt.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.quantity} ${item.name}',
                                style: const TextStyle(color: Colors.white70, fontSize: 15),
                              ),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white70, fontSize: 15),
                              ),
                            ],
                          ),
                        )).toList(),
                        const Divider(color: Colors.white30, height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Payment:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${receipt.totalPayment.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Color(0xFF66FCF1), // Teal/Cyan color for total
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Status: ${receipt.status.name.capitalizeFirst}', // Display order status
                            style: TextStyle(
                              fontSize: 14,
                              color: _getStatusColor(receipt.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: controller.generateAndDownloadPdfReceipt,
                        icon: const Icon(Icons.download, color: Colors.white),
                        label: const Text(
                          'Get PDF Receipt',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    RoundButton(width: double.infinity,title: "Back to Homepage", onPress: (){
                      Get.offAllNamed(RouteName.userBottomNavView);
                    }),

                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align to top for multiline values
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return const Color(0xFF66FCF1); // Teal/Cyan
      case OrderStatus.pending:
        return Colors.orangeAccent;
      case OrderStatus.cancelled:
        return Colors.redAccent;
      default:
        return Colors.white70;
    }
  }
}