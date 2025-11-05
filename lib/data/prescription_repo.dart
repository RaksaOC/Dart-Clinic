/// Prescription Repository
///
/// Responsible for data persistence operations for prescriptions.
/// Handles CRUD operations for prescription entities stored in JSON format.
library;

import 'repo_base.dart';
import '../domain/models/prescription.dart';

class PrescriptionRepository extends RepositoryBase<PrescriptionModel> {
  PrescriptionRepository() : super('db/prescriptions.json');

  @override
  Map<String, dynamic> toJson(PrescriptionModel entity) {
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
      'notes': entity.notes,
    };
  }

  @override
  PrescriptionModel fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      patientId: json['patientId'] as String,
      medicationName: json['medicationName'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      durationDays: json['durationDays'] as int,
      instructions: json['instructions'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      notes: json['notes'] as String?,
    );
  }
}
