/// Appointment Repository
///
/// Responsible for data persistence operations for appointments.
/// Handles CRUD operations for appointment entities stored in JSON format.
library;

import 'repo_base.dart';
import '../domain/appointment.dart';

class AppointmentRepository extends RepositoryBase<Appointment> {
  AppointmentRepository() : super('lib/db/appointments.json');

  @override
  Map<String, dynamic> toJson(Appointment entity) {
    return {
      'id': entity.id,
      'doctorId': entity.doctorId,
      'patientId': entity.patientId,
      'appointmentDateTime': entity.appointmentDateTime.toIso8601String(),
      'status': entity.status,
      'notes': entity.notes,
      'diagnosis': entity.diagnosis,
      'createdAt': entity.createdAt?.toIso8601String(),
    };
  }

  @override
  Appointment fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      patientId: json['patientId'] as String,
      appointmentDateTime: DateTime.parse(
        json['appointmentDateTime'] as String,
      ),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      diagnosis: json['diagnosis'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  /// Get appointments by doctor ID
  Future<List<Appointment>> getByDoctorId(String doctorId) async {
    final appointments = await loadAll();
    return appointments.where((a) => a.doctorId == doctorId).toList();
  }

  /// Get appointments by patient ID
  Future<List<Appointment>> getByPatientId(String patientId) async {
    final appointments = await loadAll();
    return appointments.where((a) => a.patientId == patientId).toList();
  }

  /// Get appointments by date range
  Future<List<Appointment>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final appointments = await loadAll();
    return appointments.where((a) {
      return a.appointmentDateTime.isAfter(
            startDate.subtract(const Duration(seconds: 1)),
          ) &&
          a.appointmentDateTime.isBefore(
            endDate.add(const Duration(seconds: 1)),
          );
    }).toList();
  }

  /// Get appointments by status
  Future<List<Appointment>> getByStatus(String status) async {
    final appointments = await loadAll();
    return appointments.where((a) => a.status == status).toList();
  }
}
