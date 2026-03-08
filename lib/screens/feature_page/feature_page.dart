/* This is the Feature Page that shows all the details of a specific pet entry. 
* It includes a large background image, pet details, and an "Edit" and "Archive" options.
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/feature_page_stats.dart';

class FeaturePage extends StatelessWidget {
  const FeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // === BACKGROUND IMAGE ===
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.45,
            child: Image.network(
              'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=1000&auto=format&fit=crop', 
              fit: BoxFit.cover,
            ),
          ),

          // === BACK BUTTON (Top Left) ===
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: CircleAvatar(
              backgroundColor: const Color(0xFFF9DCC4),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new, 
                  color: Colors.black, 
                  size: 20),

                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // === MENU DROPDOWN (Top Right) ===
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: CircleAvatar(

              backgroundColor: const Color(0xFFF9DCC4),
              child: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_horiz, 
                  color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),

                onSelected: (String choice) {
                  if (choice == 'Edit') {
                    Navigator.pushNamed(context, '/edit');

                  } else if (choice == 'Archive') {
                    showArchiveDialog(context); 
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined, 
                            color: Colors.black54
                          ),

                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Archive',
                      child: Row(
                        children: [
                          Icon(
                            Icons.archive_outlined, 
                            color: Colors.red
                          ),

                          SizedBox(width: 8),
                          Text('Archive', 
                            style: TextStyle(color: Colors.red)
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ),
          ),

          // === SCROLLABLE CONTENT (White Container) ===
          Positioned.fill(
            top: size.height * 0.40,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 30, 
                  left: 24, 
                  right: 24, 
                  bottom: 40
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NAME
                    Text(
                      "Butterscotch",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // LOCATION
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined, 
                          color: Color(0xFFF08080), 
                          size: 20
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            "SOTECH, Dorm Area, CUB, CAS, Box 1, CFOS",
                            style: GoogleFonts.poppins(
                              color: Colors.black87, 
                              fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Divider(
                        color: Colors.black12, 
                        thickness: 1
                      ),
                    ),

                    // === 3-COLUMN STATS GRID ===
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FeaturePageStats(title: "Nickname(s)", value: "Tiger, Hyena"),
                        SizedBox(width: 12),
                        FeaturePageStats(title: "Age", value: "~5 years old"),
                        SizedBox(width: 12),
                        FeaturePageStats(title: "Sex", value: "Female"),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // TEMPERAMENT BLOCK
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCDB2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.pets, 
                                color: Color(0xFFC94545), 
                                size: 19
                              ),

                              const SizedBox(width: 8),
                              Text(
                                "Temperament & Personality",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          const BulletPoint(text: "Likes people"),
                          const BulletPoint(text: "Like scratches"),
                          const BulletPoint(text: "Approachable but can be too playful"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // MEDICAL BLOCKS (Side by Side)
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: MedicalBox(
                            title: "Deworming",
                            icon: Icons.favorite_border,
                            bulletPoints: ["November 2022", "Simparica Trio\n(February 1, 2025)"],
                          ),
                        ),
                        SizedBox(width: 16),

                        Expanded(
                          child: MedicalBox(
                            title: "Vaccination",
                            icon: Icons.health_and_safety_outlined,
                            bulletPoints: ["September 20, 2023"],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // === FLOATING HEART BUTTON ===
          Positioned(
            top: size.height * 0.40 - 28, 
            right: 30,
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF08080),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white, size: 28),
                onPressed: () {
                  // To add the like (heart) logic
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}