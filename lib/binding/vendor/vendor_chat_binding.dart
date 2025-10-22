import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/vendor/chat_controller/vendor_chat_controller.dart';

class VendorChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorChatController>(() => VendorChatController());
  }
}
