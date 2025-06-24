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
    this.showLoader = false, // ✅ show circular loader
    this.showLoadingText = false, // ✅ show loading text
  }) : super(key: key);

  final bool loading;
  final String title;
  final String loadingText;
  final bool showLoader;
  final bool showLoadingText;
  final double height, width;
  final VoidCallback onPress;
  final Color textColor, buttonColor, shadowColor;

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
              : Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}


//
// RoundButton(
// title: 'Proceed to Pay',
// loading: true,
// loadingText: 'Pay to proceed...',
// showLoader: true,
// showLoadingText: true,
// onPress: () {},
// ),


// 📝 Only loading text (no spinner):

// RoundButton(
// title: 'Proceed to Pay',
// loading: true,
// loadingText: 'Processing...',
// showLoader: false,
// showLoadingText: true,
// onPress: () {},
// ),



// 🔄 Only spinner (no text):

// RoundButton(
// title: 'Proceed to Pay',
// loading: true,
// showLoader: true,
// showLoadingText: false,
// onPress: () {},
// ),