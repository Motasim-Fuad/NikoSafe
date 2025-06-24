import 'package:get/get.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../models/EmargencyContucts.dart';
class EmergencyContactController extends GetxController {
  var contactList = <EmergencyContact>[].obs;

  void addContact(String name, String number) {
    contactList.add(EmergencyContact(name: name, number: number));
  }

  void toggleContact(int index, bool value) {
    contactList[index].isEnabled = value;
    contactList.refresh();
  }

  void editContact(int index, String newName, String newNumber) {
    contactList[index].name = newName;
    contactList[index].number = newNumber;
    contactList.refresh();
  }

  void deleteContact(int index) {
    contactList.removeAt(index);
  }

  void sendSOSAlert() {
    final activeContacts = contactList.where((e) => e.isEnabled).toList();
    if (activeContacts.isEmpty) {
      Utils.errorSnackBar("Alert", "No active emergency contact found.");
      return;
    }

    for (var contact in activeContacts) {
      _sendMessageTo(contact.number);
    }

    Utils.successSnackBar("Success", "Alert sent to ${activeContacts.length} contact(s).");
  }

  void _sendMessageTo(String number) {
    print("SOS alert sent to $number");
  }
}
