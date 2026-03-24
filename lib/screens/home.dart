import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'feature_page/feature_page.dart';
import 'search.dart';
import '../models/stray_storage.dart';
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
  void initState() {
    super.initState();
    loadStrays();
  }

  // Export current stray list
  Future<void> _exportStrays() async {
    try {
      final file = await StrayStorage.getDatabaseFile();

      if (await file.exists()) {
        // Get device Downloads directory
        final downloadsDir = await getDownloadsDirectory();

        if (downloadsDir == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot access Downloads folder')),
          );
          return;
        }

        // Create a copy of your JSON file in Downloads
        final exportFile = File('${downloadsDir.path}/stray_list.json');
        await file.copy(exportFile.path);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported to ${exportFile.path}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No stray entries to export!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to export: $e')));
    }
  }

  // Import a stray JSON file
  Future<void> _importStrays() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();

      try {
        final List<dynamic> jsonList = jsonDecode(content);
        final strays = jsonList.map((e) => Stray.fromMap(e)).toList();

        await StrayStorage.saveStrays(strays);

        // Reload HomeScreen list
        loadStrays();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imported ${strays.length} entries successfully!'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to import JSON: $e')));
      }
    }
  }

  Future<void> loadStrays() async {
    // final prefs = await SharedPreferences.getInstance();
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

              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _exportStrays,
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Export"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _importStrays,
                    icon: const Icon(Icons.download),
                    label: const Text("Import"),
                  ),
                ],
              ),
              const SizedBox(height: 16),

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
                    : GridView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 cards per row
                              crossAxisSpacing:
                                  12, // horizontal space between cards
                              mainAxisSpacing:
                                  12, // vertical space between rows
                              childAspectRatio:
                                  0.70, // card height relative to width
                            ),
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
