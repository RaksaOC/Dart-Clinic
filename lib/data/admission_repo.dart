/// Admission Repository
///
/// Responsible for data persistence operations for admissions.
/// Handles CRUD operations for admission entities stored in JSON format.
library;

import 'package:dart_clinic/domain/models/status.dart';

import 'repo_base.dart';
import '../domain/models/admission.dart';

class AdmissionRepository extends RepositoryBase<AdmissionModel> {
  AdmissionRepository() : super('lib/db/admissions.json');

  @override
  Map<String, dynamic> toJson(AdmissionModel entity) {
    return {
      'id': entity.id,
      'patientId': entity.patientId,
      'roomId': entity.roomId,
      'admissionDate': entity.admissionDate.toIso8601String(),
      'dischargeDate': entity.dischargeDate?.toIso8601String(),
      'status': entity.status.name,
      'notes': entity.notes,
    };
  }

  @override
  AdmissionModel fromJson(Map<String, dynamic> json) {
    return AdmissionModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      roomId: json['roomId'] as String,
      admissionDate: DateTime.parse(json['admissionDate'] as String),
      dischargeDate: json['dischargeDate'] != null
          ? DateTime.parse(json['dischargeDate'] as String)
          : null,
      status: AdmissionStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      notes: json['notes'] as String?,
    );
  }
}
