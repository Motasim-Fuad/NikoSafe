// Path: View_Model/Controller/user/userSearch/explore_controller.dart
// COMPLETE FILE - Replace entire file

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  var isLoading = false.obs;
  var isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  // Load all items from API
  Future<void> loadItems() async {
    try {
      isLoading.value = true;

      if (kDebugMode) {
        print('🔄 Loading venues from API...');
      }

      final items = await repository.fetchExploreItems();
      allItems.value = items;
      filteredItems.value = items;

      if (kDebugMode) {
        print('✅ Loaded ${items.length} venues');
        print('   - Restaurants: ${items.where((e) => e.category == 'restaurant').length}');
        print('   - Bars: ${items.where((e) => e.category == 'bar').length}');
        print('   - Club Events: ${items.where((e) => e.category == 'club_event').length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading venues: $e');
      }

      Get.snackbar(
        'Error',
        'Failed to load venues. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Filter by category
  void filterByCategory(String category) {
    selectedCategory.value = category;
    filteredItems.value = category == 'all'
        ? allItems
        : allItems.where((item) => item.category == category).toList();

    if (kDebugMode) {
      print('📊 Filtered to ${filteredItems.length} items for category: $category');
    }
  }

  // Search by name
  void searchByName(String query) {
    searchQuery.value = query;
    filteredItems.value = allItems
        .where((item) =>
    item.title.toLowerCase().contains(query.toLowerCase()) &&
        (selectedCategory.value == 'all' ||
            item.category == selectedCategory.value))
        .toList();

    if (kDebugMode) {
      print('🔍 Search results: ${filteredItems.length} items for query: $query');
    }
  }

  // FIXED: Follow/Unfollow with API
  Future<void> toggleFollow(ExploreItemModel item) async {
    try {
      final venueId = int.parse(item.id);
      final success = await repository.toggleFollowVenue(venueId);

      if (success) {
        if (followedItems.contains(item)) {
          followedItems.remove(item);
        } else {
          followedItems.add(item);
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to update follow status',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error toggling follow: $e');
      }
    }
  }

  bool isFollowing(String id) {
    return followedItems.any((item) => item.id == id);
  }

  // FIXED: Favorite/Unfavorite with API
  Future<void> toggleFavorite(ExploreItemModel item) async {
    try {
      final venueId = int.parse(item.id);
      final success = await repository.toggleFavoriteVenue(venueId);

      if (success) {
        if (favoriteItems.contains(item)) {
          favoriteItems.remove(item);
          Get.snackbar(
            'Removed',
            '${item.title} removed from favorites',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
        } else {
          favoriteItems.add(item);
          Get.snackbar(
            'Added',
            '${item.title} added to favorites',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to update favorite status',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error toggling favorite: $e');
      }
    }
  }

  bool isFavorite(String id) {
    return favoriteItems.any((item) => item.id == id);
  }

  // FIXED: Create review with better UI feedback
  Future<bool> createReviewFromStar({
    required ExploreItemModel item,
    required int rating,
  }) async {
    try {
      // Show loading dialog
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final venueId = int.parse(item.id);
      final success = await repository.createReview(
        venueId: venueId,
        reviewText: 'Rated ${rating} stars',
        rating: rating,
      );

      // Close loading dialog
      Get.back();

      if (success) {
        // Reload data
        await loadItems();

        Get.snackbar(
          'Success',
          'Thank you for your rating!',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );

        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit rating',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (kDebugMode) {
        print('❌ Error creating review: $e');
      }

      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }
  }

  // Create detailed review
  Future<bool> createReview({
    required int venueId,
    required String reviewText,
    required int rating,
  }) async {
    try {
      if (reviewText.trim().isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please enter a review text',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      if (rating < 1 || rating > 5) {
        Get.snackbar(
          'Validation Error',
          'Rating must be between 1 and 5',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      isLoading.value = true;

      final success = await repository.createReview(
        venueId: venueId,
        reviewText: reviewText,
        rating: rating,
      );

      if (success) {
        await loadItems();

        Get.snackbar(
          'Success',
          'Your review has been posted!',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );

        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to post review',
          snackPosition: SnackPosition.BOTTOM,
        );

        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating review: $e');
      }

      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    try {
      isRefreshing.value = true;
      await loadItems();
    } finally {
      isRefreshing.value = false;
    }
  }

  // Get venues by category
  List<ExploreItemModel> getVenuesByCategory(String category) {
    return allItems.where((item) => item.category == category).toList();
  }
}