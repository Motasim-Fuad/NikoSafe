import 'package:get/get.dart';
import '../../../models/EmargencyContucts.dart';


class EmergencyContactController extends GetxController {
  var contactList = <EmergencyContact>[].obs;

  void addContact(String number) {
    contactList.add(EmergencyContact(number: number));
  }

  void toggleContact(int index, bool value) {
    contactList[index].isEnabled = value;
    contactList.refresh(); // Required to update UI
  }

  void sendSOSAlert() {
    final activeContacts = contactList.where((e) => e.isEnabled).toList();
    if (activeContacts.isEmpty) {
      Get.snackbar("Alert", "No active emergency contact found.");
      return;
    }

    for (var contact in activeContacts) {
      _sendMessageTo(contact.number);
    }

    Get.snackbar("Success", "Alert sent to ${activeContacts.length} contact(s).");
  }

  void _sendMessageTo(String number) {
    // 👇 Replace with real SMS/API later
    print("SOS alert sent to $number");
  }
}



//
// In emergency_contact_controller.dart, replace:
//
// dart
// Copy
// Edit
// void _sendMessageTo(String number) {
//   print("SOS alert sent to $number");
// }
// With:
//
// dart
// Copy
// Edit
// void _sendMessageTo(String number) async {
//   try {
//     final response = await NetworkApiServices().postApi({
//       "phone": number,
//       "message": "SOS! Please help me."
//     }, "your/api/endpoint");
//     print("API success: $response");
//   } catch (e) {
//     print("API error: $e");
//   }
// }