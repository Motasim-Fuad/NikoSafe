import 'package:flutter/material.dart';

class ForgotPasswordInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const ForgotPasswordInputWidget({
    Key? key,
    required this.controller,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email address",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white30),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              const Icon(Icons.email, color: Colors.cyanAccent),
              const SizedBox(width: 8),
              const Text("Email:", style: TextStyle(color: Colors.white60)),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "you@example.com",
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onSubmit,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.cyan,
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
