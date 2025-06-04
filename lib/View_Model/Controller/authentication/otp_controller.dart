import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import '../../../data/network/network_api_services.dart';
import '../../../models/Login/User_Responce_models.dart';
import '../../../utils/utils.dart';
import '../login/user_prefrrence/user_preference_view_model.dart';


class OTPController extends GetxController {
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  RxBool isLoading = false.obs;

  late String email;


  @override
  void onInit() {
    super.onInit();
    role = Get.arguments?['role'];
    email = Get.arguments?['email'] ?? '';
    print("Received role in OTPController: $role");

  }

  String role = '';



  void onOTPChange(int index, String value, BuildContext context) {
    if (value.isNotEmpty && index < focusNodes.length - 1) {
      Utils.fieldFocusChange(context, focusNodes[index], focusNodes[index + 1]);
    }
    if (value.isEmpty && index > 0) {
      Utils.fieldFocusChange(context, focusNodes[index], focusNodes[index - 1]);
    }
  }

  String getOtp() => controllers.map((e) => e.text).join();




  void verifyOtp() async {
    final otp = getOtp();
    if (otp.length != 6) {
      Utils.tostMassage("Enter 6 digit OTP");
      return;
    }

    print("my role : $role");
    if (role == 'user') {
      print("my route role : $role");
      Get.toNamed(RouteName.userBottomNavView);
    } else if (role == 'sub_admin') {
      print("my route role : $role");
      Get.toNamed(RouteName.providerBtmNavView);
    }



    // isLoading.value = true;
    // try {
    //   final response = await NetworkApiServices().postApi(
    //     {"otp": otp},
    //     "http://115.127.156.131:2001/api/v1/otp/verify-otp",
    //   );

      // if (response['success']) {
      //   Utils.snackBar("Success", "OTP Verified");
      //
      //   final userModel = UserModel(
      //     token: response['data']['token'],
      //     role: response['data']['role'],
      //   );
      //
      //   await UserPreferences().saveUser(userModel); // save to shared preferences
      //
      //   if (userModel.role == 'user') {
      //     Get.toNamed(RouteName.userHomeView);
      //   } else if (userModel.role == 'sub_admin') {
      //     Get.toNamed(RouteName.prviderHomeView);
      //   }
      // }
      // else {
      //   Utils.snackBar("Failed", response['message'] ?? "OTP Invalid");
      //
      //   // ✅ Navigate based on role
      //   final userModel = UserModel(
      //     token: response['data']['token'],
      //     role: response['data']['role'],
      //   );
      //   await UserPreferences().saveUser(userModel); // save to shared preferences
      //   if (role == 'user') {
      //     Get.toNamed(RouteName.userHomeView);
      //   } else if (role == 'sub_admin') {
      //     Get.toNamed(RouteName.prviderHomeView);
      //   }





    //   }
    // } catch (e) {
      // Utils.snackBar("Error", e.toString());
      //
      // if( e.toString()=="TimeoutException after 0:00:10.000000: Future not completed"){
      //   print(e);
      //   // ✅ Navigate based on role
      //   final response = await NetworkApiServices().postApi(
      //     {"otp": otp},
      //     "http://115.127.156.131:2001/api/v1/otp/verify-otp",
      //   );
      //
      //   final userModel = UserModel(
      //     token: response['data']['token'],
      //     role: response['data']['role'],
      //   );
      //
      //   await UserPreferences().saveUser(userModel); // save to shared preferences
      //
      //   //await UserPreferences().saveUser(userModel); // save to shared preferences
      //   if (role == 'user') {
      //     Get.toNamed(RouteName.userHomeView);
      //   } else if (role == 'sub_admin') {
      //     Get.toNamed(RouteName.prviderHomeView);
      //   }
      }
      // print(e);
      // // ✅ Navigate based on role

      //await UserPreferences().saveUser(userModel); // save to shared preferences
      // if (role == 'user') {
      //   Get.toNamed(RouteName.userHomeView);
      // } else if (role == 'sub_admin') {
      //   Get.toNamed(RouteName.prviderHomeView);
      // }


  //   } finally {
  //     isLoading.value = false;
  //   }
  // }



}
