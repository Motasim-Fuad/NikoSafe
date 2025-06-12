import 'package:flutter/material.dart';

class BuildInfoCard extends StatelessWidget {
  final String title;
  final Widget content;

  const BuildInfoCard({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x99254A4A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1,color: Colors.grey)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}
