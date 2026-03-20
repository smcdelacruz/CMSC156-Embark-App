import 'package:flutter/material.dart';
import '../../widgets/app_color.dart';
import 'success_screen.dart';

class ConfirmSubmitScreen extends StatelessWidget {
  const ConfirmSubmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Are you sure you want to submit this entry?",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SuccessScreen()),
                );
              },
              child: const Text("Submit entry"),
            ),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Return to editing"),
            ),
          ],
        ),
      ),
    );
  }
}
