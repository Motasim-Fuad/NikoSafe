import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/home_repositry/home_repositry.dart';
import 'package:nikosafe/Repositry/user_repo/userHome_repo/user_create_post_repo.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/post/createPost/user_create_post_controller.dart';
class UserCreatePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPostRepository>(() => UserPostRepository());
    Get.lazyPut<HomeRepositry>(() => HomeRepositry());
    Get.lazyPut<UserCreatePostController>(() => UserCreatePostController(
      userPostRepository: Get.find<UserPostRepository>(),
      homeRepository: Get.find<HomeRepositry>(),
    ));
  }
}