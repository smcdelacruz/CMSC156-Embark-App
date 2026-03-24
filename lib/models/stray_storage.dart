// stray_storage.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'stray.dart';

class StrayStorage {
  static const _folderName = 'stray_list';
  static const _fileName = 'strays.json';

  /// 🔹 Step 3: Ensure writable JSON exists
  static Future<File> getDatabaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/$_folderName');

    if (!await folder.exists()) {
      await folder.create(recursive: true); // create folder if missing
    }

    final file = File('${folder.path}/$_fileName');

    // If file doesn't exist, copy default from assets
    if (!await file.exists()) {
      final jsonString = await rootBundle.loadString(
        'lib/stray_list/strays.json',
      );
      await file.writeAsString(jsonString);
    }

    return file;
  }

  /// Load all strays
  static Future<List<Stray>> loadStrays() async {
    final file = await getDatabaseFile();
    final content = await file.readAsString();
    final List<dynamic> jsonList = content.isEmpty ? [] : jsonDecode(content);
    return jsonList.map((e) => Stray.fromMap(e)).toList();
  }

  /// Save all strays
  static Future<void> saveStrays(List<Stray> strays) async {
    final file = await getDatabaseFile();
    final jsonList = strays.map((s) => s.toMap()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  /// Add a new stray
  static Future<void> addStray(Stray stray) async {
    final strays = await loadStrays();
    strays.add(stray);
    await saveStrays(strays);
  }

  /// Update an existing stray by id
  static Future<void> updateStray(Stray updatedStray) async {
    final strays = await loadStrays();
    final index = strays.indexWhere((s) => s.id == updatedStray.id);
    if (index != -1) {
      strays[index] = updatedStray;
      await saveStrays(strays);
    }
  }

  /// Delete a stray by id
  static Future<void> deleteStray(String id) async {
    final strays = await loadStrays();
    strays.removeWhere((s) => s.id == id);
    await saveStrays(strays);
  }

  /// Get only active (non-archived) strays
  static Future<List<Stray>> loadActiveStrays() async {
    final strays = await loadStrays();
    return strays.where((s) => !s.isArchived).toList();
  }

  /// Get only archived strays
  static Future<List<Stray>> loadArchivedStrays() async {
    final strays = await loadStrays();
    return strays.where((s) => s.isArchived).toList();
  }

  /// Filter by location
  static Future<List<Stray>> getStraysByLocation(String location) async {
    final strays = await loadStrays();
    return strays.where((s) => s.locations.contains(location)).toList();
  }
}
