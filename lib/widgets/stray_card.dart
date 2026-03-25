import 'dart:io';
import 'package:flutter/material.dart';
import '../models/stray.dart';
import '../widgets/stray_image.dart';

class StrayCard extends StatelessWidget {
  final Stray stray;
  final VoidCallback onTap;

  const StrayCard({super.key, required this.stray, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFB5A7),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE (TOP)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              // child: Container(
              //   height: 230,
              //   width: double.infinity,
              //   color: Colors.grey[300],
              //   child: stray.imagePath.isNotEmpty
              //       ? Image.file(File(stray.imagePath), fit: BoxFit.cover)
              //       : const Center(
              //           child: Icon(
              //             Icons.pets,
              //             size: 30,
              //             color: Colors.black54,
              //           ),
              //         ),
              // ),

              // StrayImage handles the placeholder and the Base64 decoding automatically
              child: StrayImage(
                imagePath: stray.imagePath,
                height: 230,
                width: double.infinity,
              ),
            ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME + AGE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stray.name.isEmpty ? "Unnamed" : stray.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        stray.age.isEmpty ? "" : "~${stray.age} years",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  /// SEX
                  Row(
                    children: [
                      Icon(
                        stray.sex.toLowerCase() == "male"
                            ? Icons.male
                            : stray.sex.toLowerCase() == "female"
                            ? Icons.female
                            : Icons.help_outline,
                        size: 20,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        stray.sex.isEmpty ? "Unknown" : stray.sex,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// LOCATION
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          stray.locations.isEmpty
                              ? "No location"
                              : stray.locations.join(", "),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
