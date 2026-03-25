import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/stray.dart';
import '../../models/stray_storage.dart';
import 'checklist_card.dart';
import 'detail_screen.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final locations = [
    "Box 1",
    "CAS",
    "CFOS",
    "CDH",
    "CM",
    "CUB",
    "Dorms",
    "Dorm Area",
    "Hatchery",
    "New Admin",
    "OWL",
    "Sotech",
    "Staff House",
    "Teacher's Dorm",
    "SSF-HSU",
    "Wetlab",
  ];

  Map<String, List<Stray>> locationStrays = {};
  List<String> likedStrays = []; // IDs of found/liked strays
  List<Stray> allStraysList = [];

  @override
  void initState() {
    super.initState();
    loadStrays();
  }

  Future<void> loadStrays() async {
    final allStrays = await StrayStorage.loadStrays();
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList('liked_strays') ?? [];

    final map = <String, List<Stray>>{};
    for (var loc in locations) {
      map[loc] = allStrays.where((s) => s.locations.contains(loc)).toList();
    }

    setState(() {
      allStraysList = allStrays;
      likedStrays = liked;
      locationStrays = map;
    });
  }

  /// Refresh liked strays when coming back from FeaturePage
  Future<void> refreshLikes() async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList('liked_strays') ?? [];
    setState(() {
      likedStrays = liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Total liked / total strays
    final totalLiked = likedStrays.length;
    final totalStrays = allStraysList.isEmpty ? 1 : allStraysList.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F5),
        title: const Text(
          "Stray Checklist",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Areas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: locations.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final loc = locations[index];
                  final strays = locationStrays[loc] ?? [];

                  // Count how many strays in this location are liked/found
                  final foundCount = strays
                      .where((s) => likedStrays.contains(s.id))
                      .length;

                  return ChecklistCard(
                    title: loc,
                    completed: foundCount,
                    total: strays.isEmpty ? 1 : strays.length,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(title: loc),
                        ),
                      );
                      // Refresh likes after returning
                      await refreshLikes();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
