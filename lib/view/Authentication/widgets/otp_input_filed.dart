import 'package:flutter/material.dart';

class OTPInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String)? onChanged;
  final bool autoFocus;

  const OTPInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        focusNode: focusNode,
        controller: controller,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 20), // <-- white text
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.cyanAccent),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
