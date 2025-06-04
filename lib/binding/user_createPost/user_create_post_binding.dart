import 'package:get/get.dart';

import 'package:nikosafe/View_Model/Controller/user/userHome/createPost/user_create_post_controller.dart';

import '../../Repositry/userHome_repo/user_create_post_repo.dart';

class UserCreatePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPostRepository>(() => UserPostRepository());
    Get.lazyPut<UserCreatePostController>(
          () => UserCreatePostController(userPostRepository: Get.find()),
    );
  }
}