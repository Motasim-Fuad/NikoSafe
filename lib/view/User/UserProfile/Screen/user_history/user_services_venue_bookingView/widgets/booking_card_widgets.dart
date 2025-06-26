import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';

import '../../../../../../../models/myProfileModel/user_history_booking_model.dart';

class UserHistoryBookingCard extends StatelessWidget {
  final UserHistoryBookingModel booking;

  const UserHistoryBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF294045),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  booking.imageUrl,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    Text(booking.subtitle, style: TextStyle(color: Colors.white.withOpacity(0.6))),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Icon(Icons.schedule, color: Colors.white.withOpacity(0.6), size: 16),
                  Text(booking.time, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.6), size: 18),
              const SizedBox(width: 4),
              Text(booking.day, style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amount Paid', style: TextStyle(color: Colors.white.withOpacity(0.6))),
              Text('\$${booking.amount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildActionButtons(booking.action),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(BookingAction action) {
    switch (action) {
      case BookingAction.cancel:
        return [
          Expanded(
            child: RoundButton(
              title: 'Cancel',
              buttonColor: Colors.red,
              shadowColor: Colors.transparent,
              onPress: (){

              },
            ),
          ),
        ];
      case BookingAction.rebook:
        return [
          Expanded(
            child: RoundButton(
              title: 'Rebook',
              onPress: (){

              },
            ),
          ),
        ];
      case BookingAction.rebookAndReview:
        return [
          Expanded(
            child: RoundButton(
              title: 'Rebook',
              onPress: (){

              },
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: RoundButton(
              title: 'Leave a review',
              buttonColor: AppColor.limeColor,
              shadowColor: Colors.transparent,
              onPress: (){

              },
            ),
          ),
        ];
    }
  }

}

