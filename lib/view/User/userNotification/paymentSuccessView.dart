import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/User/userNotification/user_my_payment_details.dart';

class UserPaymentSuccesView extends StatefulWidget {
  const UserPaymentSuccesView({super.key});

  @override
  State<UserPaymentSuccesView> createState() => _UserPaymentSuccesViewState();
}

class _UserPaymentSuccesViewState extends State<UserPaymentSuccesView>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize bounce animation controller
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create bounce animation with smooth up-down movement
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: -20.0, // Move up by 20 pixels
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // Create fade animation for text
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start fade animation first
    _fadeController.forward();

    // Wait a bit then start the bounce animation
    await Future.delayed(const Duration(milliseconds: 300));

    // Repeat bounce animation infinitely
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Animated SVG Icon
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _bounceAnimation.value),
                      child: SvgPicture.asset(
                        ImageAssets.paymentSuccessIcon,
                        // Add some scale animation too for extra effect
                        width: 120,
                        height: 120,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Animated Text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    "Your Payment Successfully Complete",
                    style: TextStyle(
                        color: AppColor.limeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(),

                // Animated Button
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _fadeController,
                      curve: Curves.easeOutBack,
                    )),
                    child: RoundButton(
                      width: double.infinity,
                      title: "View Details",
                      onPress: () {
                        Get.to(UserMyPaymentDetails());
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}