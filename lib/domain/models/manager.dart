/// Manager domain model
///
/// Represents a manager in the hospital system with access to
/// system-wide management operations including creating rooms and assigning patients.
library;

import 'package:dart_clinic/domain/models/staff.dart';

class ManagerModel extends StaffModel {
  ManagerModel({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    required super.phoneNumber,
    required super.email,
    required super.address,
    required super.password,
  });
}
