import 'package:flutter/material.dart';

Widget tabItem(String text, bool isSelected) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? Color(0xFF1EBEA5) : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text, style: TextStyle(color: Colors.white)),
  );
}


Widget tabBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      tabItem('Feed', true),
      SizedBox(width: 12),
      tabItem('Connect', false),
    ],
  );
}