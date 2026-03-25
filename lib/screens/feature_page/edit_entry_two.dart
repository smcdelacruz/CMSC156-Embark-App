import 'package:flutter/material.dart';
import '../../widgets/app_color.dart';
import '../../models/temp_stray_form.dart';
import '../../models/stray_storage.dart';
import '../../models/stray.dart';

class EditEntryStep2 extends StatefulWidget {
  final StrayForm form;
  const EditEntryStep2({super.key, required this.form});

  @override
  State<EditEntryStep2> createState() => _EditEntryStep2State();
}

class _EditEntryStep2State extends State<EditEntryStep2> {
  late final TextEditingController temperamentController;
  late final TextEditingController dewormingController;
  late final TextEditingController vaccinationController;
  late final TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    temperamentController = TextEditingController(
      text: widget.form.temperament,
    );
    dewormingController = TextEditingController(text: widget.form.deworming);
    vaccinationController = TextEditingController(
      text: widget.form.vaccination,
    );
    notesController = TextEditingController(text: widget.form.notes);
  }

  Future<void> _updateStray() async {
    final updated = Stray(
      id: widget.form.id,
      name: widget.form.name,
      age: widget.form.age,
      sex: widget.form.sex,
      nickname: widget.form.nickname,
      locations: widget.form.locations,
      imagePath: widget.form.imagePath,
      temperament: widget.form.temperament,
      deworming: widget.form.deworming,
      vaccination: widget.form.vaccination,
      notes: widget.form.notes,
    );

    await StrayStorage.updateStray(updated);

    if (mounted) {
      Navigator.pop(
        context,
        updated,
      ); // ✅ only pop Step2 and send updated Stray
    }
  }

  @override
  void dispose() {
    temperamentController.dispose();
    dewormingController.dispose();
    vaccinationController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        title: const Text(
          "Edit Stray Entry",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Temperament and Personality",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            _MultilineField(
              controller: temperamentController,
              hint: "Describe temperament and personality",
            ),
            const SizedBox(height: 20),

            const Text(
              "Deworming",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            _MultilineField(
              controller: dewormingController,
              hint: "Provide deworming details",
            ),
            const SizedBox(height: 20),

            const Text(
              "Vaccination",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            _MultilineField(
              controller: vaccinationController,
              hint: "Provide vaccination details",
            ),
            const SizedBox(height: 32),
            const Text(
              "Notes",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            _MultilineField(
              controller: notesController,
              hint: "Additional notes or observations",
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Save changes into form
                  widget.form.temperament = temperamentController.text;
                  widget.form.deworming = dewormingController.text;
                  widget.form.vaccination = vaccinationController.text;
                  widget.form.notes = notesController.text;

                  _updateStray(); // directly update JSON
                },
                child: const Text(
                  "Update Entry",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MultilineField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _MultilineField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 3,
      maxLines: null,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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
            color: AppColors.primary.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
