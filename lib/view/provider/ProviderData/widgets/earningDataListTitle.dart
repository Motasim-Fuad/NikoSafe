import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import '../../../../models/Provider/providerEarningData/providerEarningData.dart';

class EarningListTile extends StatelessWidget {
  final ProviderEarningDataModel earning;
  final VoidCallback onTap;

  const EarningListTile({required this.earning, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              backgroundImage: earning.avatarUrl != null && earning.avatarUrl!.isNotEmpty
                  ? AssetImage(earning.avatarUrl!) as ImageProvider
                  : AssetImage('assets/images/default_avatar.png'),
              backgroundColor: Colors.grey,
            ),
            SizedBox(width: 12),

            // Name, Account, Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    earning.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${earning.accNumber} • ${earning.date}',
                    style: TextStyle(
                      color: AppColor.primaryTextColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Amount
            Text(
              earning.amount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
