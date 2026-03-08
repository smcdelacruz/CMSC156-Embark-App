import 'package:flutter/material.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final nicknameController = TextEditingController();
  final temperamentController = TextEditingController();
  final dewormingController = TextEditingController();
  final vaccinationController = TextEditingController();

  String? sex;
  String? location;

  final List<String> sexOptions = ["Female", "Male"];

  final List<String> locationOptions = [
    "CAS",
    "CFOS",
    "CM",
    "CUB",
    "Dorm Area",
    "New Admin",
    "Staff House",
    "SSF-HSU",
  ];

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Entry Added")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add a Stray")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// NAME
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// AGE
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// SEX DROPDOWN
              DropdownButtonFormField<String>(
                initialValue: sex,
                decoration: const InputDecoration(
                  labelText: "Sex",
                  border: OutlineInputBorder(),
                ),
                items: sexOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    sex = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              /// NICKNAME
              TextFormField(
                controller: nicknameController,
                decoration: const InputDecoration(
                  labelText: "Nickname",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// LOCATION DROPDOWN
              DropdownButtonFormField<String>(
                initialValue: location,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
                items: locationOptions
                    .map(
                      (loc) => DropdownMenuItem(value: loc, child: Text(loc)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    location = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              /// TEMPERAMENT
              TextFormField(
                controller: temperamentController,
                decoration: const InputDecoration(
                  labelText: "Temperament",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// DEWORMING
              TextFormField(
                controller: dewormingController,
                decoration: const InputDecoration(
                  labelText: "Deworming",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// VACCINATION
              TextFormField(
                controller: vaccinationController,
                decoration: const InputDecoration(
                  labelText: "Vaccination",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitForm,
                  child: const Text("Add Entry"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
