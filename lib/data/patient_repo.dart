/// Patient Repository
///
/// Responsible for data persistence operations for patients.
/// Handles CRUD operations for patient entities stored in JSON format.
library;

import 'repo_base.dart';
import '../domain/patient.dart';

class PatientRepository extends RepositoryBase<Patient> {
  PatientRepository() : super('lib/db/patients.json');

  @override
  Map<String, dynamic> toJson(Patient entity) {
    return {
      'id': entity.id,
      'name': entity.name,
      'age': entity.age,
      'gender': entity.gender,
      'phoneNumber': entity.phoneNumber,
      'email': entity.email,
      'address': entity.address,
      'bloodType': entity.bloodType,
      'allergies': entity.allergies,
      'isAdmitted': entity.isAdmitted,
    };
  }

  @override
  Patient fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      bloodType: json['bloodType'] as String?,
      allergies: json['allergies'] as String?,
      isAdmitted: json['isAdmitted'] as bool,
    );
  }

  /// Search patients by name
  Future<List<Patient>> getByName(String name) async {
    final patients = await loadAll();
    final lowerName = name.toLowerCase();
    return patients
        .where((patient) => patient.name.toLowerCase().contains(lowerName))
        .toList();
  }

  /// Get admitted patients
  Future<List<Patient>> getAdmittedPatients() async {
    final patients = await loadAll();
    return patients.where((patient) => patient.isAdmitted).toList();
  }

  /// Get patients by gender
  Future<List<Patient>> getByGender(String gender) async {
    final patients = await loadAll();
    return patients.where((patient) => patient.gender == gender).toList();
  }
}
