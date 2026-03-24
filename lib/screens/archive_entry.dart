import 'package:flutter/material.dart';
import '../../models/stray.dart';
import '../../models/stray_storage.dart';
import '../../widgets/stray_card.dart';
import 'feature_page/feature_page.dart';

/// This screen displays all archived stray entries in a list format. 
/// It retrieves the archived strays from StrayStorage and shows them using StrayCard widgets. 
/// Tapping on an archived entry navigates to the FeaturePage with the isArchivedView flag set to true, 
/// allowing users to view details and unarchive if desired.
class ArchiveEntryScreen extends StatefulWidget {
  const ArchiveEntryScreen({super.key});

  @override
  State<ArchiveEntryScreen> createState() => _ArchiveEntryScreenState();
}

class _ArchiveEntryScreenState extends State<ArchiveEntryScreen> {
  List<Stray> archivedStrays = []; // State variable to hold archived strays

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadArchivedStrays(); // Load archived strays when the screen is first displayed
  }

  Future<void> _loadArchivedStrays() async {
    final strays = await StrayStorage.loadArchivedStrays();
    setState(() {
      archivedStrays = strays;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Archive Entry"),
        backgroundColor: Colors.white,
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          
          // Checks if the list is empty first
          child: archivedStrays.isEmpty
              ? const Center(
                  child: Text(
                    "No archived entries.",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                )
                
                // 2 Cards per row will show if there are archived entries
              : GridView.builder(
                  padding: const EdgeInsets.only(bottom: 20), 
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 cards per row
                    crossAxisSpacing: 12, // horizontal space between cards
                    mainAxisSpacing: 12, // vertical space between rows
                    childAspectRatio: 0.70, // card height
                  ),
                  itemCount: archivedStrays.length, 
                  itemBuilder: (context, index) {
                    final stray = archivedStrays[index];

                    return StrayCard(
                      stray: stray,
                      
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FeaturePage(
                              stray: stray,
                              isArchivedView: true, 
                            ),
                          ),
                        );
                        
                        // Reload archived strays when coming back from the feature page in case of any changes
                        _loadArchivedStrays();
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}