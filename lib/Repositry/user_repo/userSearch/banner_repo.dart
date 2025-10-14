// Repositry/user_repo/userSearch/banner_repo.dart
import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/models/User/userSearch/bannerModel.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import 'package:nikosafe/utils/token_manager.dart';
import 'package:flutter/foundation.dart';

class BannerRepository {
  final _apiService = NetworkApiServices();

  // Fetch all banners from API (WITH AUTH)
  Future<List<Data>> fetchBanners({bool requireAuth = true}) async {
    try {
      // Debug: Check if token exists
      if (requireAuth) {
        final token = await TokenManager.getAccessToken();
        if (kDebugMode) {
          print('🔑 Banner API Token Check:');
          print('Token exists: ${token != null}');
          if (token != null) {
            print('Token preview: ${token.substring(0, 20)}...');
          }
        }
      }

      final response = await _apiService.getApi(
        AppUrl.getAllBannersUrl,
        requireAuth: requireAuth,
      );

      if (kDebugMode) {
        print('✅ Banner API Response received');
      }

      if (response != null) {
        final bannerModel = BannerModel.fromJson(response);

        if (bannerModel.success == true && bannerModel.data != null) {
          if (kDebugMode) {
            print('📊 Total banners: ${bannerModel.data!.length}');
          }

          // Filter only active and approved banners
          final activeBanners = bannerModel.data!
              .where((banner) =>
          banner.isActive == true &&
              banner.isApproved == true)
              .toList();

          if (kDebugMode) {
            print('✅ Active & Approved banners: ${activeBanners.length}');
          }

          return activeBanners;
        }
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching banners: $e');
      }
      rethrow;
    }
  }

  // Fetch only last 5 banners for carousel (WITH AUTH)
  Future<List<Data>> fetchRecentBanners({bool requireAuth = true}) async {
    try {
      final allBanners = await fetchBanners(requireAuth: requireAuth);

      // Return last 5 banners
      if (allBanners.length > 5) {
        final recentBanners = allBanners.sublist(allBanners.length - 5);
        if (kDebugMode) {
          print('🎯 Returning last 5 banners from ${allBanners.length} total');
        }
        return recentBanners;
      }

      if (kDebugMode) {
        print('🎯 Returning all ${allBanners.length} banners (less than 5)');
      }

      return allBanners;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching recent banners: $e');
      }
      rethrow;
    }
  }
}