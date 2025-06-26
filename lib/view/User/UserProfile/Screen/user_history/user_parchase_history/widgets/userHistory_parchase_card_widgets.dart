import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/models/myProfileModel/user_history_purchase_model.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';


class UserhistoryParchaseCardWidgets extends StatelessWidget {
  final UserHistoryPurchaseModel purchase;

  const UserhistoryParchaseCardWidgets({super.key, required this.purchase});

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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  purchase.imageUrl,
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
                    Text(
                      purchase.itemName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule, color: Colors.white.withOpacity(0.6), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          purchase.time,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.6), size: 18),
              const SizedBox(width: 4),
              Text(purchase.date, style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amount Paid', style: TextStyle(color: Colors.white.withOpacity(0.6))),
              Text('\$${purchase.amount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status', style: TextStyle(color: Colors.white.withOpacity(0.6))),
              purchase.isDelivered?Text("Delivered",style: TextStyle(color: AppColor.primaryTextColor)):Text("Pending",style: TextStyle(color: AppColor.primaryTextColor),)
            ],
          ),

          const SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     // Delivery Status
          //     Container(
          //       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          //       decoration: BoxDecoration(
          //         color: purchase.isDelivered ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
          //         border: Border.all(color: purchase.isDelivered ? Colors.green : Colors.orange),
          //         borderRadius: BorderRadius.circular(30),
          //       ),
          //       child: Text(
          //         purchase.isDelivered ? 'Delivered' : 'Pending',
          //         style: TextStyle(
          //           color: purchase.isDelivered ? Colors.green : Colors.orange,
          //         ),
          //       ),
          //     ),
          //
          //     // View Button
          //     GestureDetector(
          //       onTap: () {
          //         // TODO: Handle view action
          //         Get.toNamed(RouteName.userParchaseReceiptDetailsPage);
          //         print('View tapped for ${purchase.itemName}');
          //       },
          //       child: Container(
          //         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          //         decoration: BoxDecoration(
          //           color: Colors.blue.withOpacity(0.1),
          //           border: Border.all(color: Colors.blue),
          //           borderRadius: BorderRadius.circular(30),
          //         ),
          //         child: const Text(
          //           'View',
          //           style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

        SizedBox(height: 20,),
          purchase.isDelivered ?  RoundButton(width: double.infinity,title: "View", onPress: (){
            Get.toNamed(RouteName.userParchaseReceiptDetailsPage);
          }) : SizedBox(child: Row(
            children: [
              Expanded(child: RoundButton(buttonColor: Colors.red,shadowColor: Colors.transparent,title: "cancel", onPress: (){})),
              SizedBox(width: 10,),
              Expanded(child: RoundButton(title: "view", onPress: (){
                Get.toNamed(RouteName.userParchaseReceiptDetailsPage);
              })),
            ],
          ),),


        ],
      ),
    );
  }
}
