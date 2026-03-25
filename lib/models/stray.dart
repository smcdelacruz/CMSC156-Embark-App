import 'dart:convert';

class Stray {
  final String id;
  final String name;
  final String age;
  final String sex;
  final String nickname;
  final List<String> locations;
  final String imagePath;
  final String temperament;
  final String deworming;
  final String vaccination;
  final String notes;
  final bool isArchived;

  Stray({
    required this.id,
    required this.name,
    required this.age,
    required this.sex,
    required this.nickname,
    required this.locations,
    required this.imagePath,
    required this.temperament,
    required this.deworming,
    required this.vaccination,
    required this.notes,
    this.isArchived = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'sex': sex,
      'nickname': nickname,
      'locations': locations,
      'imagePath': imagePath,
      'temperament': temperament,
      'deworming': deworming,
      'vaccination': vaccination,
      'notes': notes,
      'isArchived': isArchived,
    };
  }

  factory Stray.fromMap(Map<String, dynamic> map) {
    return Stray(
      id: map['id'] ?? map['name'],
      name: map['name'] ?? '',
      age: map['age'] ?? '',
      sex: map['sex'] ?? '',
      nickname: map['nickname'] ?? '',
      locations: List<String>.from(map['locations'] ?? []),
      imagePath: map['imagePath'] ?? '',
      temperament: map['temperament'] ?? '',
      deworming: map['deworming'] ?? '',
      vaccination: map['vaccination'] ?? '',
      notes: map['notes'] ?? '',
      isArchived: map['isArchived'] ?? false,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Stray.fromJson(String source) => Stray.fromMap(jsonDecode(source));
}
