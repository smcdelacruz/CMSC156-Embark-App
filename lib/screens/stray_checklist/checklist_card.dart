import 'package:flutter/material.dart';

class ChecklistCard extends StatelessWidget {
  final String title;
  final int completed;
  final int total;
  final VoidCallback onTap;

  const ChecklistCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = completed == total;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDone
              ? const Color(0xFFFFB5A7)
              : const Color.fromARGB(255, 219, 216, 216).withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 77, 77, 77),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$completed/$total",
                  style: const TextStyle(color: Color.fromARGB(255, 77, 77, 77), fontSize: 12),
                ),
              ],
            ),
            const Positioned(
              bottom: -6,
              right: -6,
              child: Icon(Icons.pets, size: 84, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
