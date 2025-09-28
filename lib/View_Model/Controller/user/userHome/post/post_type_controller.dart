// View_Model/Controller/post_type_controller.dart
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/home_repositry/home_repositry.dart';
import 'package:nikosafe/models/userHome/postType_model.dart';


class PostTypeController extends GetxController {
  final HomeRepositry _homeRepository = HomeRepositry();

  var isLoading = false.obs;
  var postTypes = <PostType>[].obs;

  @override
  void onInit() {
    super.onInit();
    getPostTypesData();
  }

  void getPostTypesData() async {
    try {
      isLoading(true);
      final response = await _homeRepository.getPostTypes();

      if (response.success) {
        postTypes.assignAll(response.data);
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}