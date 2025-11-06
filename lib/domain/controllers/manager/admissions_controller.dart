/// Admissions Controller (Manager)
library;

import '../../services/admission_service.dart';
import '../../../domain/models/admission.dart';

class AdmissionsController {
  final AdmissionService _admissionService;

  AdmissionsController({AdmissionService? admissionService})
    : _admissionService = admissionService ?? AdmissionService();

  AdmissionModel? getById(String id) => _admissionService.getById(id);
  List<AdmissionModel> getAllAdmissions() =>
      _admissionService.getAllAdmissions();
  List<AdmissionModel> getActiveAdmissions() =>
      _admissionService.getActiveAdmissions();
  List<AdmissionModel> getAdmissionsByPatientId(String patientId) =>
      _admissionService.getAdmissionsByPatientId(patientId);
  List<AdmissionModel> getAdmissionsByRoomId(String roomId) =>
      _admissionService.getAdmissionsByRoomId(roomId);
  AdmissionModel? getActiveByPatientId(String patientId) =>
      _admissionService.getActiveByPatientId(patientId);

  AdmissionModel? admitPatient({
    required String patientId,
    required String roomId,
    String? notes,
  }) {
    return _admissionService.admitPatient(
      patientId: patientId,
      roomId: roomId,
      notes: notes,
    );
  }

  bool dischargePatient(String admissionId) =>
      _admissionService.dischargePatient(admissionId);
}
