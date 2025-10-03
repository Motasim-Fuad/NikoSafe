// view/User/UserHome/CreatePost/widgets/privacy_popup.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/post/createPost/user_create_post_controller.dart';
import 'package:nikosafe/models/User/userHome/privacy_options_model.dart';


class PrivacyPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserCreatePostController>();

    return Obx(() {
      if (controller.isLoadingPrivacy.value) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              SizedBox(width: 10),
              Text('Loading privacy options...', style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      }

      if (controller.privacyOptions.isEmpty) {
        // Fallback to default options if API fails
        return _buildDefaultPrivacyPopup(controller);
      }

      return PopupMenuButton<PrivacyOption>(
        color: Color(0xFF1E2A33),
        onSelected: (PrivacyOption option) {
          controller.selectedPrivacyOption.value = option;
        },
        itemBuilder: (context) => controller.privacyOptions.map((option) {
          return PopupMenuItem<PrivacyOption>(
            value: option,
            child: Row(
              children: [
                Icon(_getIcon(option.name), color: _getIconColor(option.name)),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(option.name, style: TextStyle(color: Colors.white)),
                      if (option.description.isNotEmpty)
                        Text(
                          option.description,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(controller.selectedPrivacyOption.value?.name ?? 'Public'),
              color: _getIconColor(controller.selectedPrivacyOption.value?.name ?? 'Public'),
            ),
            SizedBox(width: 8),
            Text(
              controller.selectedPrivacyOption.value?.name ?? 'Public',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      );
    });
  }

  // Fallback default privacy popup
  Widget _buildDefaultPrivacyPopup(UserCreatePostController controller) {
    final defaultOptions = [
      PrivacyOption(id: 1, name: 'Public', description: 'Anyone can see this post'),
      PrivacyOption(id: 2, name: 'Friends', description: 'Only your friends can see this post'),
      PrivacyOption(id: 3, name: 'Private', description: 'Only you can see this post'),
    ];

    // Set default if not already set
    if (controller.selectedPrivacyOption.value == null) {
      controller.selectedPrivacyOption.value = defaultOptions.first;
    }

    return PopupMenuButton<PrivacyOption>(
      color: Color(0xFF1E2A33),
      onSelected: (PrivacyOption option) {
        controller.selectedPrivacyOption.value = option;
      },
      itemBuilder: (context) => defaultOptions.map((option) {
        return PopupMenuItem<PrivacyOption>(
          value: option,
          child: Row(
            children: [
              Icon(_getIcon(option.name), color: _getIconColor(option.name)),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(option.name, style: TextStyle(color: Colors.white)),
                    Text(
                      option.description,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(controller.selectedPrivacyOption.value?.name ?? 'Public'),
            color: _getIconColor(controller.selectedPrivacyOption.value?.name ?? 'Public'),
          ),
          SizedBox(width: 8),
          Text(
            controller.selectedPrivacyOption.value?.name ?? 'Public',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  IconData _getIcon(String option) {
    switch (option.toLowerCase()) {
      case 'friends':
      case 'connect':
        return Icons.group;
      case 'private':
      case 'only me':
        return Icons.lock;
      case 'public':
      default:
        return Icons.public;
    }
  }

  Color _getIconColor(String option) {
    switch (option.toLowerCase()) {
      case 'friends':
      case 'connect':
        return Colors.blue;
      case 'private':
      case 'only me':
        return Colors.red;
      case 'public':
      default:
        return Colors.green;
    }
  }
}