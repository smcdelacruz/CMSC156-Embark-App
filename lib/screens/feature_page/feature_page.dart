/* This is the Feature Page that shows all the details of a specific pet entry. 
** It includes a large background image, pet details, and an "Edit" and "Archive" options.
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/temp_stray_form.dart';
import '../../models/stray.dart';
import '../../models/stray_storage.dart';
import '../../widgets/feature_menu_dropdown.dart';
import '../../widgets/feature_page_stats.dart';

class FeaturePage extends StatefulWidget {
  final Stray stray;
  final bool
  isArchivedView; // New parameter to indicate if this page is being viewed from the Archive

  const FeaturePage({
    super.key,
    required this.stray,
    this.isArchivedView = false,
  }); // Default to false for the Home page

  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadLikeState();
  }

  Future<void> _loadLikeState() async {
    final prefs = await SharedPreferences.getInstance();
    final likedList = prefs.getStringList('liked_strays') ?? [];
    setState(() {
      isLiked = likedList.contains(widget.stray.id);
    });
  }

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
            child: FeatureMenuDropdown(
              isArchived: widget.isArchivedView,

              onEdit: () {
                // 1️⃣ Convert Stray to StrayForm
                final form = StrayForm()
                  ..id = widget.stray.id
                  ..name = widget.stray.name
                  ..age = widget.stray.age
                  ..sex = widget.stray.sex
                  ..nickname = widget.stray.nickname
                  ..locations = widget.stray.locations
                  ..imagePath = widget.stray.imagePath
                  ..temperament = widget.stray.temperament
                  ..deworming = widget.stray.deworming
                  ..vaccination = widget.stray.vaccination;

                // 2️⃣ Navigate to EditEntryStep1
                Navigator.pushNamed(
                  context,
                  '/edit', // matches main.dart route
                  arguments: form,
                );
              },

              onArchive: () {
                // Pass the current stray to the dialog
                showArchiveDialog(context, widget.stray);
              },

              onUnarchive: () async {
                // Rebuild the object with isArchived = false
                final activeStray = Stray(
                  id: widget.stray.id,
                  name: widget.stray.name,
                  age: widget.stray.age,
                  sex: widget.stray.sex,
                  nickname: widget.stray.nickname,
                  locations: widget.stray.locations,
                  imagePath: widget.stray.imagePath,
                  temperament: widget.stray.temperament,
                  deworming: widget.stray.deworming,
                  vaccination: widget.stray.vaccination,
                  isArchived: false,
                );

                await StrayStorage.updateStray(activeStray);

                if (context.mounted) {
                  Navigator.pop(context); // Go back to Archive Screen
                }
              },

              onDelete: () {
                showDeleteDialog(context, widget.stray);
                debugPrint("Delete forever clicked");
              },
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
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: LikeButton(
                  padding: EdgeInsets.zero,
                  mainAxisAlignment: MainAxisAlignment.center,
                  likeCountPadding: EdgeInsets.zero,
                  bubblesColor: const BubblesColor(
                    dotPrimaryColor: Color(0xFFF8EDEB),
                    dotSecondaryColor: Colors.red,
                  ),
                  size: 34,

                  // === ISLIKED LOGIC ===
                  isLiked: isLiked,
                  onTap: (bool currentLiked) async {
                    final prefs = await SharedPreferences.getInstance();
                    final liked = prefs.getStringList('liked_strays') ?? [];

                    setState(() {
                      if (currentLiked) {
                        liked.remove(widget.stray.id);
                        isLiked = false;
                      } else {
                        liked.add(widget.stray.id);
                        isLiked = true;
                      }
                    });

                    await prefs.setStringList('liked_strays', liked);
                    return !currentLiked;
                  },

                  // === UI LOGIC ===
                  likeBuilder: (isLiked) {
                    return SizedBox(
                      width: 34,
                      height: 34,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Center(
                            child: Icon(
                              isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border_rounded,
                              color: const Color(0xFFF8EDEB),
                              size: 34,
                            ),
                          ),
                          // The "+" badge
                          if (!isLiked)
                            Positioned(
                              bottom: -1,
                              right: -1,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF08080),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(3),
                                child: const Text(
                                  "+",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFF8EDEB),
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // ),
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

/// ARCHIVE DIALOG
void showArchiveDialog(BuildContext context, Stray stray) {
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

        ///
        TextButton(
          onPressed: () async {
            Navigator.pop(context); // Close the dialog

            // Set the stray to archived
            final archivedStray = Stray(
              id: stray.id,
              name: stray.name,
              age: stray.age,
              sex: stray.sex,
              nickname: stray.nickname,
              locations: stray.locations,
              imagePath: stray.imagePath,
              temperament: stray.temperament,
              deworming: stray.deworming,
              vaccination: stray.vaccination,
              isArchived: true,
            );

            // Save it to database
            await StrayStorage.updateStray(archivedStray);

            // Pop the FeaturePage so the user returns to the Home list
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text("Archive", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

/// DELETE DIALOG
/// Dialog for permanently deleting a stray
void showDeleteDialog(BuildContext parentContext, Stray stray) {
  showDialog(
    context: parentContext,
    builder: (dialogContext) => AlertDialog(
      title: const Text("Delete Forever", style: TextStyle(color: Colors.red)),
      content: const Text(
        "Are you sure you want to permanently delete this entry? This action cannot be undone.",
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(dialogContext), // Close just the dialog
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            // 1. Close the dialog
            Navigator.pop(dialogContext);

            // 2. Delete the stray from the database entirely
            await StrayStorage.deleteStray(stray.id);

            // 3. Pop the FeaturePage to return to the Archive list
            if (parentContext.mounted) {
              Navigator.pop(parentContext);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red.withValues(
              alpha: 0.1,
            ), // light red background
          ),
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
