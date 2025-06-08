// lib/View_Model/Controller/receipt/receipt_details_controller.dart

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../models/myProfileModel/user_purchase_datails.dart';

class UserParchaseReceiptDetailsController extends GetxController {
  final Rx<UserPurchaseDetailsReceiptModel?> receipt =
  Rx<UserPurchaseDetailsReceiptModel?>(null);
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReceiptDetails();
  }

  void fetchReceiptDetails() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    receipt.value = UserPurchaseDetailsReceiptModel.dummy(); // Simulated data
    isLoading.value = false;
  }

  Future<void> generateAndDownloadPdfReceipt() async {
    if (receipt.value == null) {
      Get.snackbar('Error', 'No receipt data available to generate PDF.');
      return;
    }

    final data = receipt.value!;
    final pdf = pw.Document();

    try {
      final bytes = await rootBundle.load(data.merchantImageUrl);
      final image = pw.MemoryImage(bytes.buffer.asUint8List());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'Receipt Details',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 50,
                      height: 50,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(
                          image: image,
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Text(
                      data.merchantName,
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 15),
                _buildInfoRow(
                  text:
                  'Date: ${DateFormat('dd MMMM yyyy').format(data.date)}',
                ),
                _buildInfoRow(text: 'Time: ${data.time}'),
                _buildInfoRow(text: 'Location: ${data.location}'),
                _buildInfoRow(text: 'Order ID: ${data.orderId}'),
                _buildInfoRow(text: 'Ordered via: ${data.orderedVia}'),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Price Details:',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Divider(),
                ...data.items.map(
                      (item) => pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 5),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('${item.quantity} ${item.name}'),
                        pw.Text('\$${item.price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Payment:',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '\$${data.totalPayment.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green700,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Status: ${data.status.name.capitalizeFirst}',
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: _getStatusColor(data.status),
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Spacer(),
                pw.Center(
                  child: pw.Text(
                    'Thank you for your purchase!',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
              ],
            );
          },
        ),
      );

      final String dir = (await getTemporaryDirectory()).path;
      final String path = '$dir/receipt_${data.orderId}.pdf';
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());

      await OpenFilex.open(path);
      Get.snackbar('Success', 'PDF receipt downloaded and opened.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate or open PDF: $e');
      debugPrint('PDF Error: $e');
    }
  }

  pw.Widget _buildInfoRow({required String text}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(width: 8),
          pw.Text(text),
        ],
      ),
    );
  }

  PdfColor _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return PdfColors.green700;
      case OrderStatus.pending:
        return PdfColors.orange700;
      case OrderStatus.cancelled:
        return PdfColors.red700;
      default:
        return PdfColors.black;
    }
  }
}
