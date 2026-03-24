import 'package:flutter/material.dart';

class ArchiveEntryScreen extends StatefulWidget {
  const ArchiveEntryScreen({super.key});

  @override
  State<ArchiveEntryScreen> createState() => _ArchiveEntryScreenState();
}

class _ArchiveEntryScreenState extends State<ArchiveEntryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Archive Entry")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        // PLACEHOLDER: List of Added Strays
              child: ListView.builder(
                itemCount: 2, 
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // ListTile is a great temporary widget for lists
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFF9DCC4),
                        child: Icon(Icons.pets, color: Colors.black54),
                      ),
                      title: Text(
                        "Stray Buddy #${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text("Spotted near the library..."),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      
                      // Routing to the Feature Page
                      onTap: () {
                        Navigator.pushNamed(context, '/feature');
                      },
                    ),
                  );
                },
              ),
            
    ),);
  }
}