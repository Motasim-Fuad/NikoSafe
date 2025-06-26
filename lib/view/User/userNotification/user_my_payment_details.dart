import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intl/intl.dart';
import 'dart:io';

// Model for payment details
class PaymentDetailsModel {
  final String serviceName;
  final String providerName;
  final String providerImage;
  final DateTime date;
  final String time;
  final String location;
  final double hourlyRate;
  final double totalAmount;
  final String transactionId;
  final String accountName;

  PaymentDetailsModel({
    required this.serviceName,
    required this.providerName,
    required this.providerImage,
    required this.date,
    required this.time,
    required this.location,
    required this.hourlyRate,
    required this.totalAmount,
    required this.transactionId,
    required this.accountName,
  });
}

// Controller for payment details
class PaymentDetailsController extends GetxController {
  final paymentDetails = Rx<PaymentDetailsModel>(
    PaymentDetailsModel(
      serviceName: "Plumbing Service",
      providerName: "Lukas Wagner",
      providerImage: ImageAssets.userHome_peoplePostImage3,
      date: DateTime(2025, 1, 25),
      time: "2:00 PM",
      location: "123 Main Street, Berlin, Germany, 10115",
      hourlyRate: 15.0,
      totalAmount: 15.0,
      transactionId: "TXN123456789",
      accountName: "Main Account",
    ),
  );

  Future<void> generateAndDownloadPdfReceipt() async {
    final data = paymentDetails.value;
    final pdf = pw.Document();

    try {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      'Payment Receipt',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 30),
                  _buildRow('Service:', data.serviceName),
                  _buildRow('Provider:', data.providerName),
                  _buildRow('Date:', DateFormat('dd MMM yyyy').format(data.date)),
                  _buildRow('Time:', data.time),
                  _buildRow('Location:', data.location),
                  _buildRow('Transaction ID:', data.transactionId),
                  _buildRow('Account:', data.accountName),
                  pw.Divider(thickness: 2),
                  pw.SizedBox(height: 10),
                  _buildRow('Hourly Rate:', '\$${data.hourlyRate.toStringAsFixed(2)}/hr'),
                  _buildRow('Total Payment:', '\$${data.totalAmount.toStringAsFixed(2)}', isTotal: true),
                  pw.Spacer(),
                  pw.Center(
                    child: pw.Text(
                      'Thank you for your payment!',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/payment_receipt_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      await OpenFilex.open(path);
      Get.snackbar(
        'Success',
        'PDF receipt generated and downloaded successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('PDF Error: $e');
    }
  }

  pw.Widget _buildRow(String label, String value, {bool isTotal = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isTotal ? 16 : 12,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isTotal ? 16 : 12,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Main UI Screen
class UserMyPaymentDetails extends StatelessWidget {
  const UserMyPaymentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentDetailsController());

    return Container(
      decoration:  BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "Details",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Obx(() {
          final data = controller.paymentDetails.value;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A4A5C),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Image
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image: AssetImage(ImageAssets.userHome_peopleProfile3),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Booking Text
                          Text(
                            "You have booked ${data.providerName}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Date Row
                          _buildDetailRow(
                            Icons.calendar_today_outlined,
                            "Date",
                            DateFormat('dd MMMM yyyy').format(data.date),
                          ),
                          const SizedBox(height: 16),

                          // Time Row
                          _buildDetailRow(
                            Icons.access_time_outlined,
                            "Time",
                            data.time,
                          ),
                          const SizedBox(height: 16),

                          // Location Row
                          _buildDetailRow(
                            Icons.location_on_outlined,
                            "Location",
                            data.location,
                          ),
                          const SizedBox(height: 32),

                          // Price Details Header
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Price Details",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Hourly Rate
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Hourly Rate (1 Item)",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "\$${data.hourlyRate.toStringAsFixed(0)}/hr",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Divider
                          Divider(
                            color: Colors.white.withOpacity(0.2),
                            thickness: 1,
                          ),
                          const SizedBox(height: 16),

                          // Total Payment
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Payment:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "\$${data.totalAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Color(0xFF4ECDC4),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Buttons
                Column(
                  children: [
                    // Get PDF Receipt Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () => controller.generateAndDownloadPdfReceipt(),
                        icon: const Icon(
                          Icons.download_outlined,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Get PDF Receipt",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Back to Homepage Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (){
                         Get.offAllNamed(RouteName.userBottomNavView);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ECDC4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Back to Homepage",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

