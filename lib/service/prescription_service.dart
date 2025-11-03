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
  Future<Prescription?> issuePrescription({
    required String prescriptionId,
    required String doctorId,
    required String patientId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required int durationDays,
    required String instructions,
    String? notes,
  }) async {
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
      status: 'active',
      notes: notes,
    );
    return await _prescriptionRepository.create(prescription);
  }

  /// Cancel an active prescription
  Future<bool> cancelPrescription(String prescriptionId) async {
    final prescription = await _prescriptionRepository.getById(prescriptionId);
    if (prescription == null || prescription.status != 'active') {
      return false;
    }

    final cancelledPrescription = Prescription(
      id: prescription.id,
      doctorId: prescription.doctorId,
      patientId: prescription.patientId,
      medicationName: prescription.medicationName,
      dosage: prescription.dosage,
      frequency: prescription.frequency,
      durationDays: prescription.durationDays,
      instructions: prescription.instructions,
      issueDate: prescription.issueDate,
      status: 'cancelled',
      notes: prescription.notes,
    );

    return await _prescriptionRepository.update(cancelledPrescription);
  }

  /// Get all prescriptions for a patient
  Future<List<Prescription>> getPatientPrescriptions(String patientId) async {
    return await _prescriptionRepository.getByPatientId(patientId);
  }

  /// Get active prescriptions for a patient
  Future<List<Prescription>> getActivePrescriptions(String patientId) async {
    return await _prescriptionRepository.getActiveByPatientId(patientId);
  }

  /// Get all prescriptions for a doctor
  Future<List<Prescription>> getDoctorPrescriptions(String doctorId) async {
    return await _prescriptionRepository.getByDoctorId(doctorId);
  }

  /// Get prescriptions by status
  Future<List<Prescription>> getByStatus(String status) async {
    return await _prescriptionRepository.getByStatus(status);
  }

  /// Get expired prescriptions
  Future<List<Prescription>> getExpiredPrescriptions() async {
    final allPrescriptions = await _prescriptionRepository.getAll();
    return allPrescriptions
        .where(
          (p) => p.issueDate
              .add(Duration(days: p.durationDays))
              .isBefore(DateTime.now()),
        )
        .toList();
  }
}
