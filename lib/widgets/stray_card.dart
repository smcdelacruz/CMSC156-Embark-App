import 'dart:io';
import 'package:flutter/material.dart';
import '../models/stray.dart';

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey[300],
                child: stray.imagePath.isNotEmpty
                    ? Image.file(File(stray.imagePath), fit: BoxFit.cover)
                    : const Center(
                        child: Icon(
                          Icons.pets,
                          size: 30,
                          color: Colors.black54,
                        ),
                      ),
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
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        stray.age.isEmpty ? "" : stray.age,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  /// SEX
                  Row(
                    children: [
                      const Icon(Icons.female, size: 14, color: Colors.pink),
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
                        size: 14,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          stray.locations.isEmpty
                              ? "No location"
                              : stray.locations.join(", "),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
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
