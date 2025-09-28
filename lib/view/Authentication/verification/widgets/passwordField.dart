import 'package:flutter/material.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final String? errorText;
  final Function(String)? onChanged;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.label,
    required this.isVisible,
    required this.onToggleVisibility,
    this.errorText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: AppColor.primaryTextColor, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.white30,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            style: const TextStyle(color: Colors.white),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: "Enter Password",
              hintStyle: TextStyle(color: AppColor.secondaryTextColor),
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white60,
                ),
                onPressed: onToggleVisibility,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 5),
          Text(
            errorText!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}