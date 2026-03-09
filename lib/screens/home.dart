import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Embark!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

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

            const Expanded(
              child: Center(
                child: Text(
                  "Placeholder for Stray", //list of added strays will be here
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            // PLACEHOLDER: List of Added Strays
            Expanded(
              child: ListView.builder(
                itemCount: 2, // Generates 5 placeholder cards so you can test scrolling
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
            ),
          ],
        ),
      ),
    );
  }
}
