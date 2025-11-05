/// Doctor Repository
///
/// Responsible for data persistence operations for doctors.
/// Handles CRUD operations for doctor entities stored in JSON format.
library;

import 'repo_base.dart';
import '../domain/models/doctor.dart';

class DoctorRepository extends RepositoryBase<DoctorModel> {
  DoctorRepository() : super('db/doctors.json');

  @override
  Map<String, dynamic> toJson(DoctorModel entity) {
    return {
      'id': entity.id,
      'name': entity.name,
      'specialization': entity.specialization,
      'phoneNumber': entity.phoneNumber,
      'email': entity.email,
      'address': entity.address,
      'age': entity.age,
      'gender': entity.gender,
      'password': entity.password,
    };
  }

  @override
  DoctorModel fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      specialization: json['specialization'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      password: json['password'] as String,
    );
  }
}
