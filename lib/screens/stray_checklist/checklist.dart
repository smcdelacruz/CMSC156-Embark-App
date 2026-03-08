import 'package:flutter/material.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stray Checklist")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildCard(context, "CAS"),
            buildCard(context, "CFOS"),
            buildCard(context, "CM"),
            buildCard(context, "CUB"),
            buildCard(context, "Dorm Area"),
            buildCard(context, "New Admin"),
            buildCard(context, "Staff House"),
            buildCard(context, "SSF-HSU"),
          ],
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, String title) {
    return Card(
      child: ListTile(
        title: Text(title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlaceholderPage()),
          );
        },
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Placeholder")),
      body: const Center(child: Text("Coming Soon")),
    );
  }
}
