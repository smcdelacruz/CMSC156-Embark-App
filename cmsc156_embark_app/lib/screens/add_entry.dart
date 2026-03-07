import 'package:flutter/material.dart';

// ─── Colour palette (from mockup) ───────────────────────────────────────────
const _salmon = Color(0xFFE8816A);
const _salmonLight = Color(0xFFF2A899);
const _peach = Color(0xFFFDE8E2);
const _chipSelected = Color(0xFFE8816A);
const _chipUnselected = Color(0xFFFFD6C8);
const _bg = Color(0xFFFFF8F6);

// ─── Entry point ─────────────────────────────────────────────────────────────
class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  int _step = 0; // 0‑3

  // Step 1 fields
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  String? _sex;
  final _speciesCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  String? _healthStatus;

  // Step 2 fields
  final List<String> _allTraits = [
    'Sweet',
    'Intelligent',
    'Clingy',
    'Loyal',
    'Friendly',
    'Calm',
    'Lively',
    'Energetic',
    'Persistent',
    'Sociable',
    'Clever',
  ];
  final Set<String> _selectedTraits = {};
  final _descCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _speciesCtrl.dispose();
    _locationCtrl.dispose();
    _descCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  // ─── Navigation ────────────────────────────────────────────────────────────
  void _next() => setState(() => _step++);
  void _back() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
    } else {
      setState(() => _step--);
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: KeyedSubtree(
          key: ValueKey(_step),
          child: switch (_step) {
            0 => _StepOne(
              nameCtrl: _nameCtrl,
              ageCtrl: _ageCtrl,
              sex: _sex,
              onSexChanged: (v) => setState(() => _sex = v),
              speciesCtrl: _speciesCtrl,
              locationCtrl: _locationCtrl,
              healthStatus: _healthStatus,
              onHealthChanged: (v) => setState(() => _healthStatus = v),
              onNext: _next,
            ),
            1 => _StepTwo(
              allTraits: _allTraits,
              selectedTraits: _selectedTraits,
              onTraitToggle: (t) => setState(() {
                if (_selectedTraits.contains(t)) {
                  _selectedTraits.remove(t);
                } else {
                  _selectedTraits.add(t);
                }
              }),
              descCtrl: _descCtrl,
              notesCtrl: _notesCtrl,
              onSubmit: _next,
            ),
            2 => _StepThree(
              allTraits: _allTraits,
              selectedTraits: _selectedTraits,
              notesCtrl: _notesCtrl,
              onSubmit: _next,
              onReturn: _back,
            ),
            _ => _StepFour(
              onBackHome: () =>
                  Navigator.of(context).popUntil((r) => r.isFirst),
            ),
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    if (_step == 3) {
      return AppBar(
        backgroundColor: _bg,
        elevation: 0,
        automaticallyImplyLeading: false,
      );
    }
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black87,
        ),
        onPressed: _back,
      ),
      title: const Text(
        'Add a Campus Stray',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      centerTitle: false,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 1 – Basic info + photo
// ─────────────────────────────────────────────────────────────────────────────
class _StepOne extends StatelessWidget {
  final TextEditingController nameCtrl, ageCtrl, speciesCtrl, locationCtrl;
  final String? sex, healthStatus;
  final ValueChanged<String?> onSexChanged, onHealthChanged;
  final VoidCallback onNext;

  const _StepOne({
    required this.nameCtrl,
    required this.ageCtrl,
    required this.sex,
    required this.onSexChanged,
    required this.speciesCtrl,
    required this.locationCtrl,
    required this.healthStatus,
    required this.onHealthChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Photo picker area
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                Positioned(
                  bottom: -8,
                  right: -8,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: _salmon,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Upload your photo here.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),

          // Name + Age row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _LabeledField(
                  label: 'Name',
                  child: _OutlineField(controller: nameCtrl, hint: ''),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _LabeledField(
                  label: 'Age',
                  child: _OutlineField(
                    controller: ageCtrl,
                    hint: '',
                    keyboardType: TextInputType.number,
                    suffix: const Icon(Icons.expand_more, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Sex + Species row
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'Sex',
                  child: _DropdownField<String>(
                    value: sex,
                    items: const ['Male', 'Female'],
                    onChanged: onSexChanged,
                    hint: '–',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _LabeledField(
                  label: 'Species',
                  child: _OutlineField(controller: speciesCtrl, hint: ''),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _LabeledField(
            label: 'Location',
            child: _OutlineField(controller: locationCtrl, hint: ''),
          ),
          const SizedBox(height: 14),

          _LabeledField(
            label: 'Health Status',
            child: _DropdownField<String>(
              value: healthStatus,
              items: const ['Healthy', 'Injured', 'Sick', 'Unknown'],
              onChanged: onHealthChanged,
              hint: '–',
            ),
          ),
          const SizedBox(height: 32),

          _SalmonButton(label: 'Next →', onPressed: onNext),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 2 – Traits + Description + Notes
// ─────────────────────────────────────────────────────────────────────────────
class _StepTwo extends StatelessWidget {
  final List<String> allTraits;
  final Set<String> selectedTraits;
  final ValueChanged<String> onTraitToggle;
  final TextEditingController descCtrl, notesCtrl;
  final VoidCallback onSubmit;

  const _StepTwo({
    required this.allTraits,
    required this.selectedTraits,
    required this.onTraitToggle,
    required this.descCtrl,
    required this.notesCtrl,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Traits',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          _TraitWrap(
            allTraits: allTraits,
            selectedTraits: selectedTraits,
            onToggle: onTraitToggle,
          ),
          const SizedBox(height: 20),
          const Text(
            'Description',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          _OutlineField(controller: descCtrl, hint: '', maxLines: 4),
          const SizedBox(height: 20),
          const Text(
            'Notes (Optional)',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          _OutlineField(controller: notesCtrl, hint: '', maxLines: 3),
          const SizedBox(height: 32),
          _SalmonButton(label: 'Submit Entry', onPressed: onSubmit),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 3 – Confirmation dialog overlay feel
// ─────────────────────────────────────────────────────────────────────────────
class _StepThree extends StatelessWidget {
  final List<String> allTraits;
  final Set<String> selectedTraits;
  final TextEditingController notesCtrl;
  final VoidCallback onSubmit, onReturn;

  const _StepThree({
    required this.allTraits,
    required this.selectedTraits,
    required this.notesCtrl,
    required this.onSubmit,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background content
        Opacity(
          opacity: 0.35,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Traits',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                _TraitWrap(
                  allTraits: allTraits,
                  selectedTraits: selectedTraits,
                  onToggle: (_) {},
                ),
                const SizedBox(height: 20),
                const Text(
                  'Notes (Optional)',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                _OutlineField(
                  controller: notesCtrl,
                  hint: '',
                  maxLines: 3,
                  enabled: false,
                ),
              ],
            ),
          ),
        ),

        // Confirmation card
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Are you sure you want\nto submit this entry?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pressing on submit entry will\nmake your entry final.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  _SalmonButton(label: 'Submit entry', onPressed: onSubmit),
                  const SizedBox(height: 12),
                  _OutlineButton(
                    label: 'Return to editing',
                    onPressed: onReturn,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 4 – Success
// ─────────────────────────────────────────────────────────────────────────────
class _StepFour extends StatelessWidget {
  final VoidCallback onBackHome;

  const _StepFour({required this.onBackHome});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: _peach,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'You have submitted\nan entry!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Your entry has been submitted to the verification page to be voted on. '
              'You may check your notification in around 1–2 days if it has been approved. Thank you!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 32),
            _SalmonButton(label: 'Back to Home', onPressed: onBackHome),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _TraitWrap extends StatelessWidget {
  final List<String> allTraits;
  final Set<String> selectedTraits;
  final ValueChanged<String> onToggle;

  const _TraitWrap({
    required this.allTraits,
    required this.selectedTraits,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...allTraits.map((t) {
          final sel = selectedTraits.contains(t);
          return GestureDetector(
            onTap: () => onToggle(t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: sel ? _chipSelected : _chipUnselected,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                t,
                style: TextStyle(
                  color: sel ? Colors.white : Colors.black87,
                  fontSize: 13,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: _chipUnselected,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 18, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class _OutlineField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final bool enabled;

  const _OutlineField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.suffix,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      enabled: enabled,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _salmon),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String hint;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(
        hint,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _salmon),
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(e.toString(), style: const TextStyle(fontSize: 14)),
            ),
          )
          .toList(),
    );
  }
}

class _SalmonButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _SalmonButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _salmon,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        child: Text(label),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _OutlineButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: _salmon,
          side: const BorderSide(color: _salmon, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}
