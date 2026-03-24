import 'package:shared_preferences/shared_preferences.dart';
import 'stray.dart';

class StrayStorage {
  static const _key = 'stray_list';

  /// Saves the list of strays to SharedPreferences
  static Future<void> saveStrays(List<Stray> strays) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = strays.map((s) => s.toJson()).toList();
    await prefs.setStringList(_key, jsonList);
  }

  /// Loads the list of strays from SharedPreferences
  static Future<List<Stray>> loadStrays() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((json) => Stray.fromJson(json)).toList();
  }

  /// Retrieves all strays that have a specific location in their list of locations
  static Future<List<Stray>> getStraysByLocation(String location) async {
    final allStrays = await loadStrays();
    return allStrays.where((s) => s.locations.contains(location)).toList();
  }

  /// Retrieves all strays that are NOT ARCHIVED for HOME SCREEN display
  static Future<List<Stray>> loadActiveStrays() async {
    final allStrays = await loadStrays();
    return allStrays.where((s) => !s.isArchived).toList();
  }

  /// Retrieves all strays that are ARCHIVED for ARCHIVE SCREEN display
  static Future<List<Stray>> loadArchivedStrays() async {
    final allStrays = await loadStrays();
    return allStrays.where((s) => s.isArchived).toList();
  }

  /// Updates a specific stray in the list and saves it back to SharedPreferences 
  /// by matching the stray's id. for Archiving/Unarchiving.
  static Future<void> updateStray(Stray updatedStray) async {
    List<Stray> allStrays = await loadStrays();
    final index = allStrays.indexWhere((s) => s.id == updatedStray.id);

    if (index != -1) {
      allStrays[index] = updatedStray;
      await saveStrays(allStrays);
    }
  }
  
  /// Permanently deletes a stray from the list by matching the id and 
  /// saves the updated list back to SharedPreferences.
  static Future<void> deleteStray(String id) async {
    List<Stray> allStrays = await loadStrays();
    allStrays.removeWhere((s) => s.id == id);     // Remove the stray with the matching id
    
    await saveStrays(allStrays);
  }
}
