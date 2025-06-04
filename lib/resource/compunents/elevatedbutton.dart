import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final RxBool? isLoading; // Optional reactive loading state
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final EdgeInsets padding;
  final double elevation;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading, // Optional
    this.backgroundColor = const Color(0x335EBFBB),
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.borderRadius = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.elevation = 7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If isLoading is null, return normal button
    if (isLoading == null) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: elevation,
          textStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(text),
      );
    }

    // Else, reactive version
    return Obx(() => ElevatedButton(
      onPressed: isLoading!.value ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: elevation,
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: isLoading!.value
          ? SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: textColor,
          strokeWidth: 2,
        ),
      )
          : Text(text),
    ));
  }
}




// with loading call btn

// final RxBool isLoading = false.obs;
//
// CustomElevatedButton(
// text: "Login",
// isLoading: isLoading,
// onPressed: () async {
// isLoading.value = true;
// await Future.delayed(Duration(seconds: 2));
// isLoading.value = false;
// },
// )
