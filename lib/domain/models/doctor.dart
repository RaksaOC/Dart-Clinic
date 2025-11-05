/// Doctor domain model
///
/// Represents a doctor in the hospital system with basic information
/// and capabilities for managing appointments and prescriptions.
library;

import 'package:dart_clinic/domain/models/staff.dart';

class DoctorModel extends StaffModel {
  final String specialization;

  DoctorModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.email,
    required super.address,
    required super.age,
    required super.gender,
    required this.specialization,
    required super.password,
  });
}
