import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nikosafe/View_Model/Controller/authentication/login_authentication_controller.dart';

class Vendorhome extends StatelessWidget {
   Vendorhome({super.key});
final LoginAuthController controller =Get.put(LoginAuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            Text("Vendor home "),

            TextButton(onPressed: (){
              controller.logout();
            }, child: Text("Logout")),

          ],
        ),
      ),
    );
  }
}
