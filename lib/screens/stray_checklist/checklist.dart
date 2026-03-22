import 'package:flutter/material.dart';
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
    "CAS",
    "CFOS",
    "CM",
    "CUB",
    "Dorms",
    "New Admin",
    "Staff House",
    "SSF-HSU",
  ];

  Map<String, List<Stray>> locationStrays = {};

  @override
  void initState() {
    super.initState();
    loadStrays();
  }

  void loadStrays() async {
    final allStrays = await StrayStorage.loadStrays();
    final map = <String, List<Stray>>{};
    for (var loc in locations) {
      map[loc] = allStrays.where((s) => s.locations.contains(loc)).toList();
    }
    setState(() {
      locationStrays = map;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${locationStrays.values.where((l) => l.isNotEmpty).length}/${locations.length}",
                    style: const TextStyle(color: Colors.white),
                  ),
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
                  return ChecklistCard(
                    title: loc,
                    completed: strays.length, // all pets found
                    total: strays.length > 0 ? strays.length : 1, // avoid 0/0
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(title: loc),
                        ),
                      );
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
