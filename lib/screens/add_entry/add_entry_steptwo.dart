import 'package:flutter/material.dart';
import '../widgets/app_color.dart';
import 'confirm_submit.dart';

class AddEntryStep2 extends StatefulWidget {
  const AddEntryStep2({super.key});

  @override
  State<AddEntryStep2> createState() => _AddEntryStep2State();
}

class _AddEntryStep2State extends State<AddEntryStep2> {
  final traits = [
    "Sweet",
    "Intelligent",
    "Clingy",
    "Loyal",
    "Friendly",
    "Calm",
    "Lively",
    "Energetic",
    "Persistent",
    "Sociable",
    "Clever",
  ];

  final selectedTraits = <String>{};
  final descriptionController = TextEditingController();
  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          "Add a Campus Stray",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            /// Traits label
            const Text(
              "Traits",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),

            /// Trait chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...traits.map(
                  (trait) => _TraitChip(
                    label: trait,
                    selected: selectedTraits.contains(trait),
                    onTap: () {
                      setState(() {
                        selectedTraits.contains(trait)
                            ? selectedTraits.remove(trait)
                            : selectedTraits.add(trait);
                      });
                    },
                  ),
                ),
                // "Add more" chip
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      "+",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Description field
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            _MultilineField(
              controller: descriptionController,
              hint: "",
              minLines: 3,
            ),

            const SizedBox(height: 20),

            /// Notes field
            const Text(
              "Notes (Optional)",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            _MultilineField(controller: notesController, hint: "", minLines: 3),

            const SizedBox(height: 32),

            /// Submit button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const ConfirmSubmitScreen(),
                  );
                },
                child: const Text(
                  "Submit Entry",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _TraitChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TraitChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _MultilineField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int minLines;

  const _MultilineField({
    required this.controller,
    required this.hint,
    this.minLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: null,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.6),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
