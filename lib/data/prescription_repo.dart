/// Prescription Repository
///
/// Responsible for data persistence operations for prescriptions.
/// Handles CRUD operations for prescription entities stored in JSON format.
library;

import 'repo_base.dart';
import '../domain/prescription.dart';

class PrescriptionRepository extends RepositoryBase<Prescription> {
  PrescriptionRepository() : super('lib/db/prescriptions.json');

  @override
  Map<String, dynamic> toJson(Prescription entity) {
    return {
      'id': entity.id,
      'doctorId': entity.doctorId,
      'patientId': entity.patientId,
      'medicationName': entity.medicationName,
      'dosage': entity.dosage,
      'frequency': entity.frequency,
      'durationDays': entity.durationDays,
      'instructions': entity.instructions,
      'issueDate': entity.issueDate.toIso8601String(),
      'status': entity.status,
      'notes': entity.notes,
    };
  }

  @override
  Prescription fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      patientId: json['patientId'] as String,
      medicationName: json['medicationName'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      durationDays: json['durationDays'] as int,
      instructions: json['instructions'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String?,
    );
  }

  /// Get prescriptions by doctor ID
  Future<List<Prescription>> getByDoctorId(String doctorId) async {
    final prescriptions = await loadAll();
    return prescriptions
        .where((prescription) => prescription.doctorId == doctorId)
        .toList();
  }

  /// Get prescriptions by patient ID
  Future<List<Prescription>> getByPatientId(String patientId) async {
    final prescriptions = await loadAll();
    return prescriptions
        .where((prescription) => prescription.patientId == patientId)
        .toList();
  }

  /// Get prescriptions by status
  Future<List<Prescription>> getByStatus(String status) async {
    final prescriptions = await loadAll();
    return prescriptions
        .where((prescription) => prescription.status == status)
        .toList();
  }

  /// Get active prescriptions for a patient
  Future<List<Prescription>> getActiveByPatientId(String patientId) async {
    final prescriptions = await loadAll();
    return prescriptions.where((prescription) {
      return prescription.patientId == patientId &&
          prescription.status == 'active';
    }).toList();
  }
}
