import 'package:flutter/material.dart';
import '../models/stray.dart';
import '../models/stray_storage.dart';

/// ARCHIVE DIALOG
void showArchiveDialog(BuildContext parentContext, Stray stray) {
  showDialog(
    
    context: parentContext,
    builder: (dialogContext) => AlertDialog(
      title: const Text("Archive Entry"),
      content: const Text("Are you sure you want to archive this entry?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext), // Closes dialog
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext); // Close the dialog

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
              notes: stray.notes,
              isArchived: true,
            );

            // Saves to database
            await StrayStorage.updateStray(archivedStray);

            // Returns to the Home list safely
            if (parentContext.mounted) {
              Navigator.pop(parentContext);
            }
          },
          child: const Text("Archive", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

/// DELETE DIALOG
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
          onPressed: () => Navigator.pop(dialogContext), // Closes dialog
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext); // Closes dialog

            // Deletes the stray from the database entirely
            await StrayStorage.deleteStray(stray.id);

            // Pops the FeaturePage to return to the Archive list safely
            if (parentContext.mounted) {
              Navigator.pop(parentContext);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red.withValues(alpha: 0.1),
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