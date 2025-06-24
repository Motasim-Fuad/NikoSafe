import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../resource/asseets/image_assets.dart';

class PulsingSvgIcon extends StatefulWidget {
  const PulsingSvgIcon({super.key});

  @override
  State<PulsingSvgIcon> createState() => _PulsingSvgIconState();
}

class _PulsingSvgIconState extends State<PulsingSvgIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // keeps looping

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SvgPicture.asset(ImageAssets.paymentSuccessIcon, height: 100),
    );
  }
}
