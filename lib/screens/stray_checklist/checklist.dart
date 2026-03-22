import 'package:flutter/material.dart';
import 'checklist_card.dart';
import 'detail_screen.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locations = [
      //placeholder values
      {"name": "CAS", "completed": 1, "total": 1},
      {"name": "CFOS", "completed": 1, "total": 1},
      {"name": "CM", "completed": 0, "total": 1},
      {"name": "CUB", "completed": 1, "total": 1},
      {"name": "Dorms", "completed": 0, "total": 2},
      {"name": "New Admin", "completed": 1, "total": 1},
      {"name": "Staff House", "completed": 0, "total": 1},
      {"name": "SSF-HSU", "completed": 1, "total": 1},
    ];

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
            // Header
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
                  child: const Text(
                    "1/10",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Grid
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
                  final item = locations[index];

                  return ChecklistCard(
                    title: item["name"] as String,
                    completed: item["completed"] as int,
                    total: item["total"] as int,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailScreen(title: item["name"] as String),
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
