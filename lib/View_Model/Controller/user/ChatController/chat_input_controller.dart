import 'dart:io';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputController extends GetxController {
  final Rx<File?> selectedMedia = Rx<File?>(null);
  final RxnString selectedLocation = RxnString(); // allow null
  final RxBool showEmojiPicker = false.obs;
  final RxBool isAttachmentMenuOpen = false.obs; // Tracks if menu is open

  final ImagePicker _picker = ImagePicker();

  Future<void> pickMedia() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedMedia.value = File(picked.path);
    }
  }

  Future<void> shareLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    selectedLocation.value =
    'https://maps.google.com/?q=${position.latitude},${position.longitude}';
  }

  void toggleAttachmentMenu() {
    isAttachmentMenuOpen.toggle();
  }
  void toggleEmojiPicker() {
    showEmojiPicker.toggle();
  }

  void clear() {
    selectedMedia.value = null;
    selectedLocation.value = null;
    showEmojiPicker.value = false;
    isAttachmentMenuOpen.value = false;
  }
}
