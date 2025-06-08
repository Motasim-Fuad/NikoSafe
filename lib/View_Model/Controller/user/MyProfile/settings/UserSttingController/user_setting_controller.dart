import 'package:get/get.dart';

class UserSettingPasswordController extends GetxController {
  RxBool isObscure = true.obs;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }
}
