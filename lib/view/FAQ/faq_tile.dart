import 'package:flutter/material.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

import '../../models/FAQ/faq_model.dart';

class FaqTile extends StatelessWidget {
  final FaqModel faq;
  final VoidCallback onTap;

  const FaqTile({super.key, required this.faq, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(faq.question, style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.primaryTextColor))),
                  Icon(faq.isExpanded ? Icons.remove : Icons.add, color: AppColor.limeColor),
                ],
              ),
              if (faq.isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(faq.answer,style: TextStyle(color: AppColor.secondaryTextColor),),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
