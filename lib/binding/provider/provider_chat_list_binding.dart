import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/ProviderChatContoller/provider_chat_list_controller.dart';

class ProviderChatListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderChatListController>(() => ProviderChatListController());
  }
}