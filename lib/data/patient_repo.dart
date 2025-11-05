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
    );
  }
}
