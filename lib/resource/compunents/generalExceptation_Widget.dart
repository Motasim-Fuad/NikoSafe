import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Colors/app_colors.dart';

class GenaralExceptation_Widget extends StatefulWidget {
  final VoidCallback onPress;
  const GenaralExceptation_Widget({Key? key,required this.onPress}) : super(key: key);

  @override
  State<GenaralExceptation_Widget> createState() => _GenaralExceptation_WidgetState();
}

class _GenaralExceptation_WidgetState extends State<GenaralExceptation_Widget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Icon(Icons.warning_rounded,color: Colors.red,),
          Text("GeneralExpectation".tr),

          GestureDetector(
            onTap:widget.onPress,
            child: Container(
              height: 44,
              width: 160,
              decoration: BoxDecoration(
                color: AppColor.buttonColor,
                borderRadius:BorderRadius.circular(20),
              ),
              child: Center(
                child: Text("Retry",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
              ),
            ),
          )

        ],
      ),
    );
  }
}
