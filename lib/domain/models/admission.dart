/// Admission domain model
///
/// Represents a patient admission to a room, connecting a patient with a room
/// and tracking admission details including dates and status.
library;

import 'package:dart_clinic/domain/models/status.dart';

class AdmissionModel {
  final String id;
  final String patientId;
  final String roomId;
  final DateTime admissionDate;
  final DateTime? dischargeDate;
  final AdmissionStatus status;
  final String? notes;

  AdmissionModel({
    required this.id,
    required this.patientId,
    required this.roomId,
    required this.admissionDate,
    this.dischargeDate,
    required this.status,
    this.notes,
  });
}
