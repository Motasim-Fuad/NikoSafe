import 'package:get/get.dart';

import '../../../../Repositry/userSearch/explore_repository.dart';
import '../../../../models/userSearch/explore_item_model.dart';

class ExploreController extends GetxController {
  final repository = ExploreRepository();

  var allItems = <ExploreItemModel>[].obs;
  var filteredItems = <ExploreItemModel>[].obs;
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
}
