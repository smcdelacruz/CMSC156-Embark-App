import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/stray.dart';
import '../feature_page/feature_page.dart';
import '../../models/stray_storage.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  const DetailScreen({super.key, required this.title});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<Stray> pets = [];
  List<String> likedStrays = [];

  @override
  void initState() {
    super.initState();
    loadPets();
    loadLikes();
  }

  void loadPets() async {
    final list = await StrayStorage.getStraysByLocation(widget.title);
    setState(() => pets = list);
  }

  void loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList('liked_strays') ?? [];
    setState(() => likedStrays = liked);
  }

  Future<void> refreshLikes() async {
    final prefs = await SharedPreferences.getInstance();
    final liked = prefs.getStringList('liked_strays') ?? [];
    setState(() => likedStrays = liked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
      ),
      body: pets.isEmpty
          ? const Center(child: Text("No pets in this location"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                final isLiked = likedStrays.contains(pet.id);

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FeaturePage(stray: pet),
                      ),
                    );
                    await refreshLikes();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB5A7), // Salmon card
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// IMAGE
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: pet.imagePath.isNotEmpty
                                ? Image.file(
                                    File(pet.imagePath),
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.pets,
                                      size: 30,
                                      color: Colors.black54,
                                    ),
                                  ),
                          ),
                        ),

                        /// NAME + LIKE
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pet.name.isEmpty ? "Unnamed" : pet.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.favorite,
                                color: isLiked
                                    ? const Color(0xFFF9DCC4)
                                    : Colors.grey,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
