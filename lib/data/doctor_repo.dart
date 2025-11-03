/// Doctor Repository
///
/// Responsible for data persistence operations for doctors.
/// Handles CRUD operations for doctor entities stored in JSON format.
library;

import 'repo_base.dart';
import '../domain/doctor.dart';

class DoctorRepository extends RepositoryBase<Doctor> {
  DoctorRepository() : super('lib/db/doctors.json');

  @override
  Map<String, dynamic> toJson(Doctor entity) {
    return {
      'id': entity.id,
      'name': entity.name,
      'specialization': entity.specialization,
      'phoneNumber': entity.phoneNumber,
      'email': entity.email,
    };
  }

  @override
  Doctor fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      specialization: json['specialization'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
    );
  }

  /// Get doctors by specialization
  Future<List<Doctor>> getBySpecialization(String specialization) async {
    final doctors = await loadAll();
    return doctors
        .where((doctor) => doctor.specialization == specialization)
        .toList();
  }

  /// Search doctors by name
  Future<List<Doctor>> getByName(String name) async {
    final doctors = await loadAll();
    final lowerName = name.toLowerCase();
    return doctors
        .where((doctor) => doctor.name.toLowerCase().contains(lowerName))
        .toList();
  }
}
