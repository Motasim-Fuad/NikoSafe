

import 'package:nikosafe/models/User/QrCodeScanner/menu_item_model.dart';
import 'package:nikosafe/models/User/QrCodeScanner/order_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

import '../../../data/network/network_api_services.dart';

class MenuRepository {
  final _apiService = NetworkApiServices();

  Future<MenuItemResponse> getMenuItems(int venueId) async {
    try {
      final response = await _apiService.getApi(
        '${AppUrl.base_url}/api/hospitality/venues/$venueId/menu-items/',
        requireAuth: true,
      );
      return MenuItemResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderResponse> createOrder({
    required int venueId,
    required String tableNumber,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final data = {
        'hospitality_venue': venueId,
        'table_number': tableNumber,
        'items': items,
      };

      final response = await _apiService.postApi(
        data,
        '${AppUrl.base_url}/api/hospitality/orders/create/',
        requireAuth: true,
      );

      return OrderResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}