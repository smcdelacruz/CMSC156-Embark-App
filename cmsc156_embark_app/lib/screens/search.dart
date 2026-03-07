import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SEARCH BAR
              TextField(
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

              const SizedBox(height: 20),

              // Placeholder for search results
              const Expanded(
                child: Center(
                  child: Text(
                    "Search Results Will Appear Here",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
