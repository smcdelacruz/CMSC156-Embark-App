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
                      color: isLiked ? Colors.red.shade100 : Colors.white,
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

                        /// CONTENT
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// NAME + AGE
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    pet.name.isEmpty ? "Unnamed" : pet.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    pet.age.isEmpty ? "" : pet.age,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              /// SEX
                              Row(
                                children: [
                                  Icon(
                                    pet.sex.toLowerCase() == "female"
                                        ? Icons.female
                                        : Icons.male,
                                    size: 14,
                                    color: pet.sex.toLowerCase() == "female"
                                        ? Colors.pink
                                        : Colors.blue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    pet.sex.isEmpty ? "Unknown" : pet.sex,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              /// LOCATION
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      pet.locations.isEmpty
                                          ? "No location"
                                          : pet.locations.join(", "),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
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
