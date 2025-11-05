/// Appointment Repository
///
/// Responsible for data persistence operations for appointments.
/// Handles CRUD operations for appointment entities stored in JSON format.
library;

import 'package:dart_clinic/domain/models/status.dart';

import 'repo_base.dart';
import '../domain/models/appointment.dart';

class AppointmentRepository extends RepositoryBase<AppointmentModel> {
  AppointmentRepository() : super('lib/db/appointments.json');

  @override
  Map<String, dynamic> toJson(AppointmentModel entity) {
    return {
      'id': entity.id,
      'doctorId': entity.doctorId,
      'patientId': entity.patientId,
      'appointmentDateTime': entity.appointmentDateTime.toIso8601String(),
      'status': entity.status.name,
      'notes': entity.notes,
      'diagnosis': entity.diagnosis,
      'createdAt': entity.createdAt?.toIso8601String(),
    };
  }

  @override
  AppointmentModel fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      patientId: json['patientId'] as String,
      appointmentDateTime: DateTime.parse(
        json['appointmentDateTime'] as String,
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      notes: json['notes'] as String?,
      diagnosis: json['diagnosis'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}
