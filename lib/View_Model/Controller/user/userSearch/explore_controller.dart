import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userSearch/explore_repository.dart';
import 'package:nikosafe/models/User/userSearch/explore_item_model.dart';

class ExploreController extends GetxController {
  final repository = ExploreRepository();

  var allItems = <ExploreItemModel>[].obs;
  var filteredItems = <ExploreItemModel>[].obs;
  var favoriteItems = <ExploreItemModel>[].obs;
  var followedItems = <ExploreItemModel>[].obs;

  var selectedCategory = 'all'.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  void loadItems() async {
    final items = await repository.fetchExploreItems();
    allItems.value = items;
    filteredItems.value = items;
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    filteredItems.value = category == 'all'
        ? allItems
        : allItems.where((item) => item.category == category).toList();
  }

  void searchByName(String query) {
    searchQuery.value = query;
    filteredItems.value = allItems
        .where((item) =>
    item.title.toLowerCase().contains(query.toLowerCase()) &&
        (selectedCategory.value == 'all' ||
            item.category == selectedCategory.value))
        .toList();
  }

  // Follow / Unfollow logic
  void toggleFollow(ExploreItemModel item) {
    if (followedItems.contains(item)) {
      followedItems.remove(item);
    } else {
      followedItems.add(item);
    }
  }

  bool isFollowing(String id) {
    return followedItems.any((item) => item.id == id);
  }

  void toggleFavorite(ExploreItemModel item) {
    if (favoriteItems.contains(item)) {
      favoriteItems.remove(item);
    } else {
      favoriteItems.add(item);
    }
  }

  bool isFavorite(String id) {
    return favoriteItems.any((item) => item.id == id);
  }
}

