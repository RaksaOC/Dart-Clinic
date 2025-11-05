/// Appointment domain model
///
/// Represents an appointment between a doctor and a patient
/// with scheduling information and status tracking.
library;

import 'package:dart_clinic/domain/prescription.dart';
import 'package:dart_clinic/domain/status.dart';

class Appointment {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime appointmentDateTime;
  final String? notes;
  final String? diagnosis;
  final Prescription? prescription;
  final DateTime? createdAt;
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.appointmentDateTime,
    required this.status,
    this.notes,
    this.diagnosis,
    this.prescription,
    this.createdAt,
  });
}
