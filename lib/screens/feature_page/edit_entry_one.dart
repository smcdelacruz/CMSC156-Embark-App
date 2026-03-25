import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/temp_stray_form.dart';
import 'package:flutter/services.dart';
import 'edit_entry_two.dart';
import '../../widgets/app_color.dart';
import '../../widgets/trait_chip.dart';

class EditEntryStep1 extends StatefulWidget {
  final StrayForm form; // pre-filled data
  const EditEntryStep1({super.key, required this.form});

  @override
  State<EditEntryStep1> createState() => _EditEntryStep1State();
}

class _EditEntryStep1State extends State<EditEntryStep1> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController ageController;
  late final TextEditingController nicknameController;

  final List<String> locations = [
    "Box 1",
    "CAS",
    "CFOS",
    "CDH",
    "CM",
    "CUB",
    "Dorms",
    "Dorm Area",
    "Hatchery",
    "New Admin",
    "OWL",
    "Sotech",
    "Staff House",
    "Teacher's Dorm",
    "SSF-HSU",
    "Wetlab",
  ];

  late List<String> selectedLocations;
  String? sex;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.form.name);
    ageController = TextEditingController(text: widget.form.age);
    nicknameController = TextEditingController(text: widget.form.nickname);
    selectedLocations = List.from(widget.form.locations);
    sex = widget.form.sex.isNotEmpty ? widget.form.sex : null;
    if (widget.form.imagePath.isNotEmpty) {
      _image = File(widget.form.imagePath);
    }
  }

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
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
                    if (_image != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => _image = null),
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

              // NAME + AGE
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
                          validator: (v) => v == null || v.isEmpty
                              ? "Name is required"
                              : null,
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
                        _buildLabel("Age (Optional)"),
                        _buildField(
                          ageController,
                          hint: "Enter age",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          // validator: (v) =>
                          //     v == null || v.isEmpty ? "Age is required" : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // SEX + NICKNAME
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Sex"),
                        DropdownButtonFormField<String>(
                          initialValue: sex,
                          validator: (v) =>
                              v == null || v.isEmpty ? "Sex is required" : null,
                          items: ["Male", "Female"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => sex = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Nickname/s (Optional)"),
                        _buildField(
                          nicknameController,
                          hint: "Enter nickname/s",
                          // validator: (v) => v == null || v.isEmpty
                          //     ? "Nickname is required"
                          //     : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // LOCATION
              _buildLabel("Location"),
              FormField<List<String>>(
                initialValue: selectedLocations,
                validator: (v) => v == null || v.isEmpty
                    ? "Select at least one location"
                    : null,
                builder: (state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: state.hasError
                              ? Colors.red
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: locations.map((loc) {
                          final selected = selectedLocations.contains(loc);
                          return TraitChip(
                            label: loc,
                            selected: selected,
                            onTap: () {
                              setState(() {
                                if (selected) {
                                  selectedLocations.remove(loc);
                                } else {
                                  selectedLocations.add(loc);
                                }
                                state.didChange(selectedLocations);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          state.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // NEXT BUTTON
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Save Step1 fields into form
                      widget.form.name = nameController.text;
                      widget.form.age = ageController.text;
                      widget.form.sex = sex ?? '';
                      widget.form.nickname = nicknameController.text;
                      widget.form.locations = selectedLocations;
                      widget.form.imagePath = _image?.path ?? '';

                      // Push Step2 and wait for updated Stray
                      final updatedStray = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditEntryStep2(form: widget.form),
                        ),
                      );

                      // If we got an updated Stray, pop Step1 and return it to FeaturePage
                      if (updatedStray != null && context.mounted) {
                        Navigator.pop(context, updatedStray);
                      }
                    }
                  },
                  child: const Text(
                    "Next →",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
