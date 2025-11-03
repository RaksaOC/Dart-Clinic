/// Appointment domain model
///
/// Represents an appointment between a doctor and a patient
/// with scheduling information and status tracking.
library;

class Appointment {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime appointmentDateTime;
  final String status; // scheduled, completed, cancelled, missed
  final String? notes;
  final String? diagnosis;
  final DateTime? createdAt;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.appointmentDateTime,
    required this.status,
    this.notes,
    this.diagnosis,
    this.createdAt,
  });
}
