import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/models/Notification/userNotification_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/User/userNotification/paymentSuccessView.dart';

class QuotationReviewView extends StatelessWidget {
  final ServiceProvider serviceProvider;
  final QuoteDetails quote;

  const QuotationReviewView({
    super.key,
    required this.serviceProvider,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          title: const Text(
            'Review & Confirm',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Provider Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.iconColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: serviceProvider.profileImageUrl != null
                          ? AssetImage(serviceProvider.profileImageUrl!)
                          : null,
                      child: serviceProvider.profileImageUrl == null
                          ? Text(
                        serviceProvider.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceProvider.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            serviceProvider.profession,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(
                                " ${serviceProvider.rating}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Appointment Date & Time (if available)
              if (serviceProvider.appointmentDate != null) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                         color: AppColor.iconColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            "${serviceProvider.appointmentDate!.day} ${_getMonthName(serviceProvider.appointmentDate!.month)} ${serviceProvider.appointmentDate!.year}",
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.iconColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            serviceProvider.appointmentTime ?? "",
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Payment Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.iconColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Details Section
              const Text(
                'Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Hourly Rate
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hourly Rate',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    '\$${quote.hourlyRate.toStringAsFixed(0)}/hr',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Divider
              Container(
                height: 1,
                color: Colors.white24,
              ),

              const SizedBox(height: 16),

              // Total Payment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Payment:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${quote.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xff78bc4c),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Confirm Button
              RoundButton(
                title: 'Confirm',
                onPress: () {
                  Get.to(UserPaymentSuccesView());
                },

                textColor: Colors.white,
                height: 50,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }



  String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
}