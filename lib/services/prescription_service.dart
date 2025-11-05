/// Prescription Service
///
/// Handles business logic for prescription operations including:
/// - Issuing new prescriptions
/// - Tracking prescription status
/// - Managing prescription expiration
///
/// Coordinates between the UI layer and prescription repository.
library;

import '../domain/models/prescription.dart';
import '../data/prescription_repo.dart';
import 'package:dart_clinic/services/session_service.dart';
import 'package:uuid/uuid.dart';

class PrescriptionService {
  final PrescriptionRepository _prescriptionRepository;

  PrescriptionService([PrescriptionRepository? repository])
    : _prescriptionRepository = repository ?? PrescriptionRepository();

  /// Issue a new prescription
  PrescriptionModel? issuePrescription({
    required String patientId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required int durationDays,
    required String instructions,
    String? notes,
  }) {
    final currentDoctor = SessionService().currentDoctor;
    if (currentDoctor == null) return null;
    final String id = const Uuid().v4();
    // Uniqueness check
    if (_prescriptionRepository.getById(id) != null) {
      return null;
    }
    final prescription = PrescriptionModel(
      id: id,
      doctorId: currentDoctor.id,
      patientId: patientId,
      medicationName: medicationName,
      dosage: dosage,
      frequency: frequency,
      durationDays: durationDays,
      instructions: instructions,
      issueDate: DateTime.now(),
      notes: notes,
    );
    return _prescriptionRepository.create(prescription);
  }

  /// Get all prescriptions for a patient
  List<PrescriptionModel> getPatientPrescriptions(String patientId) {
    final prescriptions = _prescriptionRepository.getAll();
    return prescriptions
        .where((prescription) => prescription.patientId == patientId)
        .toList();
  }

  /// Get all prescriptions for a doctor
  List<PrescriptionModel> getMyPrescriptions() {
    final currentDoctor = SessionService().currentDoctor;
    final prescriptions = _prescriptionRepository.getAll();
    if (currentDoctor == null) return [];
    return prescriptions
        .where((prescription) => prescription.doctorId == currentDoctor.id)
        .toList();
  }

  /// Get prescription by id
  PrescriptionModel? getById(String id) {
    final p = _prescriptionRepository.getById(id);
    if (p == null) return null;
    final currentDoctor = SessionService().currentDoctor;
    if (currentDoctor != null && p.doctorId != currentDoctor.id) {
      return null;
    }
    return p;
  }
}
