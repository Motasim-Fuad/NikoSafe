import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/Provider/providerEarningData/providerEarningData.dart';


class EarningListTile extends StatelessWidget {
  final ProviderEarningDataModel earning;
  final VoidCallback onTap;

  const EarningListTile({required this.earning, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: AssetImage(earning.avatarUrl ?? ''),
        backgroundColor: Colors.grey,
      ),
      title: Text(earning.name, style: Get.textTheme.bodyLarge),
      subtitle: Text('${earning.accNumber} • ${earning.date}'),
      trailing: Text(earning.amount, style: Get.textTheme.titleMedium),
    );
  }
}
