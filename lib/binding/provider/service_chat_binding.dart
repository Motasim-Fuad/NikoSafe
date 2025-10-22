import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/ProviderChatContoller/service_chat_controller.dart';

class ServiceChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceChatController>(() => ServiceChatController());
  }
}