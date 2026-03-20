import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // APP TITLE + ARCHIVE BUTTON
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
                      color: Color.fromARGB(156, 0, 0, 0),
                      size: 32,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/archive');
                    },
                    tooltip: "Archive",
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // SEARCH FIELD
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

              // STRAY LIST
              Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
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
      ),
    );
  }
}
