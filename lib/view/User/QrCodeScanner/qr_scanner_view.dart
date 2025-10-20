import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

class QrScannerView extends StatelessWidget {
  const QrScannerView({super.key});

  void _handleQrCode(String code) {
    // ✅ Console e print koro QR code data
    if (kDebugMode) {
      print('==========================================');
      print('🔍 QR Code Scanned!');
      print('📱 Raw QR Data: $code');
      print('📏 Data Length: ${code.length}');
      print('==========================================');
    }

    // Extract venue ID from URL or direct ID
    int? venueId;

    // ✅ Check for both "venue/" and "venues/" patterns
    if (code.contains('venue/') || code.contains('venues/')) {
      // Extract ID from URL like: .../venue/6 or .../venues/6/menu-items/
      final match = RegExp(r'venue[s]?/(\d+)').firstMatch(code);
      if (match != null) {
        venueId = int.tryParse(match.group(1)!);

        if (kDebugMode) {
          print('✅ Found venue ID in URL: $venueId');
          print('🔗 Full match: ${match.group(0)}');
        }
      } else {
        if (kDebugMode) {
          print('❌ Regex did not match. URL format might be different.');
        }
      }
    } else {
      // Direct ID
      venueId = int.tryParse(code);

      if (kDebugMode) {
        if (venueId != null) {
          print('✅ Parsed as direct ID: $venueId');
        } else {
          print('❌ Could not parse as direct ID');
        }
      }
    }

    if (venueId != null) {
      if (kDebugMode) {
        print('🎯 Navigating to menu with venue ID: $venueId');
        print('==========================================\n');
      }

      // Navigate to menu page with venue ID
      Get.toNamed(RouteName.menu, arguments: {'venueId': venueId});
    } else {
      if (kDebugMode) {
        print('⚠️ Failed to extract venue ID from QR code');
        print('💡 Possible reasons:');
        print('   1. QR code format is different than expected');
        print('   2. URL does not contain "venue/" or "venues/" pattern');
        print('   3. Data is not a valid number');
        print('==========================================\n');
      }

      Get.snackbar(
        'Error',
        'Invalid QR code\nScanned: $code',
        duration: const Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Scan QR Code",
            style: TextStyle(
              color: AppColor.primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: MobileScanner(
          onDetect: (BarcodeCapture capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final String? code = barcodes.first.rawValue;
              if (code != null) {
                _handleQrCode(code);
              }
            }
          },
        ),
      ),
    );
  }
}