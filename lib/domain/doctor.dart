/// Doctor domain model
///
/// Represents a doctor in the hospital system with basic information
/// and capabilities for managing appointments and prescriptions.
library;

class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String phoneNumber;
  final String email;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.phoneNumber,
    required this.email,
  });
}
