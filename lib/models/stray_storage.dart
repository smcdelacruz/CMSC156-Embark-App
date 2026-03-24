import 'package:shared_preferences/shared_preferences.dart';
import 'stray.dart';

class StrayStorage {
  static const _key = 'stray_list';

  static Future<void> saveStrays(List<Stray> strays) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = strays.map((s) => s.toJson()).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<Stray>> loadStrays() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((json) => Stray.fromJson(json)).toList();
  }

  static Future<List<Stray>> getStraysByLocation(String location) async {
    final allStrays = await loadStrays();
    return allStrays.where((s) => s.locations.contains(location)).toList();
  }
}
