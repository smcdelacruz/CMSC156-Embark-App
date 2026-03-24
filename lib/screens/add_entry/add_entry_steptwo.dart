import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/app_color.dart';
import '../../models/stray.dart';
import '../../models/temp_stray_form.dart';
import 'confirm_submit.dart';
// This is the second step of the Add Entry flow, where users input additional details about the stray.
class AddEntryStep2 extends StatefulWidget {
  final StrayForm form;
  const AddEntryStep2({super.key, required this.form});

  @override
  State<AddEntryStep2> createState() => _AddEntryStep2State();
}

class _AddEntryStep2State extends State<AddEntryStep2> {
  final temperamentController = TextEditingController();
  final dewormingController = TextEditingController();
  final vaccinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final stray = Stray(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: widget.form.name,
      age: widget.form.age,
      sex: widget.form.sex,
      nickname: widget.form.nickname,
      locations: widget.form.locations,
      imagePath: widget.form.imagePath,
      temperament: widget.form.temperament,
      deworming: widget.form.deworming,
      vaccination: widget.form.vaccination,
    );

    final List<String> strayList = prefs.getStringList('stray_list') ?? [];
    strayList.add(stray.toJson());
    await prefs.setStringList('stray_list', strayList);
  }

  @override
  void dispose() {
    temperamentController.dispose();
    dewormingController.dispose();
    vaccinationController.dispose();
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

            /// Temperament
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
              minLines: 3,
            ),
            const SizedBox(height: 20),

            /// Deworming
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
              minLines: 3,
            ),
            const SizedBox(height: 20),

            /// Vaccination
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
              minLines: 3,
            ),
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
                  // ✅ SAVE STEP 2 DATA INTO FORM
                  widget.form.temperament = temperamentController.text;
                  widget.form.deworming = dewormingController.text;
                  widget.form.vaccination = vaccinationController.text;

                  showDialog(
                    context: context,
                    builder: (_) =>
                        ConfirmSubmitScreen(onConfirm: _saveToPrefs),
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
            color: AppColors.primary.withOpacity(0.6),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
