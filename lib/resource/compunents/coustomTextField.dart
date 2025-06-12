import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final Color? fillColor;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    Key? key,
    this.label,
    this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.fillColor,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              label!,
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? const Color(0xFF2C2F38),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey)
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
              onTap: onSuffixTap,
              child: Icon(suffixIcon, color: Colors.grey),
            )
                : null,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.greenAccent),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
