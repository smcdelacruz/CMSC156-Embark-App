import 'package:flutter/material.dart';
import '../../widgets/app_color.dart';
import 'success_screen.dart';

class ConfirmSubmitScreen extends StatelessWidget {
  final Future<void> Function() onConfirm;

  const ConfirmSubmitScreen({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            const Text(
              "Submit Entry?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            /// MESSAGE
            const Text(
              "Are you sure you want to submit this entry? This action cannot be undone.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            /// ACTIONS (RIGHT-ALIGNED)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// CANCEL
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),

                const SizedBox(width: 8),

                /// CONFIRM
                TextButton(
                  onPressed: () async {
                    await onConfirm();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SuccessScreen()),
                    );
                  },
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
