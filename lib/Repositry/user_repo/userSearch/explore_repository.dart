// Path: Repositry/user_repo/userSearch/explore_repository.dart
// COMPLETE FILE - Replace entire file
import 'package:flutter/foundation.dart';
import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/models/User/userSearch/allVenueModel.dart';
import 'package:nikosafe/models/User/userSearch/explore_item_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class ExploreRepository {
  final _apiService = NetworkApiServices();

  // FIXED: Only 3 slugs needed for filtering
  final Map<String, String> _categorySlugMap = {
    'restaurant': 'restaurant',
    'bar': 'bar-lounge',
    'club_event': 'event-venue',
  };

  // Fetch all explore items from API
  Future<List<ExploreItemModel>> fetchExploreItems() async {
    try {
      List<ExploreItemModel> allItems = [];

      // Fetch venues for each category
      for (var category in _categorySlugMap.keys) {
        final items = await fetchVenuesByCategory(category);
        allItems.addAll(items);
      }

      if (kDebugMode) {
        print('✅ Total venues fetched: ${allItems.length}');
      }

      return allItems;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching explore items: $e');
      }
      return [];
    }
  }

  // FIXED: Fetch venues and FILTER by slug
  Future<List<ExploreItemModel>> fetchVenuesByCategory(String category) async {
    try {
      final targetSlug = _categorySlugMap[category];
      if (targetSlug == null) {
        if (kDebugMode) {
          print('❌ Invalid category: $category');
        }
        return [];
      }

      // Fetch ALL venues (without slug parameter)
      final url = AppUrl.getAllVenuesUrl;

      if (kDebugMode) {
        print('🔍 Fetching venues for category: $category');
        print('📍 Target slug: $targetSlug');
        print('📍 URL: $url');
      }

      // Make API call
      final response = await _apiService.getApi(url, requireAuth: true);

      if (response == null) {
        if (kDebugMode) {
          print('❌ No response from API for $category');
        }
        return [];
      }

      // Parse response
      final venueResponse = AllVenueResponseModel.fromJson(response);

      // FIXED: Filter venues by slug
      final filteredVenues = venueResponse.results.where((venue) {
        // Check if venue has the target slug in its hospitality_venue_type list
        return venue.hospitalityVenueType.any((type) => type.slug == targetSlug);
      }).toList();

      if (kDebugMode) {
        print('✅ Found ${filteredVenues.length} venues with slug "$targetSlug" for $category');
        print('   (Total venues in response: ${venueResponse.results.length})');
      }

      // Convert to ExploreItemModel
      List<ExploreItemModel> items = [];
      for (var venue in filteredVenues) {
        // Fetch reviews for this venue
        List<ReviewModel> reviews = [];
        double averageRating = 0.0;

        try {
          reviews = await fetchVenueReviews(venue.id);
          if (reviews.isNotEmpty) {
            final totalRating = reviews.fold<double>(
                0.0,
                    (sum, review) => sum + review.rating
            );
            averageRating = totalRating / reviews.length;
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Could not fetch reviews for venue ${venue.id}: $e');
          }
        }

        final item = ExploreItemModel.fromApiResponse(
          venueData: {
            'id': venue.id,
            'venue_name': venue.venueName,
            'profile_picture': venue.profilePicture ?? '',
            'location': venue.location,
            'hours_of_operation': venue.hoursOfOperation,
            'mobile_number': venue.mobileNumber,
            'capacity': venue.capacity,
            'user': {
              'email': venue.user.email,
              'id': venue.user.id,
            }
          },
          category: category,
          reviews: reviews,
          averageRating: averageRating,
          totalReviews: reviews.length,
        );

        items.add(item);
      }

      return items;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching venues for $category: $e');
        print('Stack trace: ${StackTrace.current}');
      }
      return [];
    }
  }

  // Fetch reviews for a specific venue
  Future<List<ReviewModel>> fetchVenueReviews(int venueId) async {
    try {
      final url = AppUrl.getVenueReviewsApiUrl(venueId);

      final response = await _apiService.getApi(url, requireAuth: true);

      if (response == null) {
        return [];
      }

      final reviewsResponse = VenueReviewsResponseModel.fromJson(response);

      if (kDebugMode) {
        print('✅ Found ${reviewsResponse.results.length} reviews for venue $venueId');
      }

      return reviewsResponse.results.map((review) {
        return ReviewModel.fromApiResponse({
          'user': {'email': review.user.email, 'name': review.user.name},
          'rate': {'rate': review.rate.rate},
          'text': review.text,
          'created_at': review.createdAt.toIso8601String(),
          'venue_reply': review.venueReply,
        });
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error fetching reviews for venue $venueId: $e');
      }
      return [];
    }
  }

  // Create a review for a venue
  Future<bool> createReview({
    required int venueId,
    required String reviewText,
    required int rating,
  }) async {
    try {
      final url = AppUrl.createReviewApiUrl(venueId);

      final data = {
        'text': reviewText,
        'rate_value': rating,
      };

      if (kDebugMode) {
        print('📝 Creating review for venue $venueId');
        print('Data: $data');
      }

      final response = await _apiService.postApi(data, url, requireAuth: true);

      if (response != null && (response['success'] == true || response['status_code'] == 201)) {
        if (kDebugMode) {
          print('✅ Review created successfully');
        }
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating review: $e');
      }
      return false;
    }
  }

  // Follow/Unfollow a venue
  Future<bool> toggleFollowVenue(int venueId) async {
    try {
      final url = AppUrl.followVenueApiUrl(venueId);

      if (kDebugMode) {
        print('👥 Toggling follow for venue $venueId');
      }

      final response = await _apiService.postApi({}, url, requireAuth: true);

      if (response != null && (response['success'] == true || response['status_code'] == 200)) {
        if (kDebugMode) {
          print('✅ Follow toggled successfully');
        }
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error toggling follow: $e');
      }
      return false;
    }
  }

  // Favorite/Unfavorite a venue
  Future<bool> toggleFavoriteVenue(int venueId) async {
    try {
      final url = AppUrl.favoriteVenueApiUrl(venueId);

      if (kDebugMode) {
        print('⭐ Toggling favorite for venue $venueId');
      }

      final response = await _apiService.postApi({}, url, requireAuth: true);

      if (response != null && (response['success'] == true || response['status_code'] == 200)) {
        if (kDebugMode) {
          print('✅ Favorite toggled successfully');
        }
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error toggling favorite: $e');
      }
      return false;
    }
  }
}