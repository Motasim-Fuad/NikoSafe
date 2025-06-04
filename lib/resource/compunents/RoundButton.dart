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
  }) : super(key: key);

  final bool loading;
  final String title;
  final double height, width;
  final VoidCallback onPress;
  final Color textColor, buttonColor,shadowColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor, // Shadow color
              offset: Offset(0, 4), // Horizontal and vertical offset
              blurRadius: 1, // Softness of the shadow
              spreadRadius: -1, // How wide the shadow spreads
            ),
          ],
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Center(
          child: Text(
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
