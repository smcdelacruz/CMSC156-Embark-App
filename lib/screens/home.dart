import 'dart:io';
import 'package:cmsc156_embark_app/models/stray_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'feature_page/feature_page.dart';
import 'search.dart';
import '../widgets/stray_card.dart';
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
    // final data = prefs.getStringList('stray_list') ?? [];
    final activeStrays = await StrayStorage.loadActiveStrays();

    setState(() {
      // strays = data.map((e) => Stray.fromJson(e)).toList();
      strays = activeStrays;
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
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/archive');
                      loadStrays(); // Refresh the list when coming back from the archive
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// SEARCH
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(strays: strays),
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: const Color(0xFFF9DCC4),
                      filled: true,
                      hintText: "Search here...",
                      prefixIcon: const Icon(Icons.search),
                      //suffixIcon: const Icon(Icons.filter_list),
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

                          return StrayCard(
                            stray: stray,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FeaturePage(stray: stray),
                                ),
                              );
                              loadStrays();
                            },
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
