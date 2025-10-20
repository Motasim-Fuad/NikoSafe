import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import '../../data/Network/network_api_services.dart';

class PaymentService {
  final _apiService = NetworkApiServices();

  /// Step 1: Create Payment Intent
  /// Input: bookingId
  /// Output: clientSecret
  Future<String> createPaymentIntent(int bookingId) async {
    try {
      if (kDebugMode) {
        print('🔄 Creating payment intent for booking: $bookingId');
      }

      final response = await _apiService.postApi(
        {'booking_id': bookingId},
        AppUrl.createPaymentIntentUrl,
        requireAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        final clientSecret = response['data']['client_secret'];

        if (kDebugMode) {
          print('✅ Payment intent created successfully');
          print('Client Secret: $clientSecret');
        }

        return clientSecret;
      } else {
        throw Exception(response['message'] ?? 'Failed to create payment intent');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating payment intent: $e');
      }
      rethrow;
    }
  }

  /// Step 2: Present Payment Sheet
  /// Input: clientSecret, amount (for display)
  /// Output: paymentIntentId or null
  Future<String?> presentPaymentSheet({
    required String clientSecret,
    required double amount,
  }) async {
    try {
      if (kDebugMode) {
        print('🔄 Initializing payment sheet...');
        print('Amount: \$$amount');
      }

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'NikoSafe',
          style: ThemeMode.dark,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: const Color(0xFFCDDC39), // Lime color
              background: const Color(0xFF1B2A3C),
              componentBackground: const Color(0xFF2C3E50),
            ),
          ),
        ),
      );

      if (kDebugMode) {
        print('✅ Payment sheet initialized');
      }

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      if (kDebugMode) {
        print('✅ Payment sheet completed by user');
      }

      // Extract payment intent ID from client secret
      final paymentIntentId = clientSecret.split('_secret_')[0];

      if (kDebugMode) {
        print('Payment Intent ID: $paymentIntentId');
      }

      return paymentIntentId;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Payment sheet error: $e');
      }

      if (e is StripeException) {
        if (kDebugMode) {
          print('Stripe Error Code: ${e.error.code}');
          print('Stripe Error Message: ${e.error.message}');
        }
      }

      return null; // User cancelled or error occurred
    }
  }

  /// Step 3: Confirm Payment
  /// Input: paymentIntentId
  /// Output: success status
  Future<bool> confirmPayment(String paymentIntentId) async {
    try {
      if (kDebugMode) {
        print('🔄 Confirming payment...');
        print('Payment Intent ID: $paymentIntentId');
      }

      final response = await _apiService.postApi(
        {'payment_intent_id': paymentIntentId},
        AppUrl.confirmPaymentUrl,
        requireAuth: true,
      );

      if (response['success'] == true) {
        if (kDebugMode) {
          print('✅ Payment confirmed successfully!');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('❌ Payment confirmation failed: ${response['message']}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error confirming payment: $e');
      }
      return false;
    }
  }

  /// Complete Payment Flow (All 3 steps combined)
  /// Input: bookingId, amount
  /// Output: success status
  Future<bool> processPayment({
    required int bookingId,
    required double amount,
  }) async {
    try {
      // Step 1: Create payment intent
      final clientSecret = await createPaymentIntent(bookingId);

      // Step 2: Present payment sheet
      final paymentIntentId = await presentPaymentSheet(
        clientSecret: clientSecret,
        amount: amount,
      );

      if (paymentIntentId == null) {
        if (kDebugMode) {
          print('⚠️ Payment cancelled by user');
        }
        return false;
      }

      // Step 3: Confirm payment
      final confirmed = await confirmPayment(paymentIntentId);

      return confirmed;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Payment process failed: $e');
      }
      return false;
    }
  }
}












 ///---------use like -------///


// // Example: Quote payment
// final paymentService = PaymentService();
//
// final success = await paymentService.processPayment(
// bookingId: quoteId,  // or any ID
// amount: 500.0,
// );
//
// if (success) {
// // Handle success
// }