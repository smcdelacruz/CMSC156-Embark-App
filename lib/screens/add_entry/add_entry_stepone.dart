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
  final nicknameController = TextEditingController();

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

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('age', ageController.text);
    await prefs.setString('nicknames', nicknameController.text);
    await prefs.setString('sex', sex ?? '');
    await prefs.setStringList('locations', selectedLocations);
    if (_image != null) await prefs.setString('imagePath', _image!.path);
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    ),
  );

  Widget _buildField(
    TextEditingController controller, {
    String hint = "",
    TextInputType keyboardType = TextInputType.text,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
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

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    nicknameController.dispose();
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
                colors: [
                  Color(0xFFE9A08C),
                  Color(0xFFE9A08C),
                ], // salmon gradient
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

              /// NAME + AGE (row)
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Name"),
                        _buildField(nameController, hint: "Enter name"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Age"),
                        _buildField(
                          ageController,
                          hint: "Enter age",
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// SEX + NICKNAME (row)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Sex"),
                        DropdownButtonFormField<String>(
                          value: sex,
                          items: ["Male", "Female"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => sex = val),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: AppColors.primary.withOpacity(0.6),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Nickname/s"),
                        _buildField(
                          nicknameController,
                          hint: "Enter nickname/s",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// LOCATION
              _buildLabel("Location"),
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
              const SizedBox(height: 32),

              /// NEXT BUTTON
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
      ),
    );
  }
}
