import 'package:get/get.dart';

import '../../../../Repositry/userHome_repo/feed_repository.dart';
import '../../../../models/userHome/post_model.dart';


class FeedController extends GetxController {
  final FeedRepository _repository = FeedRepository();

  RxList<PostModel> posts = <PostModel>[].obs;
  RxBool isLoading = true.obs;
  var showHealthCard = true.obs;
  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  void loadPosts() async {
    isLoading.value = true;
    posts.value = await _repository.fetchFeedPosts();
    isLoading.value = false;
  }
}
