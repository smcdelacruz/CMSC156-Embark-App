import 'dart:io';
import 'package:flutter/material.dart';
import '../models/stray.dart';
import '../widgets/stray_card.dart';
import 'feature_page/feature_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  final List<Stray> strays;

  const SearchScreen({super.key, required this.strays});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Stray> filteredStrays = [];
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    filteredStrays = widget.strays;

    loadRecentSearches();

    searchController.addListener(() {
      filterSearch();
    });
  }

  void filterSearch() {
    String query = searchController.text.toLowerCase();

    setState(() {
      filteredStrays = widget.strays.where((stray) {
        final name = stray.name.toLowerCase();
        final nickname = stray.nickname.toLowerCase();

        return name.contains(query) || nickname.contains(query);
      }).toList();
    });

    saveSearch(query);
  }

  Future<void> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> saveSearch(String query) async {
    if (query.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    recentSearches.remove(query); // remove duplicate
    recentSearches.insert(0, query); // add to top

    if (recentSearches.length > 5) {
      recentSearches = recentSearches.sublist(0, 5); // limit to 5
    }

    await prefs.setStringList('recent_searches', recentSearches);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              /// SEARCH BAR
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFF9DCC4),
                  filled: true,
                  hintText: "Search by name or nickname...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.filter_list),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// RESULTS
              Expanded(
                child: filteredStrays.isEmpty
                    ? const Center(
                        child: Text(
                          "No matching results 🐾",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredStrays.length,
                        itemBuilder: (context, index) {
                          final stray = filteredStrays[index];

                          return StrayCard(
                            stray: stray,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FeaturePage(stray: stray),
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
      ),
    );
  }
}
