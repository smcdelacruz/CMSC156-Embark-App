import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../models/temp_stray_form.dart';
import 'package:flutter/services.dart';
import 'add_entry_steptwo.dart';
import '../../widgets/app_color.dart';
import '../../widgets/trait_chip.dart';
// This is the first step of the Add Entry flow, where users input basic details about the stray.
class AddEntryStep1 extends StatefulWidget {
  const AddEntryStep1({super.key});

  @override
  State<AddEntryStep1> createState() => _AddEntryStep1State();
}

class _AddEntryStep1State extends State<AddEntryStep1> {
  final _formKey = GlobalKey<FormState>();
  final form = StrayForm();

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
    "Sotech",
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
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    validator: validator,
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
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.white,
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

                    // Remove button
                    if (_image != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _image = null), // 🔹 removes photo
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
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
                        _buildField(
                          nameController,
                          hint: "Enter name",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Name is required";
                            }
                            return null;
                          },
                        ),
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
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Age is required";
                            }
                            return null;
                          },
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
                          initialValue: sex,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Sex is required";
                            }
                            return null;
                          },
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
                                color: AppColors.primary.withValues(alpha: 0.6),
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
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Nickname is required";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// LOCATION
              _buildLabel("Location"),
              FormField<List<String>>(
                initialValue: selectedLocations,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select at least one location";
                  }
                  return null;
                },
                builder: (formFieldState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: formFieldState.hasError
                                ? Colors.red
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
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
                                  formFieldState.didChange(
                                    selectedLocations,
                                  ); // 🔥 important
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      /// ERROR TEXT (only shows when invalid)
                      if (formFieldState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            formFieldState.errorText!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      form.name = nameController.text;
                      form.age = ageController.text;
                      form.sex = sex ?? '';
                      form.nickname = nicknameController.text;
                      form.locations = selectedLocations;
                      form.imagePath = _image?.path ?? '';

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEntryStep2(form: form),
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
