import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_entry_steptwo.dart';
import '../../widgets/app_color.dart';
import '../../widgets/trait_chip.dart';

class AddEntryStep1 extends StatefulWidget {
  const AddEntryStep1({super.key});

  @override
  State<AddEntryStep1> createState() => _AddEntryStep1State();
}

class _AddEntryStep1State extends State<AddEntryStep1> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final speciesController = TextEditingController();

  final List<String> locations = [
    "CAS",
    "CFOS",
    "CM",
    "CUB",
    "Dorms",
    "New Admin",
    "Staff House",
    "SSF-HSU",
  ];

  List<String> selectedLocations = [];

  String? sex;
  String? health;
  String? location;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  /// PICK IMAGE
  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  /// SAVE DATA
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', nameController.text);
    await prefs.setString('age', ageController.text);
    await prefs.setString('species', speciesController.text);
    await prefs.setString('location', location ?? '');
    await prefs.setString('sex', sex ?? '');
    await prefs.setString('health', health ?? '');

    if (_image != null) {
      await prefs.setString('imagePath', _image!.path);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    speciesController.dispose();
    super.dispose();
  }

  /// INPUT STYLE
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
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
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// IMAGE UPLOAD
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F1EE),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.image, size: 32),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Upload your photo here.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// NAME + AGE
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: nameController,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                      decoration: _inputDecoration("Name"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                      decoration: _inputDecoration("Age"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// SEX + SPECIES
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: sex,
                      hint: const Text("Sex"),
                      items: ["Male", "Female"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => sex = val),
                      validator: (v) => v == null ? "Required" : null,
                      decoration: _inputDecoration("Sex"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: speciesController,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                      decoration: _inputDecoration("Species"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// LOCATION
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Location",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    children: locations.map((loc) {
                      final isSelected = selectedLocations.contains(loc);
                      return TraitChip(
                        label: loc,
                        selected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedLocations.remove(loc);
                            } else {
                              selectedLocations.add(loc);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  if (selectedLocations.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        "Required",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              /// HEALTH
              DropdownButtonFormField<String>(
                value: health,
                hint: const Text("Health Status"),
                items: ["Healthy", "Injured", "Sick"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => health = val),
                validator: (v) => v == null ? "Required" : null,
                decoration: _inputDecoration("Health Status"),
              ),

              const SizedBox(height: 32),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE9A08C),
                    elevation: 4,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await saveToPrefs();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddEntryStep2(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Next →",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
