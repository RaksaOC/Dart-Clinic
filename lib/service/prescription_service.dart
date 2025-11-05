/// Prescription Service
///
/// Handles business logic for prescription operations including:
/// - Issuing new prescriptions
/// - Tracking prescription status
/// - Managing prescription expiration
///
/// Coordinates between the UI layer and prescription repository.
library;

import '../domain/prescription.dart';
import '../data/prescription_repo.dart';

class PrescriptionService {
  final PrescriptionRepository _prescriptionRepository;

  PrescriptionService(this._prescriptionRepository);

  /// Issue a new prescription
  Prescription? issuePrescription({
    required String prescriptionId,
    required String doctorId,
    required String patientId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required int durationDays,
    required String instructions,
    String? notes,
  }) {
    final prescription = Prescription(
      id: prescriptionId,
      doctorId: doctorId,
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
  List<Prescription> getPatientPrescriptions(String patientId) {
    final prescriptions = _prescriptionRepository.getAll();
    return prescriptions
        .where((prescription) => prescription.patientId == patientId)
        .toList();
  }

  /// Get all prescriptions for a doctor
  List<Prescription> getDoctorPrescriptions(String doctorId) {
    final prescriptions = _prescriptionRepository.getAll();
    return prescriptions
        .where((prescription) => prescription.doctorId == doctorId)
        .toList();
  }
}
