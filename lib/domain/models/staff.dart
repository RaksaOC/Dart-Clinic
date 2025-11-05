/// Staff domain model
///
/// Base model for staff members extending PersonModel with authentication.
library;

import 'package:dart_clinic/domain/models/person.dart';

class StaffModel extends PersonModel {
  final String password;

  StaffModel({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    required super.phoneNumber,
    required super.email,
    required super.address,
    required this.password,
  });
}
