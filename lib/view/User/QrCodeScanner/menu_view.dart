import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nikosafe/View_Model/Controller/user/qrCode_controller/menu_controller.dart';
import 'package:nikosafe/models/User/QrCodeScanner/menu_item_model.dart';
import 'package:nikosafe/models/User/QrCodeScanner/order_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';


class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MenuViewController());

    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title:  Text('Menu',style: TextStyle(color: AppColor.primaryTextColor),),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),

          actions: [
            Obx(() => Stack(
              children: [
                IconButton(
                  icon:  Icon(Icons.shopping_cart,color: AppColor.primaryTextColor,),
                  onPressed: () {
                    _showCartBottomSheet(context, controller);
                  },
                ),
                if (controller.totalItemsCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${controller.totalItemsCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            )),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.menuItems.isEmpty) {
            return const Center(child: Text('No menu items available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.groupedMenuItems.length,
            itemBuilder: (context, index) {
              final category = controller.groupedMenuItems.keys.elementAt(index);
              final items = controller.groupedMenuItems[category]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      category,
                      style:  TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryTextColor
                      ),
                    ),
                  ),
                  ...items.map((item) => _buildMenuItem(item, controller)),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item, MenuViewController controller) {
    return Card(
      color: AppColor.cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryTextColor
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.itemDetails,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.secondaryTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (item.discount != '0') ...[
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        '\$${item.discountedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        item.isAvailable
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 16,
                        color: item.isAvailable ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.isAvailable ? 'Available' : 'Unavailable',
                        style: TextStyle(
                          fontSize: 12,
                          color: item.isAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (item.isAvailable)
              ElevatedButton(
                onPressed: () => controller.addToCart(item),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  backgroundColor: AppColor.iconColor
                ),
                child:  Text('Add',style: TextStyle(color: AppColor.primaryTextColor),),
              ),
          ],
        ),
      ),
    );
  }


  void _showCartBottomSheet(BuildContext context, MenuViewController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // 🔹 Keep rounded top
            ),
            child: Column(
              children: [
                 Text(
                  'Your Cart',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColor.primaryTextColor),
                ),
                const Divider(),
                Expanded(
                  child: Obx(() {
                    if (controller.cartItems.isEmpty) {
                      return  Center(child: Text('Cart is empty',style: TextStyle(color: AppColor.secondaryTextColor),));
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: controller.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = controller.cartItems[index];
                        return _buildCartItem(cartItem, controller);
                      },
                    );
                  }),
                ),
                const Divider(),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryTextColor
                      ),
                    ),
                    Text(
                      '\$${controller.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 16),
                RoundButton( width: double.infinity,
                    title: "place order", onPress: (){
                  Get.back();
                  _showTableNumberDialog(context, controller);
                }
                )
              ],
            ),
          );
        },
      ),
    );
  }


  // void _showCartBottomSheet(BuildContext context, MenuViewController controller) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) => DraggableScrollableSheet(
  //       initialChildSize: 0.7,
  //       minChildSize: 0.5,
  //       maxChildSize: 0.95,
  //       expand: false,
  //       builder: (context, scrollController) {
  //         return Container(
  //           padding: const EdgeInsets.all(16),
  //           color: Colors.yellow,
  //           child: Column(
  //             children: [
  //               const Text(
  //                 'Your Cart',
  //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //               ),
  //               const Divider(),
  //               Expanded(
  //                 child: Obx(() {
  //                   if (controller.cartItems.isEmpty) {
  //                     return const Center(child: Text('Cart is empty'));
  //                   }
  //
  //                   return ListView.builder(
  //                     controller: scrollController,
  //                     itemCount: controller.cartItems.length,
  //                     itemBuilder: (context, index) {
  //                       final cartItem = controller.cartItems[index];
  //                       return _buildCartItem(cartItem, controller);
  //                     },
  //                   );
  //                 }),
  //               ),
  //               const Divider(),
  //               Obx(() => Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   const Text(
  //                     'Total:',
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   Text(
  //                     '\$${controller.totalAmount.toStringAsFixed(2)}',
  //                     style: const TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.green,
  //                     ),
  //                   ),
  //                 ],
  //               )),
  //               const SizedBox(height: 16),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     Get.back();
  //                     _showTableNumberDialog(context, controller);
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     padding: const EdgeInsets.symmetric(vertical: 16),
  //                   ),
  //                   child: const Text('Place Order'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildCartItem(CartItem cartItem, MenuViewController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppColor.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: cartItem.menuItem.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.menuItem.itemName,
                    style:  TextStyle(fontWeight: FontWeight.bold,color: AppColor.primaryTextColor),
                  ),
                  Text(
                    '\$${cartItem.menuItem.discountedPrice.toStringAsFixed(2)} x ${cartItem.quantity}',
                    style:  TextStyle(color: AppColor.secondaryTextColor),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon:  Icon(Icons.remove_circle_outline,color: AppColor.secondaryTextColor,),
                  onPressed: () {
                    controller.updateQuantity(
                      cartItem.menuItem.id,
                      cartItem.quantity - 1,
                    );
                  },
                ),
                Text('${cartItem.quantity}',style: TextStyle(color: AppColor.primaryTextColor),),
                IconButton(
                  icon:  Icon(Icons.add_circle_outline,color: AppColor.secondaryTextColor,),
                  onPressed: () {
                    controller.updateQuantity(
                      cartItem.menuItem.id,
                      cartItem.quantity + 1,
                    );
                  },
                ),
              ],
            ),
            Text(
              '\$${cartItem.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTableNumberDialog(BuildContext context, MenuViewController controller) {
    final tableController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.splash,
        title:  Row(
          children: [
            Text('Enter Table Number',style: TextStyle(color: AppColor.primaryTextColor),),


            IconButton(onPressed: (){
              Get.back();
            }, icon: Icon(Icons.cancel_outlined,color: AppColor.secondaryTextColor,))
          ],
        ),
        content:
        TextField(
          controller: tableController,
          style: TextStyle(color: Colors.white),
          decoration:  InputDecoration(
            hintText: 'Table Number',
            hintStyle: TextStyle(color: AppColor.secondaryTextColor),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [

          RoundButton(
            width: double.infinity,
            onPress: () {
              if (tableController.text.isNotEmpty) {
                Get.back();
                controller.placeOrder(tableController.text);
              } else {
                Get.snackbar('Error', 'Please enter table number');
              }
            },
            title: 'Confirm',

          ),
        ],
      ),
    );
  }
}
