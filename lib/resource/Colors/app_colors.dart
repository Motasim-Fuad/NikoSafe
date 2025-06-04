import 'dart:ui';

import 'package:flutter/material.dart';

class AppColor{
  
  static const Color splash= Color(0xff3f6f85);

  static const Color topLinear= Color(0xff2A3D45);
  static const Color bottomLinear= Color(0xff1F2C33);

  static const Color buttonColor= Color(0xff00C1C9);
  static const Color buttonShadeColor= Color(0xff71F50C);

  static const Color primaryTextColor= Color(0xffFFFFFF);
  static const Color secondaryTextColor= Color(0xa3ffffff);
  static const Color blackTextColor= Color(0xff1b1a1a);


  static const Color limeColor= Color(0xff71F50C);


  static const Color iconColor= Color(0x1affffff);



  static const LinearGradient backGroundColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      topLinear,
      bottomLinear,
    ],
  );

}