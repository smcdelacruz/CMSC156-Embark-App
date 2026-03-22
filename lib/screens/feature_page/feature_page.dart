/* This is the Feature Page that shows all the details of a specific pet entry. 
* It includes a large background image, pet details, and an "Edit" and "Archive" options.
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import '../../models/stray.dart';
import '../../widgets/feature_page_stats.dart';

class FeaturePage extends StatefulWidget {
  final Stray stray;

  const FeaturePage({super.key, required this.stray});

  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// === IMAGE ===
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.45,
            child: widget.stray.imagePath.isNotEmpty
                ? Image.file(File(widget.stray.imagePath), fit: BoxFit.cover)
                : Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.pets, size: 80),
                  ),
          ),

          /// === BACK BUTTON ===
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: CircleAvatar(
              backgroundColor: const Color(0xFFF9DCC4),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          /// === MENU ===
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: CircleAvatar(
              backgroundColor: const Color(0xFFF9DCC4),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onSelected: (choice) {
                  if (choice == 'Edit') {
                    // TODO: implement edit
                  } else if (choice == 'Archive') {
                    showArchiveDialog(context);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Archive',
                    child: Row(
                      children: [
                        Icon(Icons.archive_outlined, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Archive', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// === CONTENT ===
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
                  bottom: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// NAME
                    Text(
                      widget.stray.name,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// LOCATION
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFFF08080),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.stray.locations.join(", "),
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    const Divider(),

                    /// STATS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FeaturePageStats(
                          title: "Nickname(s)",
                          value: widget.stray.nickname.isEmpty
                              ? "-"
                              : widget.stray.nickname,
                        ),
                        SizedBox(width: 12),
                        FeaturePageStats(
                          title: "Age",
                          value: widget.stray.age.isEmpty
                              ? "-"
                              : widget.stray.age,
                        ),
                        SizedBox(width: 12),
                        FeaturePageStats(
                          title: "Sex",
                          value: widget.stray.sex.isEmpty
                              ? "-"
                              : widget.stray.sex,
                        ),
                        SizedBox(width: 12),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// TEMPERAMENT
                    _infoBox(
                      title: "Temperament & Personality",
                      icon: Icons.pets,
                      content: widget.stray.temperament,
                    ),

                    const SizedBox(height: 16),

                    /// MEDICAL
                    Row(
                      children: [
                        Expanded(
                          child: _infoBox(
                            title: "Deworming",
                            icon: Icons.favorite_border,
                            content: widget.stray.deworming,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _infoBox(
                            title: "Vaccination",
                            icon: Icons.health_and_safety_outlined,
                            content: widget.stray.vaccination,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// === HEART BUTTON ===
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
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: LikeButton(
                size: 34,
                likeBuilder: (isLiked) {
                  return Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 Reusable Info Box
  Widget _infoBox({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCDB2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content.isEmpty ? "-" : content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// OPTIONAL (keep your existing one if you already have it)
void showArchiveDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Archive Entry"),
      content: const Text("Are you sure you want to archive this entry?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // TODO: archive logic
          },
          child: const Text("Archive", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
