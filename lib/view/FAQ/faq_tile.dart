import 'package:flutter/material.dart';
import 'package:nikosafe/models/FAQ&Suport/faq_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(
                    faq.isExpanded ? Icons.remove : Icons.add,
                    color: AppColor.limeColor,
                  ),
                ],
              ),
              if (faq.isExpanded) ...[
                SizedBox(height: 12),
                Divider(color: AppColor.limeColor.withOpacity(0.3)),
                SizedBox(height: 8),
                Text(
                  faq.answer,
                  style: TextStyle(
                    color: AppColor.secondaryTextColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}