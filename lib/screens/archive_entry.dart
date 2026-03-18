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
      body: const Center(
        child: Text("This is the Archive Entry Screen"),
      ),
    );
  }
}