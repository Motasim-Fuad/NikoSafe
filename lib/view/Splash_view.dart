
import 'package:flutter/material.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';

import '../View_Model/Services/Splash_services.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashServices _splashServices=SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _splashServices.isLogin();
  }
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.splash,
     body:Center(
       child:Image.asset(ImageAssets.splashScreen),
     ) ,
    );
  }
}
