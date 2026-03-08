// lib/widgets/feature_page_widgets.dart
/*
 * This file contains reusable widgets for the Feature Page, 
 * such as the stats boxes and medical information boxes.
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Nickname, Age, Location stats widget
class FeaturePageStats extends StatelessWidget {
  final String title;
  final String value;

  const FeaturePageStats({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDFB6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Medical boxes widget (Deworming, Vaccination)
class MedicalBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> bulletPoints;

  const MedicalBox({
    super.key,
    required this.title,
    required this.icon,
    required this.bulletPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCDB2), 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon, 
                color: const Color(0xFFF08080), 
                size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Maps the list of strings to the BulletPoint widget
          ...bulletPoints.map((text) => BulletPoint(text: text)),
        ],
      ),
    );
  }
}

/// Bullet point widget to display each item in the medical information 
class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "• ", 
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13, 
                color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the Archive/Remove confirmation dialog
void showArchiveDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Archive Post?"),
        content: const Text("Are you sure you want to archive this post?"),
        
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // To add delete/archive logic
            },
            child: const Text("Archive", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}