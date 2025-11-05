/// Prescriptions Controller (Doctor)
library;

import '../../../services/prescription_service.dart';
import '../../../services/patient_service.dart';
import '../../../domain/models/prescription.dart';

class PrescriptionsController {
  final PrescriptionService _prescriptionService;
  final PatientService _patientService;

  PrescriptionsController({
    PrescriptionService? prescriptionService,
    PatientService? patientService,
  }) : _prescriptionService = prescriptionService ?? PrescriptionService(),
       _patientService = patientService ?? PatientService();

  PrescriptionModel? issuePrescription({
    required String patientId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required int durationDays,
    required String instructions,
    String? notes,
  }) {
    if (_patientService.getPatientById(patientId) == null) return null;
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
