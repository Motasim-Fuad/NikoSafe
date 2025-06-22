import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userSearch/explore_controller.dart';


class EventFavoriteView extends StatelessWidget {
  const EventFavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final ExploreController controller = Get.put(ExploreController());

    return Obx(() {
      final favorites = controller.favoriteItems;

      if (favorites.isEmpty) {
        return Center(
          child: Text("No favorites added.", style: TextStyle(color: Colors.white)),
        );
      }

      return ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final item = favorites[index];
          return ListTile(
            leading: Image.asset(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
            title: Text(item.title, style: TextStyle(color: Colors.white)),
            subtitle: Text(item.location, style: TextStyle(color: Colors.white70)),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle_outline, color: Colors.redAccent),
              onPressed: () {
                controller.toggleFavorite(item);
              },
            ),
          );
        },
      );
    });
  }
}
