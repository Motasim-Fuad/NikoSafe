import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'model.dart';

class BacDataRepository {
  final String _key = 'bac_entries';

  Future<void> saveEntry(BacEntryModel entry) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> existing = prefs.getStringList(_key) ?? [];
    existing.add(jsonEncode(entry.toJson()));
    await prefs.setStringList(_key, existing);
  }

  Future<List<BacEntryModel>> getAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => BacEntryModel.fromJson(jsonDecode(e))).toList();
  }
}
