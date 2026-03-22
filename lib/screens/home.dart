import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'feature_page/feature_page.dart';
import '../models/stray.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Stray> strays = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadStrays();
  }

  Future<void> loadStrays() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('stray_list') ?? [];

    setState(() {
      strays = data.map((e) => Stray.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Embark!",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.archive_rounded,
                      color: Colors.black54,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/archive');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// SEARCH
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: const Color(0xFFF9DCC4),
                      filled: true,
                      hintText: "Search here...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.filter_list),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// LIST
              Expanded(
                child: strays.isEmpty
                    ? const Center(
                        child: Text(
                          "No entries yet 🐾\nAdd your first stray!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: strays.length,
                        itemBuilder: (context, index) {
                          final stray = strays[index];

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),

                              /// IMAGE
                              leading: CircleAvatar(
                                radius: 26,
                                backgroundColor: const Color(0xFFF9DCC4),
                                backgroundImage: stray.imagePath.isNotEmpty
                                    ? FileImage(File(stray.imagePath))
                                    : null,
                                child: stray.imagePath.isEmpty
                                    ? const Icon(
                                        Icons.pets,
                                        color: Colors.black54,
                                      )
                                    : null,
                              ),

                              /// NAME
                              title: Text(
                                stray.name.isEmpty ? "Unnamed" : stray.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              /// LOCATION
                              subtitle: Text(
                                stray.locations.isEmpty
                                    ? "No location"
                                    : stray.locations.join(", "),
                              ),

                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),

                              /// NAVIGATION
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FeaturePage(stray: stray),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
