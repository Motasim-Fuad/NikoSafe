import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Colors/app_colors.dart';


class InternetExpentionWiedet extends StatefulWidget {
  final VoidCallback onPress;
  const InternetExpentionWiedet({Key? key,required this.onPress}) : super(key: key);

  @override
  State<InternetExpentionWiedet> createState() => _InternetExpentionWiedetState();
}

class _InternetExpentionWiedetState extends State<InternetExpentionWiedet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Icon(Icons.cloud_off,color: Colors.red,),
            Text("internet_Exception".tr),

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
