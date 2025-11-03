/// Patient domain model
///
/// Represents a patient in the hospital system with personal information,
/// medical history, and current status (admitted/discharged).
library;

class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String phoneNumber;
  final String email;
  final String address;
  final String? bloodType;
  final String? allergies;
  final bool isAdmitted;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.address,
    this.bloodType,
    this.allergies,
    this.isAdmitted = false,
  });
}
