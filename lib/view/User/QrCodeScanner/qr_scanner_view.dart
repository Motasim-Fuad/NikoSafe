import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScannerView extends StatelessWidget {
  const QrScannerView({super.key});

  Future<void> _launchURL(String url) async {
    if (!url.startsWith('http')) {
      Get.snackbar("Invalid", "Scanned data is not a valid URL");
      return;
    }

    final Uri uri = Uri.parse(url.trim());
    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        Get.snackbar("Error", "Could not launch URL");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to launch URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title:  Text("Scan QR Code",style: TextStyle(color: AppColor.primaryTextColor,fontWeight: FontWeight.bold),),backgroundColor: Colors.transparent,centerTitle: true,),
        body: MobileScanner(
          onDetect: (BarcodeCapture capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final String? code = barcodes.first.rawValue;
              if (code != null) {
                _launchURL(code); // 👈 directly launch the scanned URL
              }
            }
          },
        ),
      ),
    );
  }
}
