import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/qrCode_repo/menu_repo.dart';
import 'package:nikosafe/models/User/QrCodeScanner/menu_item_model.dart';
import 'package:nikosafe/models/User/QrCodeScanner/order_model.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';


class MenuViewController extends GetxController {
  final _repository = MenuRepository();

  final isLoading = false.obs;
  final menuItems = <MenuItem>[].obs;
  final cartItems = <CartItem>[].obs;
  final venueId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Get venue ID from arguments
    if (Get.arguments != null && Get.arguments['venueId'] != null) {
      venueId.value = Get.arguments['venueId'];
      fetchMenuItems();
    }
  }

  // Fetch menu items
  Future<void> fetchMenuItems() async {
    try {
      isLoading.value = true;
      final response = await _repository.getMenuItems(venueId.value);

      if (response.success) {
        menuItems.value = response.data;
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load menu: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Group items by category
  Map<String, List<MenuItem>> get groupedMenuItems {
    Map<String, List<MenuItem>> grouped = {};
    for (var item in menuItems) {
      if (!grouped.containsKey(item.category.name)) {
        grouped[item.category.name] = [];
      }
      grouped[item.category.name]!.add(item);
    }
    return grouped;
  }

  // Add to cart
  void addToCart(MenuItem item) {
    final existingIndex = cartItems.indexWhere(
          (cartItem) => cartItem.menuItem.id == item.id,
    );

    if (existingIndex != -1) {
      cartItems[existingIndex].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(menuItem: item));
    }
    Get.snackbar('Success', '${item.itemName} added to cart');
  }

  // Remove from cart
  void removeFromCart(int itemId) {
    cartItems.removeWhere((cartItem) => cartItem.menuItem.id == itemId);
  }

  // Update quantity
  void updateQuantity(int itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
      return;
    }

    final index = cartItems.indexWhere(
          (cartItem) => cartItem.menuItem.id == itemId,
    );

    if (index != -1) {
      cartItems[index].quantity = quantity;
      cartItems.refresh();
    }
  }

  // Calculate total
  double get totalAmount {
    return cartItems.fold(
      0.0,
          (sum, item) => sum + item.totalPrice,
    );
  }

  // Get total items count
  int get totalItemsCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Place order
  Future<void> placeOrder(String tableNumber) async {
    if (cartItems.isEmpty) {
      Get.snackbar('Error', 'Cart is empty');
      return;
    }

    try {
      isLoading.value = true;

      final items = cartItems.map((cartItem) {
        return {
          'menu_item': cartItem.menuItem.id,
          'quantity': cartItem.quantity,
          'price': cartItem.menuItem.discountedPrice.toStringAsFixed(2),
        };
      }).toList();

      final response = await _repository.createOrder(
        venueId: venueId.value,
        tableNumber: tableNumber,
        items: items,
      );

      if (response.success) {
        Get.snackbar(
          'Success',
          'Order placed successfully! Order ID: ${response.data.orderId}',
          duration: const Duration(seconds: 3),
        );

        // Clear cart
        cartItems.clear();

        // Navigate to home after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(RouteName.userBottomNavView); // Replace with your home route
        });
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order: $e');
    } finally {
      isLoading.value = false;
    }
  }
}