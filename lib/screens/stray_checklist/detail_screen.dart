import 'dart:io';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  void loadPets() async {
    final list = await StrayStorage.getStraysByLocation(widget.title);
    setState(() => pets = list);
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
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return ListTile(
                  leading: pet.imagePath.isNotEmpty
                      ? Image.file(
                          File(pet.imagePath),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.pets, size: 50),
                  title: Text(pet.name),
                  subtitle: Text("Age: ${pet.age}, Sex: ${pet.sex}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FeaturePage(stray: pet),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
