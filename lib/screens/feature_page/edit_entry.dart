import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditEntryPage extends StatelessWidget {
  const EditEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Stray Details'),
      ),
      body: Center(
        child: Text(
          'This is the Edit Entry Page',
          style: GoogleFonts.poppins(fontSize: 24),
        ),
      ),
    );
  }
}