/// Patient domain model
///
/// Represents a patient in the hospital system with personal information,
/// medical history, and current status (admitted/discharged).
library;

import 'package:dart_clinic/domain/models/person.dart';

class PatientModel extends PersonModel {
  PatientModel({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    required super.phoneNumber,
    required super.email,
    required super.address,
  });
}
