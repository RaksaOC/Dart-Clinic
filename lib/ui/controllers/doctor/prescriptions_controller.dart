/// Prescriptions Controller (Doctor)
library;

import '../../../domain/services/prescription_service.dart';
import '../../../domain/models/prescription.dart';

class PrescriptionsController {
  final PrescriptionService _prescriptionService;

  PrescriptionsController({
    PrescriptionService? prescriptionService,
  }) : _prescriptionService = prescriptionService ?? PrescriptionService();

  PrescriptionModel? issuePrescription({
    required String patientId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required int durationDays,
    required String instructions,
    String? notes,
  }) {
    return _prescriptionService.issuePrescription(
      patientId: patientId,
      medicationName: medicationName,
      dosage: dosage,
      frequency: frequency,
      durationDays: durationDays,
      instructions: instructions,
      notes: notes,
    );
  }

  PrescriptionModel? getPrescriptionById(String id) {
    return _prescriptionService.getById(id);
  }

  List<PrescriptionModel> getPatientPrescriptions(String patientId) {
    return _prescriptionService.getPatientPrescriptions(patientId);
  }

  List<PrescriptionModel> getMyPrescriptions() {
    return _prescriptionService.getMyPrescriptions();
  }
}
