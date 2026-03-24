import 'package:flutter/material.dart';

class FeatureMenuDropdown extends StatelessWidget {
  final bool isArchived;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onUnarchive;
  final VoidCallback? onDelete;

  const FeatureMenuDropdown({ super.key, required this.isArchived, this.onEdit,
   this.onArchive, this.onUnarchive, this.onDelete,});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color(0xFFF9DCC4),
      child: PopupMenuButton<String>(
        icon: const Icon(
          Icons.more_horiz, 
          color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),

        onSelected:(value) => (String option) {
          if (option == 'Edit') onEdit?.call();
          if (option == 'Archive') onArchive?.call();
          if (option == 'Unarchive') onUnarchive?.call();
          if (option == 'Delete') onDelete?.call();
        },

        itemBuilder: (BuildContext context) {
          if (isArchived) {
            return [
              const PopupMenuItem<String>(
                value: 'Unarchive',
                child: Row(
                  children: [
                    Icon(
                      Icons.unarchive_rounded, 
                      color: Colors.black54, 
                      size: 18
                    ),
                    SizedBox(width: 8),
                    Text('Unarchive'),
                  ],
                ),
              ),

              const PopupMenuItem<String>(
                value: 'Delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_rounded, 
                      color: Colors.black54, 
                      size: 18
                    ),
                    SizedBox(width: 8),
                    Text('Delete forever'),
                  ],
                ),
              ),
            ];
          }
          else {
            return [
              const PopupMenuItem<String>(
                value: 'Edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_rounded, 
                      color: Colors.black54, 
                      size: 18
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
                      Icons.archive_rounded, 
                      color: Colors.black54, 
                      size: 18
                    ),
                    SizedBox(width: 8),
                    Text('Archive'),
                  ],
                ),
              ),
            ];
          }
        },
      ),
    );
  }
}