import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../View_Model/Controller/authentication/authentication_view_model.dart';

class ProviderHomeView extends StatelessWidget {
  const ProviderHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthViewModel controller= Get.put(AuthViewModel());
    return Scaffold(
      appBar: AppBar(title: Text("provider"),actions: [
        IconButton(onPressed: (){
          controller.logout();
        }, icon: Icon(Icons.logout)),
      ],),
    );
  }
}
