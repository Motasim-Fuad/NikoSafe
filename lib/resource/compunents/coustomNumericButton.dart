import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class CustomNeumorphicButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? height;
  final Color? textColor;
  final Color? backgroundColor;
  final double? labelDepth; // ✅ New field for text depth
  final double? Depth; // ✅ New field for text depth

  const CustomNeumorphicButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.height,
    this.textColor,
    this.backgroundColor,
    this.labelDepth, // ✅ Allow optional custom depth
    this.Depth, // ✅ Allow optional custom depth
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: NeumorphicButton(
        onPressed: isLoading ? null : onPressed,
        style: NeumorphicStyle(
          color: backgroundColor ?? Color(0x427a6a6a),
          depth: labelDepth ?? -5,
          intensity: 1,
          shape: NeumorphicShape.convex,
          surfaceIntensity: 0.2,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : NeumorphicText(
          label,
          style: NeumorphicStyle(
            color: textColor ?? Colors.white,
            depth: labelDepth ?? 10, // ✅ Use custom or default depth
          ),
          textStyle: NeumorphicTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
