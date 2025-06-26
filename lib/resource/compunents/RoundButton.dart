import 'package:flutter/material.dart';
import '../Colors/app_colors.dart';

class RoundButton extends StatelessWidget {
  RoundButton({
    Key? key,
    this.buttonColor = AppColor.buttonColor,
    this.shadowColor = AppColor.buttonShadeColor,
    this.textColor = AppColor.primaryTextColor,
    required this.title,
    required this.onPress,
    this.width = 60,
    this.height = 50,
    this.loading = false,
    this.loadingText = 'Please wait...',
    this.showLoader = false,
    this.showLoadingText = false,
    this.icon, // 👈 optional icon added
    this.iconSpacing = 8.0, // spacing between icon and text
  }) : super(key: key);

  final bool loading;
  final String title;
  final String loadingText;
  final bool showLoader;
  final bool showLoadingText;
  final double height, width;
  final VoidCallback onPress;
  final Color textColor, buttonColor, shadowColor;
  final IconData? icon; // 👈 optional icon
  final double iconSpacing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 4),
              blurRadius: 1,
              spreadRadius: -1,
            ),
          ],
        ),
        child: Center(
          child: loading
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLoader)
                const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              if (showLoader && showLoadingText)
                const SizedBox(width: 10),
              if (showLoadingText)
                Text(
                  loadingText,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: textColor),
                ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(icon, color: textColor, size: 20),
              if (icon != null)
                SizedBox(width: iconSpacing),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
