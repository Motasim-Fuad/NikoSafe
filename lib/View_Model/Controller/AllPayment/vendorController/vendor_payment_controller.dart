import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nikosafe/models/AllPaymentModel/vendor/vendor_payment_model.dart';
import 'package:nikosafe/utils/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

extension StringCasingExtension on String {
  String get capitalizeFirst =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}

class VendorPaymentController extends GetxController {
  var paymentDetails = VendorPaymentModel(
    amount: 550.99,
    date: DateTime(2023, 12, 31),
    transactionId: '#123456789ef',
    accountName: 'Fuad',
  ).obs;

  var isPaymentSuccessful = false.obs;

  void processPayment() {
    Future.delayed(const Duration(seconds: 2), () {
      isPaymentSuccessful.value = true;
    });
  }

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
                  _buildRow('Date:', DateFormat('dd MMM yyyy').format(data.date)),
                  _buildRow('Transaction ID:', data.transactionId),
                  _buildRow('Account:', data.accountName),
                  pw.Divider(),
                  _buildRow('Total Payment:', '\$${data.amount.toStringAsFixed(2)}'),
                  _buildRow('Total:', '\$${data.amount.toStringAsFixed(2)}'),
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
      Utils.successSnackBar('Success', 'PDF receipt downloaded.');
    } catch (e) {
      Utils.errorSnackBar('Error', 'Failed to generate PDF: $e');
      print('PDF Error: $e');
    }
  }


  pw.Widget _buildRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 14)),
          pw.Text(value, style: const pw.TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
